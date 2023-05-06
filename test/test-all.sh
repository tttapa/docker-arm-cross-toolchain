#!/usr/bin/env bash
cd "$( dirname "${BASH_SOURCE[0]}" )"
set -e

for triple in armv6-rpi-linux-gnueabihf armv8-rpi3-linux-gnueabihf aarch64-rpi3-linux-gnu; do
    ./test.sh $triple
done
