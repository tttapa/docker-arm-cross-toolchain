# docker-arm-cross-toolchain

Repository with ARM cross-compilation toolchains (mainly for Raspberry Pi),
available as [stand-alone tarballs](https://github.com/tttapa/docker-arm-cross-toolchain/releases)
or [Docker containers](https://github.com/tttapa/docker-arm-cross-toolchain/pkgs/container/docker-arm-cross-toolchain).

Provides C, C++ and Fortran cross-compilers (GCC 13.2), built using [crosstool-NG](https://crosstool-ng.github.io/).  
The Linux compilers include the address and undefined behavior sanitizers (Asan
and UBsan) and gdbserver (13.2). They are compatible with glibc 2.27
and Linux 4.19 or later, and have been patched for [Debian Multiarch](https://wiki.debian.org/Multiarch).  
The bare-metal compiler ships with newlib and newlib-nano 4.3.

## Download

The ready-to-use toolchain tarballs can be downloaded from the [Releases page](https://github.com/tttapa/docker-arm-cross-toolchain/releases) (no Docker required).

Direct links: 
- [**aarch64-rpi3-linux-gnu**](https://github.com/tttapa/docker-arm-cross-toolchain/releases/latest/download/x-tools-aarch64-rpi3-linux-gnu.tar.xz) (64-bit, RPi 2B rev. 1.2, RPi 3B/3B+, CM 3, RPi 4B/400, CM 4, RPi Zero 2 W)
- [**armv8-rpi3-linux-gnueabihf**](https://github.com/tttapa/docker-arm-cross-toolchain/releases/latest/download/x-tools-armv8-rpi3-linux-gnueabihf.tar.xz) (32-bit, RPi 2B rev. 1.2, RPi 3B/3B+, CM 3, RPi 4B/400, CM 4, RPi Zero 2 W)
- [**armv6-rpi-linux-gnueabihf**](https://github.com/tttapa/docker-arm-cross-toolchain/releases/latest/download/x-tools-armv6-rpi-linux-gnueabihf.tar.xz) (32-bit, RPi A/B/A+/B+, CM 1, RPi Zero/Zero W)
- [**arm-pico-eabi**](https://github.com/tttapa/docker-arm-cross-toolchain/releases/latest/download/x-tools-arm-pico-eabi.tar.xz) (Cortex-M0+ RP2040, RPi Pico)

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

For the RPi 4B/400 and the CM 4, use the `aarch64-rpi3-linux-gnu` or the 
`armv8-rpi3-linux-gnueabihf` toolchain, depending on whether you're using a
64-bit or a 32-bit operating system. For optimal performance, you can include
the `-mcpu=cortex-a72` or `-mtune=cortex-a72` flags ([GCC ARM options](https://gcc.gnu.org/onlinedocs/gcc/ARM-Options.html)).

For the Raspberry Pi Pico and other RP2040-based boards, use the bare-metal 
`arm-pico-eabi` toolchain.

## Installation

Download the archive of the toolchain you need using the links above. 
Then extract it to a convenient location, e.g. `~/opt`.

You can download and extract the toolchain in one go using `wget` and `tar`,
for example:
```sh
mkdir -p ~/opt
wget -O- https://github.com/tttapa/docker-arm-cross-toolchain/releases/latest/download/x-tools-aarch64-rpi3-linux-gnu.tar.xz | tar xJ -C ~/opt
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
cmake --build build-$variant_triple
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
        "name": "Raspberry Pi 4 (64-bit, GCC)",
        "toolchainFile": "${env:HOME}/opt/x-tools/aarch64-rpi3-linux-gnu/aarch64-rpi4-linux-gnu.toolchain.cmake"
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
CMake toolchain files in [`cmake`](./cmake/) for inspiration.

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
set the `PICO_GCC_TRIPLE` environment variable when invoking the CMake configure
command.
In case you didn't add the toolchain to the path, set the `PICO_TOOLCHAIN_PATH`
environment variable as well.

```sh
export PICO_GCC_TRIPLE="arm-pico-eabi"
export PICO_TOOLCHAIN_PATH="$HOME/opt/x-tools/arm-pico-eabi/bin"
cmake -S . -B build # ...
cmake --build build # ...
```

If you're using Visual Studio Code with the CMake Tools extension, you can add
the following to `.vscode/settings.json`:
```json
{
    "cmake.configureEnvironment": {
        "PICO_GCC_TRIPLE": "arm-pico-eabi",
    },
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
Then select this toolchain using <kbd>Ctrl+Shift+P</kbd>, `CMake: Select a Kit`.
