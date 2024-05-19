cmake_minimum_required(VERSION 3.20)
project(test LANGUAGES C CXX)

if (DEFINED PICO_SDK_VERSION_STRING)
    pico_sdk_init()
endif()

add_executable(hello_c "hello.c")
add_executable(hello_cpp "hello.cpp")

if (DEFINED PICO_SDK_VERSION_STRING)
    target_link_libraries(hello_c PRIVATE pico_stdlib)
    target_link_libraries(hello_cpp PRIVATE pico_stdlib)
else()
    enable_language(Fortran)
    add_executable(hello_f "hello.f90")
endif()
