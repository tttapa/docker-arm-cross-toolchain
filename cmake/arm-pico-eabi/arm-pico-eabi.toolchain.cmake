# Enable cross-compilation
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)
# Only look libraries etc. in the sysroot, but never look there for programs
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

set(CMAKE_CXX_EXTENSIONS On) # Required by pico-sdk
set(CMAKE_C_EXTENSIONS On)
set(CMAKE_INTERPROCEDURAL_OPTIMIZATION Off) # https://github.com/raspberrypi/pico-sdk/issues/1500
set(CMAKE_Fortran_COMPILER "NOTFOUND" CACHE FILEPATH "")

set(PICO_CXX_ENABLE_EXCEPTIONS On CACHE BOOL "")
set(PICO_CXX_ENABLE_RTTI On CACHE BOOL "")

set(PICO_GCC_TRIPLE "arm-pico-eabi")
set(PICO_TOOLCHAIN_PATH "${CMAKE_CURRENT_LIST_DIR}/bin")

if (DEFINED ENV{PICO_SDK_PATH})
    set(PICO_SDK_PATH "$ENV{PICO_SDK_PATH}" CACHE PATH "Path to the Pico SDK")
endif()
if (NOT DEFINED PICO_SDK_PATH)
    message(FATAL_ERROR "PICO_SDK_PATH not set")
endif()
include("${PICO_SDK_PATH}/cmake/preload/toolchains/pico_arm_gcc.cmake")
include("${PICO_SDK_PATH}/pico_sdk_init.cmake")
