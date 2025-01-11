import os
import shlex

from conan import ConanFile
from conan.tools.files import get
from conan.errors import ConanInvalidConfiguration
from conan.tools.scm import Version


class ToolchainsConan(ConanFile):
    name = "docker-arm-cross-toolchain"
    user = "tttapa"
    package_type = "application"
    description = "Modern GCC cross-compilation toolchains for Raspberry Pi."
    homepage = "https://github.com/tttapa/docker-arm-cross-toolchain"
    settings = "os", "arch"

    _arch_triplets = {
        "armv8": "aarch64-rpi3-linux-gnu",
        # "?": "armv8-rpi3-linux-gnueabihf",
        "armv7hf": "armv7-neon-linux-gnueabihf",
        "armv6": "armv6-rpi-linux-gnueabihf",
    }

    def _get_gcc_version(self):
        tgt_gcc_version = str(self.settings_target.compiler.version)
        possible_versions = self.conan_data["supported-gcc-versions"][self.version]
        if tgt_gcc_version in possible_versions:
            return tgt_gcc_version
        for p in possible_versions:
            v = Version(p)
            tgt_v = Version(tgt_gcc_version)
            if (tgt_v.major or "") == v.major and (tgt_v.minor or v.minor) == v.minor:
                return p

        msg = f"Invalid GCC version '{tgt_gcc_version}'. "
        msg += f"Only the following versions are supported for the compiler: {', '.join(possible_versions)}"
        raise ConanInvalidConfiguration(msg)

    @property
    def _target_triplet(self):
        return self._arch_triplets[str(self.settings_target.arch)]

    def validate(self):
        if self.settings.arch not in ("x86_64", "armv8") or self.settings.os != "Linux":
            msg = f"This toolchain is not compatible with {self.settings.os}-{self.settings.arch}. "
            msg += "It can only run on Linux-x86_64 or Linux-armv8."
            raise ConanInvalidConfiguration(msg)

        invalid_arch = str(self.settings_target.arch) not in self._arch_triplets
        if self.settings_target.os != "Linux" or invalid_arch:
            msg = f"This toolchain only supports building for Linux-{','.join(self._arch_triplets)}. "
            msg += f"{self.settings_target.os}-{self.settings_target.arch} is not supported."
            raise ConanInvalidConfiguration(msg)

        if self.settings_target.compiler != "gcc":
            msg = f"The compiler is set to '{self.settings_target.compiler}', but this "
            msg += "toolchain only supports building with GCC."
            raise ConanInvalidConfiguration(msg)

        self._get_gcc_version()

    def package(self):
        ref = f"{self.settings.os}-{self.settings.arch}"
        gcc_v = self._get_gcc_version()
        tgt_ref = f"{self._target_triplet}-gcc{gcc_v}"
        get(
            self,
            **self.conan_data["sources"][self.version][ref][tgt_ref],
            destination=self.package_folder,
            strip_root=True,
        )
        self.run(f"chmod -R +w {shlex.quote(self.package_folder)}")

    def package_id(self):
        self.info.settings_target = self.settings_target
        self.info.settings_target.rm_safe("build_type")

    def package_info(self):
        target = self._target_triplet
        bindir = os.path.join(self.package_folder, target, "bin")
        self.buildenv_info.prepend_path("PATH", bindir)
        libname = {
            "aarch64-rpi3-linux-gnu": "lib64",
            "armv8-rpi3-linux-gnueabihf": "lib",
            "armv6-rpi-linux-gnueabihf": "lib",
        }[target]
        libdir = os.path.join(self.package_folder, target, target, libname)
        processor = {
            "aarch64-rpi3-linux-gnu": "aarch64",
            "armv8-rpi3-linux-gnueabihf": "armv7l",  # armv8l does not exist
            "armv6-rpi-linux-gnueabihf": "armv6l",
        }[target]
        self.runenv_info.prepend_path("LD_LIBRARY_PATH", libdir)
        self.conf_info.define("tools.cmake.cmaketoolchain:system_name", "Linux")
        self.conf_info.define("tools.cmake.cmaketoolchain:system_processor", processor)
        self.conf_info.define("tools.gnu:host_triplet", target)
        compilers = {
            "c": f"{target}-gcc",
            "cpp": f"{target}-g++",
            "fortran": f"{target}-gfortran",
        }
        self.conf_info.update("tools.build:compiler_executables", compilers)
        self.conf_info.define("tools.build.cross_building:cross_build", True)
