from io import StringIO
from conan import ConanFile


class TestPackageConan(ConanFile):
    settings = "os", "arch", "compiler", "build_type"
    generators = "VirtualBuildEnv"
    test_type = "explicit"

    def build_requirements(self):
        self.tool_requires(self.tested_reference_str)

    def test(self):
        compiler = self.conf.get("tools.build:compiler_executables")["cpp"]
        self.run(f"{compiler} --version", output := StringIO())
        print(out := output.getvalue(), end="")
        assert "tttapa/docker-arm-cross-toolchain" in out
