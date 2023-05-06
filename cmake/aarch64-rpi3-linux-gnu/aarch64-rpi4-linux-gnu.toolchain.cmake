# For more information, see 
# https://cmake.org/cmake/help/latest/manual/cmake-toolchains.7.html,
# https://cmake.org/cmake/help/book/mastering-cmake/chapter/Cross%20Compiling%20With%20CMake.html, and
# https://tttapa.github.io/Pages/Raspberry-Pi/C++-Development-RPiOS/index.html.

# System information
set(CMAKE_SYSTEM_NAME "Linux")
set(CMAKE_SYSTEM_PROCESSOR "aarch64")
set(CROSS_GNU_TRIPLE "aarch64-rpi3-linux-gnu"
    CACHE STRING "The GNU triple of the toolchain to use")
set(CMAKE_LIBRARY_ARCHITECTURE aarch64-linux-gnu)
set(CPACK_DEBIAN_PACKAGE_ARCHITECTURE "arm64")

# Compiler flags
set(CMAKE_C_FLAGS_INIT       "-mcpu=cortex-a72+crc+simd")
set(CMAKE_CXX_FLAGS_INIT     "-mcpu=cortex-a72+crc+simd")
set(CMAKE_Fortran_FLAGS_INIT "-mcpu=cortex-a72+crc+simd")

include("${CMAKE_CURRENT_LIST_DIR}/Common.toolchain.cmake")
