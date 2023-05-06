# For more information, see 
# https://cmake.org/cmake/help/latest/manual/cmake-toolchains.7.html,
# https://cmake.org/cmake/help/book/mastering-cmake/chapter/Cross%20Compiling%20With%20CMake.html, and
# https://tttapa.github.io/Pages/Raspberry-Pi/C++-Development-RPiOS/index.html.

# System information
set(CMAKE_SYSTEM_NAME "Linux")
set(CMAKE_SYSTEM_PROCESSOR "armv8")
set(CROSS_GNU_TRIPLE "armv8-rpi3-linux-gnueabihf"
    CACHE STRING "The GNU triple of the toolchain to use")
set(CMAKE_LIBRARY_ARCHITECTURE arm-linux-gnueabihf)
set(CPACK_DEBIAN_PACKAGE_ARCHITECTURE "armhf")

# Compiler flags
set(CMAKE_C_FLAGS_INIT       "-mcpu=cortex-a72 -mfpu=neon-fp-armv8 -mfloat-abi=hard")
set(CMAKE_CXX_FLAGS_INIT     "-mcpu=cortex-a72 -mfpu=neon-fp-armv8 -mfloat-abi=hard")
set(CMAKE_Fortran_FLAGS_INIT "-mcpu=cortex-a72 -mfpu=neon-fp-armv8 -mfloat-abi=hard")

include("${CMAKE_CURRENT_LIST_DIR}/Common.toolchain.cmake")
