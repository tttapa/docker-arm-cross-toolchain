# docker-arm-cross-toolchain

Repository with ARM cross-compilation toolchains (mainly for Raspberry Pi),
available as [stand-alone tarballs](https://github.com/tttapa/docker-arm-cross-toolchain/releases)
or [Docker containers](https://github.com/tttapa/docker-arm-cross-toolchain/pkgs/container/docker-arm-cross-toolchain).

- **GCC**: 14.2, 13.3, 12.4
- **Languages**: C, C++, Fortran
- **Glibc**: 2.31 and later
- **Linux**: 5.4 and later
- **Distributions**: Ubuntu 20.04 Focal, Raspberry Pi OS 11 Bullseye, Rocky 9 and later

The toolchains are built using [crosstool-NG](https://crosstool-ng.github.io/).  
The Linux compilers include the address and undefined behavior sanitizers (Asan
and UBsan) and gdbserver (15.1). They are compatible with glibc 2.31
and Linux 5.4 or later, and have been patched for [Debian Multiarch](https://wiki.debian.org/Multiarch).  
The bare-metal compilers ship with newlib 4.4 and newlib-nano 4.3.

The toolchains themselves can be used on any x86-64 system running Ubuntu 18.04 Bionic, Debian 10 Buster, Rocky 8 (or later),
or on a Raspberry Pi running 64-bit Ubuntu 20.04 Bionic, 64-bit Raspberry Pi OS 11 Bullseye (or later).

## Download

The ready-to-use toolchain tarballs can be downloaded from the [Releases page](https://github.com/tttapa/docker-arm-cross-toolchain/releases) (no Docker required).  
Direct links are available in the table below: 


| Target triplet | GCC 14.2 | GCC 13.3 | GCC 12.4 | Recommended hardware | Supported distributions |
|---------------:|:--------:|:--------:|:--------:|:-------------------|:------------------------|
| `aarch64-rpi3-linux-gnu` | [⬇️&nbsp;x86-64](https://github.com/tttapa/docker-arm-cross-toolchain/releases/latest/download/x-tools-aarch64-rpi3-linux-gnu-gcc14.tar.xz)<br>[⬇️&nbsp;arm64](https://github.com/tttapa/docker-arm-cross-toolchain/releases/latest/download/x-tools-aarch64-rpi3-linux-gnu-aarch64-rpi3-linux-gnu-gcc14.tar.xz) | [⬇️&nbsp;x86-64](https://github.com/tttapa/docker-arm-cross-toolchain/releases/latest/download/x-tools-aarch64-rpi3-linux-gnu-gcc13.tar.xz)<br>[⬇️&nbsp;arm64](https://github.com/tttapa/docker-arm-cross-toolchain/releases/latest/download/x-tools-aarch64-rpi3-linux-gnu-aarch64-rpi3-linux-gnu-gcc13.tar.xz) | [⬇️&nbsp;x86-64](https://github.com/tttapa/docker-arm-cross-toolchain/releases/latest/download/x-tools-aarch64-rpi3-linux-gnu-gcc12.tar.xz)<br>[⬇️&nbsp;arm64](https://github.com/tttapa/docker-arm-cross-toolchain/releases/latest/download/x-tools-aarch64-rpi3-linux-gnu-aarch64-rpi3-linux-gnu-gcc12.tar.xz) | 64-bit ARMv8:<br>RPi 2B rev. 1.2, RPi 3B/3B+, CM 3,<br>RPi 4B/400, CM 4, RPi Zero 2 W, RPi 5 | Ubuntu 20.04 Focal,<br>Debian 11 Bullseye,<br>Rocky 9 and later |
| `armv8-rpi3-linux-gnueabihf` | [⬇️&nbsp;x86-64](https://github.com/tttapa/docker-arm-cross-toolchain/releases/latest/download/x-tools-armv8-rpi3-linux-gnueabihf-gcc14.tar.xz)<br>[⬇️&nbsp;arm64](https://github.com/tttapa/docker-arm-cross-toolchain/releases/latest/download/x-tools-aarch64-rpi3-linux-gnu-armv8-rpi3-linux-gnueabihf-gcc14.tar.xz) | [⬇️&nbsp;x86-64](https://github.com/tttapa/docker-arm-cross-toolchain/releases/latest/download/x-tools-armv8-rpi3-linux-gnueabihf-gcc13.tar.xz)<br>[⬇️&nbsp;arm64](https://github.com/tttapa/docker-arm-cross-toolchain/releases/latest/download/x-tools-aarch64-rpi3-linux-gnu-armv8-rpi3-linux-gnueabihf-gcc13.tar.xz) | [⬇️&nbsp;x86-64](https://github.com/tttapa/docker-arm-cross-toolchain/releases/latest/download/x-tools-armv8-rpi3-linux-gnueabihf-gcc12.tar.xz)<br>[⬇️&nbsp;arm64](https://github.com/tttapa/docker-arm-cross-toolchain/releases/latest/download/x-tools-aarch64-rpi3-linux-gnu-armv8-rpi3-linux-gnueabihf-gcc12.tar.xz) | 32-bit ARMv8:<br>RPi 2B rev. 1.2, RPi 3B/3B+, CM 3,<br>RPi 4B/400, CM 4, RPi Zero 2 W, RPi 5 | Ubuntu 20.04 Focal,<br>Debian 11 Bullseye<br>and later |
| `armv6-rpi-linux-gnueabihf` | [⬇️&nbsp;x86-64](https://github.com/tttapa/docker-arm-cross-toolchain/releases/latest/download/x-tools-armv6-rpi-linux-gnueabihf-gcc14.tar.xz)<br>[⬇️&nbsp;arm64](https://github.com/tttapa/docker-arm-cross-toolchain/releases/latest/download/x-tools-aarch64-rpi3-linux-gnu-armv6-rpi-linux-gnueabihf-gcc14.tar.xz) | [⬇️&nbsp;x86-64](https://github.com/tttapa/docker-arm-cross-toolchain/releases/latest/download/x-tools-armv6-rpi-linux-gnueabihf-gcc13.tar.xz)<br>[⬇️&nbsp;arm64](https://github.com/tttapa/docker-arm-cross-toolchain/releases/latest/download/x-tools-aarch64-rpi3-linux-gnu-armv6-rpi-linux-gnueabihf-gcc13.tar.xz) | [⬇️&nbsp;x86-64](https://github.com/tttapa/docker-arm-cross-toolchain/releases/latest/download/x-tools-armv6-rpi-linux-gnueabihf-gcc12.tar.xz)<br>[⬇️&nbsp;arm64](https://github.com/tttapa/docker-arm-cross-toolchain/releases/latest/download/x-tools-aarch64-rpi3-linux-gnu-armv6-rpi-linux-gnueabihf-gcc12.tar.xz) | 32-bit ARMv6:<br>RPi A/B/A+/B+, CM 1, RPi Zero/Zero W | Raspberry Pi OS 11 Bullseye<br>and later |
| `arm-pico-eabi` | [⬇️&nbsp;x86-64](https://github.com/tttapa/docker-arm-cross-toolchain/releases/latest/download/x-tools-arm-pico-eabi-gcc14.tar.xz)<br>[⬇️&nbsp;arm64](https://github.com/tttapa/docker-arm-cross-toolchain/releases/latest/download/x-tools-aarch64-rpi3-linux-gnu-arm-pico-eabi-gcc14.tar.xz) | [⬇️&nbsp;x86-64](https://github.com/tttapa/docker-arm-cross-toolchain/releases/latest/download/x-tools-arm-pico-eabi-gcc13.tar.xz)<br>[⬇️&nbsp;arm64](https://github.com/tttapa/docker-arm-cross-toolchain/releases/latest/download/x-tools-aarch64-rpi3-linux-gnu-arm-pico-eabi-gcc13.tar.xz) | [⬇️&nbsp;x86-64](https://github.com/tttapa/docker-arm-cross-toolchain/releases/latest/download/x-tools-arm-pico-eabi-gcc12.tar.xz)<br>[⬇️&nbsp;arm64](https://github.com/tttapa/docker-arm-cross-toolchain/releases/latest/download/x-tools-aarch64-rpi3-linux-gnu-arm-pico-eabi-gcc12.tar.xz) | 32-bit ARM Cortex-M0+:<br>RP2040, RPi Pico, RPi Pico W | Raspberry Pi Pico SDK 2.0.0 |
| `arm-pico2-eabi` | [⬇️&nbsp;x86-64](https://github.com/tttapa/docker-arm-cross-toolchain/releases/latest/download/x-tools-arm-pico2-eabi-gcc14.tar.xz)<br>[⬇️&nbsp;arm64](https://github.com/tttapa/docker-arm-cross-toolchain/releases/latest/download/x-tools-aarch64-rpi3-linux-gnu-arm-pico2-eabi-gcc14.tar.xz) | [⬇️&nbsp;x86-64](https://github.com/tttapa/docker-arm-cross-toolchain/releases/latest/download/x-tools-arm-pico2-eabi-gcc13.tar.xz)<br>[⬇️&nbsp;arm64](https://github.com/tttapa/docker-arm-cross-toolchain/releases/latest/download/x-tools-aarch64-rpi3-linux-gnu-arm-pico2-eabi-gcc13.tar.xz) | [⬇️&nbsp;x86-64](https://github.com/tttapa/docker-arm-cross-toolchain/releases/latest/download/x-tools-arm-pico2-eabi-gcc12.tar.xz)<br>[⬇️&nbsp;arm64](https://github.com/tttapa/docker-arm-cross-toolchain/releases/latest/download/x-tools-aarch64-rpi3-linux-gnu-arm-pico2-eabi-gcc12.tar.xz) | 32-bit ARM Cortex-M33:<br>RP2350, RPi Pico 2 | Raspberry Pi Pico SDK 2.0.0 |

For modern Raspberry Pi boards running 64-bit Raspberry Pi OS or 64-bit Ubuntu,
use the `aarch64-rpi3-linux-gnu` toolchain.  
For modern Raspberry Pi boards running 32-bit Raspberry Pi OS, use the 
`armv8-rpi3-linux-gnueabihf` toolchain.  
For older Raspberry Pi boards, or if you need to support all boards, use the
`armv6-rpi-linux-gnueabihf` toolchain.

See [www.raspberrypi.com/documentation/computers/processors.html](https://www.raspberrypi.com/documentation/computers/processors.html) for an overview of the processors used by different Raspberry Pi models.

There is no specific toolchain for the first version of the RPi 2B (which 
uses a quad-core ARMv7 Cortex-A7), but the `armv6-rpi-linux-gnueabihf` toolchain
is compatible with this architecture as well.

For the RPi 5, RPi 4B/400 and the CM 4, use the `aarch64-rpi3-linux-gnu` or the 
`armv8-rpi3-linux-gnueabihf` toolchain, depending on whether you're using a
64-bit or a 32-bit operating system. For optimal performance, you can include
the `-mcpu=cortex-a76+crypto` (RPi 5) or `-mcpu=cortex-a72` (RPi 4) flag ([GCC ARM options](https://gcc.gnu.org/onlinedocs/gcc/ARM-Options.html)).

For the Raspberry Pi Pico and other RP2040-based boards, use the bare-metal 
`arm-pico-eabi` toolchain.

## Installation

Download the archive of the toolchain you need using the links above. 
Then extract it to a convenient location, e.g. `~/opt`.

You can download and extract the toolchain in one go using `wget` and `tar`,
for example:
```sh
mkdir -p ~/opt
wget https://github.com/tttapa/docker-arm-cross-toolchain/releases/latest/download/x-tools-aarch64-rpi3-linux-gnu-gcc14.tar.xz -O- | tar xJ -C ~/opt
```

If you want to use the toolchain directly, you can add the
`~/opt/x-tools/aarch64-rpi3-linux-gnu/bin` folder to your path:

```sh
export PATH="$HOME/opt/x-tools/aarch64-rpi3-linux-gnu/bin:$PATH"
```

To make it permanent, you can add it to your `~/.profile`:
```sh
echo 'export PATH="$HOME/opt/x-tools/aarch64-rpi3-linux-gnu/bin:$PATH"' >> ~/.profile
```
To verify that the toolchain was successfully added to the path, try querying
the GCC version:
```sh
aarch64-rpi3-linux-gnu-gcc --version
```

## Usage

### CMake

For new software configured using CMake, simply specify the appropriate
toolchain file. Several toolchain files are included with the toolchain, and you
can wrap them in a custom toolchain file if you need finer control.
See the [`cmake`](./cmake/) directory for an overview of available toolchain
files.

For example:
```sh
cd my-cmake-project # Open the directory of your CMake project
triple=aarch64-rpi3-linux-gnu # Select the main toolchain
variant_triple=aarch64-rpi4-linux-gnu # Select a specific variant
# Configure
cmake -S . -B build-$variant_triple --toolchain ~/opt/x-tools/$triple/$variant_triple.toolchain.cmake
# Build
cmake --build build-$variant_triple -j
```

On older versions of CMake, you might have to use `-DCMAKE_TOOLCHAIN_FILE="$HOME/opt/x-tools/$triple/$variant_triple.toolchain.cmake"` instead of `--toolchain ~/opt/x-tools/$triple/$variant_triple.toolchain.cmake`.

I _highly_ recommend using CMake for your own projects as well, this makes it
much easier for other people to depend on, package, and cross-compile your
software.  
See [Mastering CMake: Cross Compiling with CMake](https://cmake.org/cmake/help/book/mastering-cmake/chapter/Cross%20Compiling%20With%20CMake.html)
and the [`cmake-toolchains(7)` manpage](https://cmake.org/cmake/help/latest/manual/cmake-toolchains.7.html) for more details about CMake toolchain files.

For more detailed instructions on how to cross-compile software and how to 
handle dependencies, see <https://tttapa.github.io/Pages/Raspberry-Pi/index.html>.

#### VSCode CMake Tools Extension

To pass the `--toolchain` option to CMake when using the [CMake Tools extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cmake-tools),
add the paths to the different toolchain files to a “kits” file, either globally
(<kbd>Ctrl+Shift+P</kbd>, `Edit User-Local CMake Kits`) or for the specific
project (in `.vscode/cmake-kits.json`). 
Then select this toolchain using <kbd>Ctrl+Shift+P</kbd>, `CMake: Select a Kit`.

For example, `cmake-kits.json` could contain:
```json
[
    {
        "name": "Raspberry Pi 5 (64-bit, GCC)",
        "toolchainFile": "${env:HOME}/opt/x-tools/aarch64-rpi3-linux-gnu/aarch64-rpi5-linux-gnu.toolchain.cmake"
    }
]

```
A full kits file with all toolchains is included: [`cmake/cmake-kits.json`](./cmake/cmake-kits.json).

See [the CMake Tools documentation](https://github.com/microsoft/vscode-cmake-tools/blob/main/docs/kits.md#specify-a-toolchain)
for more details.

### Manual compiler invocation

To invoke a compiler or other tools manually, simply add the `bin` folder of
the toolchain to your path, as explained [above](#installation).

Then invoke the compiler you need, for example:
```sh
cat > hello.c << EOF
#include <stdio.h>
int main(void) { puts("Hello, world!"); }
EOF
aarch64-rpi3-linux-gnu-gcc hello.c -o hello
aarch64-rpi3-linux-gnu-readelf -h hello
```

Note that the compilers have been configured to use the most compatible target
by default (e.g. the Raspberry Pi 3 for `aarch64-rpi3-linux-gnu`), so you might
have to specify additional flags to select the one that fits your needs (e.g.
`-mcpu=cortex-a72+crc+simd` for the Raspberry Pi 4). See the flags used in the
CMake toolchain files in the [`cmake`](./cmake/) directory for inspiration.

### Autotools, Make and other legacy build tools

For legacy software configured using Autotools, you usually have to pass the
`--host` flag (e.g. `--host="aarch64-rpi3-linux-gnu"`) to the `configure`
script.  
Packages with custom configuration scripts might have differently named options,
for example, OpenSSL has `--cross-compile-prefix="aarch64-rpi3-linux-gnu-"`.  
Custom Makefiles might require you to set a variable such as
`CROSS=aarch64-rpi3-linux-gnu-` or `CROSS_COMPILE=aarch64-rpi3-linux-gnu-`.   
If all else fails, try setting the `CC`, `CXX` or `FC` environment variables
explicitly.

### Pico SDK

To use the `arm-pico-eabi` toolchain for the Raspberry Pi Pico with the Pico SDK,
set the `PICO_SDK_PATH` environment variable when invoking the CMake configure
command, and use the provided toolchain file:

```sh
export PICO_SDK_PATH="$HOME/pico/pico-sdk"
cmake -S . -B build --toolchain ~/opt/x-tools/arm-pico-eabi/arm-pico-eabi.toolchain.cmake # ...
cmake --build build -j # ...
```

If you're using Visual Studio Code with the CMake Tools extension, create a file
`.vscode/cmake-kits.json` with the following contents:
```json
[
    {
        "name": "Raspberry Pi Pico (GCC)",
        "toolchainFile": "${env:HOME}/opt/x-tools/arm-pico-eabi/arm-pico-eabi.toolchain.cmake",
        "environmentVariables": {"PICO_SDK_PATH": "${env:HOME}/pico/pico-sdk"}
    }
]
```
Then select this toolchain using <kbd>Ctrl+Shift+P</kbd>, `CMake: Select a Kit`.

The `.vscode/cmake-kits.json` file is also included in this repository:
[`cmake/cmake-kits.json`](./cmake/cmake-kits.json).

<details>

<summary>Alternative approach without a toolchain file ...</summary>

If you don't want to use a toolchain file, it is possible to select the correct
toolchain using environment variables:

```sh
export PICO_SDK_PATH="$HOME/pico/pico-sdk"
export PICO_GCC_TRIPLE="arm-pico-eabi"
export PICO_TOOLCHAIN_PATH="$HOME/opt/x-tools/arm-pico-eabi/bin"
cmake -S . -B build # ...
cmake --build build -j # ...
```

If you're using Visual Studio Code with the CMake Tools extension, you can add
the following to `.vscode/settings.json`:
```json
{
    "cmake.configureEnvironment": {
        "PICO_GCC_TRIPLE": "arm-pico-eabi",
    }
}
```

Alternatively, create a file `.vscode/cmake-kits.json` with the following contents:
```json
[
    {
        "name": "RPi Pico",
        "environmentVariables": {
            "PICO_SDK_PATH": "${env:HOME}/pico/pico-sdk",
            "PICO_GCC_TRIPLE": "arm-pico-eabi",
            "PICO_TOOLCHAIN_PATH": "${env:HOME}/opt/x-tools/arm-pico-eabi/bin"
        }
    }
]
```


</details>

## Deployment

Recent versions of GCC require recent versions of the C++ standard library,
`libstdc++`. If the operating system on the Raspberry Pi you want to deploy to
uses an older version of `libstdc++`, you have multiple options:

 - Link the C++ standard library statically, using the `-static-libstdc++` flag.
   This results in slightly larger binaries, but improves portability.
 - Install a newer version of the C++ standard library globally by copying
   `x-tools/aarch64-rpi3-linux-gnu/aarch64-rpi3-linux-gnu/sysroot/lib64/libstdc++.so.6.0.*`
   from the toolchain to the `/usr/local/lib/aarch64-linux-gnu` folder on the 
   Pi, and run `sudo ldconfig`.
 - Ship a copy of `libstdc++` with your application, and ensure that it is
   loaded before the global one, by using the `-rpath` flag or the
   `LD_LIBRARY_PATH` environment variable. This may not be an option if your
   binary is loaded by another program (e.g. Python modules).
 - Use a Docker container with a recent version of the C++ standard library.

Other libraries, such as `libasan.so` can be installed similarly.

Note that this is not at all true for the C standard library, `libc.so`. The
C standard library is tightly coupled to the rest of the system, and cannot be
replaced by a newer version.

## Common issues

- `/usr/lib/aarch64-linux-gnu/libstdc++.so.6: version GLIBCXX_3.4.33 not found`:  
  This means that the available version of the C++ standard library is too old.
  See [§Deployment](#deployment) for instructions to resolve this issue.
- `/lib64/libc.so.6: version ``GLIBC_2.31' not found`:  
  Your operating system is too old. Use a newer operating system, or an older
  version of the toolchain. Note that upgrading glibc is not possible.
- `Could NOT find Threads (missing: Threads_FOUND)`:   
  See https://github.com/tttapa/RPi-Cross-Cpp-Development/issues/2#issuecomment-1431703892 for a fix.
