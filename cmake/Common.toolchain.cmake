if (NOT DEFINED CROSS_GNU_TRIPLE)
    message(FATAL_ERROR "This file is not meant to be used directly!")
endif()

include(CMakeDependentOption)

# Search path configuration
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
# set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

# Toolchain and sysroot
set(TOOLCHAIN_DIR "${CMAKE_CURRENT_LIST_DIR}")
if (NOT DEFINED CMAKE_SYSROOT)
    set(CMAKE_SYSROOT "${TOOLCHAIN_DIR}/${CROSS_GNU_TRIPLE}/sysroot")
endif()

# Clang toolchain
option(TOOLCHAIN_USE_CLANG "Use Clang instead of GCC" Off)
# Inform CMake about this option (for try_compile and compiler detection etc.)
list(APPEND CMAKE_TRY_COMPILE_PLATFORM_VARIABLES TOOLCHAIN_USE_CLANG)
if (TOOLCHAIN_USE_CLANG)
    # Select the GCC toolchain to use
    set(TOOLCHAIN_C_COMPILER ${TOOLCHAIN_DIR}/bin/${CROSS_GNU_TRIPLE}-gcc)

    # Find Clang
    set(TOOLCHAIN_CLANG_PREFIX "" CACHE STRING "Prefix to the Clang command")
    set(TOOLCHAIN_CLANG_SUFFIX "" CACHE STRING "Suffix to the Clang command")
    set(TOOLCHAIN_C_COMPILER_CLANG ${TOOLCHAIN_CLANG_PREFIX}clang${TOOLCHAIN_CLANG_SUFFIX}
        CACHE FILEPATH "Full name or path of the clang command")
    set(TOOLCHAIN_CXX_COMPILER_CLANG ${TOOLCHAIN_CLANG_PREFIX}clang++${TOOLCHAIN_CLANG_SUFFIX}
        CACHE FILEPATH "Full name or path of the clang++ command")
    set(TOOLCHAIN_Fortran_COMPILER_CLANG "${TOOLCHAIN_DIR}/bin/${CROSS_GNU_TRIPLE}-gfortran"
        CACHE FILEPATH "Full name or path of the gfortran command")
    # Use Clang as the cross-compiler
    set(CMAKE_C_COMPILER ${TOOLCHAIN_C_COMPILER_CLANG}
        CACHE FILEPATH "C compiler")
    set(CMAKE_CXX_COMPILER ${TOOLCHAIN_CXX_COMPILER_CLANG}
        CACHE FILEPATH "C++ compiler")
    set(CMAKE_Fortran_COMPILER ${TOOLCHAIN_Fortran_COMPILER_CLANG}
        CACHE FILEPATH "Fortran compiler")

    # Get the machine triple from GCC
    execute_process(COMMAND ${TOOLCHAIN_C_COMPILER} -dumpmachine
                    OUTPUT_VARIABLE CROSS_GNU_TRIPLE_EFFECTIVE
                    ERROR_VARIABLE CROSS_GNU_TRIPLE_EFFECTIVE_ERROR
                    OUTPUT_STRIP_TRAILING_WHITESPACE)
    set(CROSS_GNU_TRIPLE_EFFECTIVE ${CROSS_GNU_TRIPLE_EFFECTIVE}
        CACHE STRING "The GNU triple of the toolchain actually in use")
    if (NOT CROSS_GNU_TRIPLE_EFFECTIVE)
        message(FATAL_ERROR "Unable to determine GCC triple ${CROSS_GNU_TRIPLE_EFFECTIVE} ${CROSS_GNU_TRIPLE_EFFECTIVE_ERROR}")
    endif()

    # Get the installation folder from GCC
    execute_process(COMMAND ${TOOLCHAIN_C_COMPILER} -print-search-dirs
                    OUTPUT_VARIABLE TOOLCHAIN_GCC_INSTALL
                    ERROR_VARIABLE TOOLCHAIN_GCC_INSTALL_ERROR)
    string(REGEX MATCH "(^|\r|\n)install: +([^\r\n]*)" 
        TOOLCHAIN_GCC_INSTALL_LINE ${TOOLCHAIN_GCC_INSTALL})
    if (NOT TOOLCHAIN_GCC_INSTALL_LINE)
        message(FATAL_ERROR "Unable to determine GCC installation ${TOOLCHAIN_GCC_INSTALL} ${TOOLCHAIN_GCC_INSTALL_ERROR}")
    endif()
    cmake_path(SET TOOLCHAIN_GCC_INSTALL_LIB NORMALIZE ${CMAKE_MATCH_2})
    cmake_path(SET TOOLCHAIN_GCC_INSTALL NORMALIZE ${CMAKE_MATCH_2})
    cmake_path(APPEND TOOLCHAIN_GCC_INSTALL "../../../..")
    cmake_path(ABSOLUTE_PATH TOOLCHAIN_GCC_INSTALL)
    set(TOOLCHAIN_GCC_INSTALL ${TOOLCHAIN_GCC_INSTALL}
        CACHE PATH "Path to GCC installation")
    message(STATUS "Using Clang toolchain with GCC installation ${TOOLCHAIN_GCC_INSTALL}")

    # Find a linker
    find_program(TOOLCHAIN_LINKER ${CROSS_GNU_TRIPLE}-ld REQUIRED
        HINTS ${TOOLCHAIN_DIR}/bin)

    # Specify architecture-specific flags
    set(ARCH_FLAGS "-target ${CROSS_GNU_TRIPLE_EFFECTIVE}")
    # Make sure that Clang finds the GCC installation and a suitable linker
    set(TOOLCHAIN_FLAGS "--gcc-toolchain=${TOOLCHAIN_GCC_INSTALL}")
    set(TOOLCHAIN_LINK_FLAGS "-L${TOOLCHAIN_GCC_INSTALL_LIB} -fuse-ld=${TOOLCHAIN_LINKER}")
    # Compilation flags
    string(APPEND CMAKE_C_FLAGS_INIT " ${ARCH_FLAGS} ${TOOLCHAIN_FLAGS}")
    string(APPEND CMAKE_CXX_FLAGS_INIT " ${ARCH_FLAGS} ${TOOLCHAIN_FLAGS}")
    # Linker flags
    string(APPEND CMAKE_EXE_LINKER_FLAGS_INIT " ${TOOLCHAIN_LINK_FLAGS}")
    string(APPEND CMAKE_MODULE_LINKER_FLAGS_INIT " ${TOOLCHAIN_LINK_FLAGS}")
    string(APPEND CMAKE_SHARED_LINKER_FLAGS_INIT " ${TOOLCHAIN_LINK_FLAGS}")
    # Use Clang for linking Fortran code (GFortran is used as compiler)
    set(CMAKE_Fortran_CREATE_SHARED_LIBRARY "<CMAKE_C_COMPILER> ${ARCH_FLAGS} ${TOOLCHAIN_FLAGS} ${TOOLCHAIN_LINK_FLAGS} <CMAKE_SHARED_LIBRARY_Fortran_FLAGS> <LANGUAGE_COMPILE_FLAGS> <LINK_FLAGS> <CMAKE_SHARED_LIBRARY_CREATE_Fortran_FLAGS> <SONAME_FLAG><TARGET_SONAME> -o <TARGET> <OBJECTS> <LINK_LIBRARIES>" CACHE STRING "")
    set(CMAKE_Fortran_LINK_EXECUTABLE "<CMAKE_C_COMPILER> ${ARCH_FLAGS} ${TOOLCHAIN_FLAGS} ${TOOLCHAIN_LINK_FLAGS} <CMAKE_Fortran_LINK_FLAGS> <LINK_FLAGS> <FLAGS> <OBJECTS> -o <TARGET> <LINK_LIBRARIES>" CACHE STRING "")
    set(CMAKE_Fortran_CREATE_SHARED_MODULE ${CMAKE_Fortran_CREATE_SHARED_LIBRARY} CACHE STRING "")
    set(CMAKE_Fortran_STANDARD_LIBRARIES_INIT -lgfortran)
    set(CMAKE_Fortran_COMPILER_FORCED On)
# GCC toolchain
else()
    set(CMAKE_C_COMPILER "${TOOLCHAIN_DIR}/bin/${CROSS_GNU_TRIPLE}-gcc"
        CACHE FILEPATH "C compiler")
    set(CMAKE_CXX_COMPILER "${TOOLCHAIN_DIR}/bin/${CROSS_GNU_TRIPLE}-g++"
        CACHE FILEPATH "C++ compiler")
    set(CMAKE_Fortran_COMPILER "${TOOLCHAIN_DIR}/bin/${CROSS_GNU_TRIPLE}-gfortran"
        CACHE FILEPATH "Fortran compiler")
endif()
