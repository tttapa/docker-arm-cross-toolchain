# docker-arm-cross-toolchain

Repository with ARM cross-compilation toolchains (mainly for Raspberry Pi),
built using Docker and [crosstool-NG](https://crosstool-ng.github.io/).

Provides C, C++ and Fortran cross-compilers (GCC 12.1).  
The Linux compilers include the address and undefined behavior sanitizers (Asan
and UBsan), cross-GDB and gdbserver (10.2). They are compatible with glibc 2.28
and Linux 5.8 or later, and have been patched for [Debian Multiarch](https://wiki.debian.org/Multiarch).  
The bare-metal compiler comes with cross-GDB (12.1), newlib and newlib-nano.

## Download

Docker images are available from [GitHub Packages](https://github.com/tttapa/docker-arm-cross-toolchain/pkgs/container/docker-arm-cross-toolchain),
and the ready-to-use toolchains can be downloaded from the [Releases page](https://github.com/tttapa/docker-arm-cross-toolchain/releases).

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
wget -qO- https://github.com/tttapa/docker-arm-cross-toolchain/releases/latest/download/x-tools-aarch64-rpi3-linux-gnu.tar.xz | tar xJ -C ~/opt
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

## Usage

For new software configured using CMake, use a [CMake toolchain file](https://cmake.org/cmake/help/latest/manual/cmake-toolchains.7.html).
Examples can be found in <https://github.com/tttapa/RPi-Cross-Cpp-Development/tree/master/cmake>.

I _highly_ recommend using CMake for your own projects as well, this makes it
much easier for other people to depend on, package, and cross-compile your 
software.

For legacy software configured using Autotools, you usuall have to set a flag
`--host="aarch64-rpi3-linux-gnu"` when invoking the `configure` script.  
Packages with custom configuration scripts might have differently named options,
for example, OpenSSL has `--cross-compile-prefix="aarch64-rpi3-linux-gnu-"`.  
Custom Makefiles might require you to set a variable such as
`CROSS=aarch64-rpi3-linux-gnu-` or `CROSS_COMPILE=aarch64-rpi3-linux-gnu-`.   
If all else fails, try setting the `CC`, `CXX` or `FC` environment variables
explicitly.

For more detailed instructions on how to cross-compile software and how to 
handle dependencies, see <https://tttapa.github.io/Pages/Raspberry-Pi/index.html>.

### Pico SDK

To use the `arm-pico-eabi` toolchain for the Raspberry Pi Pico with the Pico SDK,
add the following option to the CMake configure command:

```sh
-DPICO_GCC_TRIPLE=arm-pico-eabi
```

If you're using Visual Studio Code with the CMake Tools extension, you can add
the following to `.vscode/settings.json`:
```json
{
    "cmake.configureSettings": {
        "PICO_GCC_TRIPLE": "arm-pico-eabi",
    },
}
```
