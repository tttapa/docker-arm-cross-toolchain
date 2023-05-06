#!/usr/bin/env bash
cd "$( dirname "${BASH_SOURCE[0]}" )"
set -e

triple="${1:-${HOST_TRIPLE:-aarch64-rpi3-linux-gnu}}"
toolchain_path="${2:-${TOOLCHAIN_PATH:-${HOME}/opt/x-tools/$triple}}"

for toolchain_file in "$toolchain_path"/*.toolchain.cmake; do
    toolchain_filename="$(basename "${toolchain_file}")"
    variant_triple=${toolchain_filename%%.*}
    if [ "$variant_triple" = "Common" ]; then continue; fi
    echo -e "\n$variant_triple ----------------------------------------------\n"
    rm -rf build-$variant_triple
    cmake -S . -B build-$variant_triple --toolchain $toolchain_file
    cmake --build build-$variant_triple -v
done
