FROM ghcr.io/tttapa/docker-crosstool-ng-multiarch:master

WORKDIR /home/develop
RUN mkdir /home/develop/src
COPY arm-pico-eabi.defconfig defconfig

RUN ct-ng defconfig
RUN V=1 ct-ng build || { cat build.log && false; } && rm -rf .build

ENV TOOLCHAIN_PATH=/home/develop/x-tools/arm-pico-eabi
ENV PATH=${TOOLCHAIN_PATH}/bin:$PATH
WORKDIR /home/develop
