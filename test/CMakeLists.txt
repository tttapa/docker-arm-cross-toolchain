cmake_minimum_required(VERSION 3.20)
project(test LANGUAGES C CXX Fortran)

add_executable(hello_c "hello.c")
add_executable(hello_cpp "hello.cpp")
add_executable(hello_f "hello.f90")
