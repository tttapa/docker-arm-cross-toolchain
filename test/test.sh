#!/usr/bin/env bash
cd "$( dirname "${BASH_SOURCE[0]}" )"
set -e

triple="${1:-${HOST_TRIPLE:-aarch64-rpi3-linux-gnu}}"
toolchain_path="${2:-${TOOLCHAIN_PATH:-${HOME}/opt/x-tools/$triple}}"

for toolchain_file in "$toolchain_path"/*.toolchain.cmake; do
    toolchain_filename="$(basename "${toolchain_file}")"
    variant_triple=${toolchain_filename%%.*}
    if [ "$variant_triple" = "Common" ]; then continue; fi
    echo -e "\n$variant_triple (GCC) ----------------------------------------\n"
    rm -rf build-$variant_triple
    cmake -S . -B build-$variant_triple --toolchain $toolchain_file
    cmake --build build-$variant_triple -v
    # TODO: investigate why linking fails for Fortran using Clang
    if [ "$triple" == "armv8-rpi3-linux-gnueabihf" ]; then continue; fi
    echo -e "\n$variant_triple (Clang) --------------------------------------\n"
    rm -rf build-$variant_triple-clang
    cmake -S . -B build-$variant_triple-clang --toolchain $toolchain_file -DTOOLCHAIN_USE_CLANG=On
    cmake --build build-$variant_triple-clang -v
done

# armv8 Clang + GFortran linker error:
# /usr/bin/clang --sysroot=/home/user/opt/x-tools/armv8-rpi3-linux-gnueabihf/armv8-rpi3-linux-gnueabihf/sysroot -target armv8-rpi3-linux-gnueabihf --gcc-toolchain=/home/user/opt/x-tools/armv8-rpi3-linux-gnueabihf/lib/gcc/armv8-rpi3-linux-gnueabihf/13.1.0/../../../.. -L/home/user/opt/x-tools/armv8-rpi3-linux-gnueabihf/lib/gcc/armv8-rpi3-linux-gnueabihf/13.1.0/ -fuse-ld=/home/user/opt/x-tools/armv8-rpi3-linux-gnueabihf/bin/armv8-rpi3-linux-gnueabihf-ld -L/home/user/opt/x-tools/armv8-rpi3-linux-gnueabihf/lib/gcc/armv8-rpi3-linux-gnueabihf/13.1.0/ -fuse-ld=/home/user/opt/x-tools/armv8-rpi3-linux-gnueabihf/bin/armv8-rpi3-linux-gnueabihf-ld -L/home/user/opt/x-tools/armv8-rpi3-linux-gnueabihf/lib/gcc/armv8-rpi3-linux-gnueabihf/13.1.0/ -fuse-ld=/home/user/opt/x-tools/armv8-rpi3-linux-gnueabihf/bin/armv8-rpi3-linux-gnueabihf-ld -mcpu=cortex-a53 -mfpu=neon-fp-armv8 -mfloat-abi=hard CMakeFiles/hello_f.dir/hello.f90.o -o hello_f  -lgfortran 
# /home/user/opt/x-tools/armv8-rpi3-linux-gnueabihf/bin/armv8-rpi3-linux-gnueabihf-ld.bfd: CMakeFiles/hello_f.dir/hello.f90.o: relocation R_ARM_MOVW_ABS_NC against `a local symbol' can not be used when making a shared object; recompile with -fPIC
# /home/user/opt/x-tools/armv8-rpi3-linux-gnueabihf/bin/armv8-rpi3-linux-gnueabihf-ld.bfd: CMakeFiles/hello_f.dir/hello.f90.o(.text+0x38): unresolvable R_ARM_CALL relocation against symbol `_gfortran_st_write@@GFORTRAN_8'
