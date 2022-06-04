FROM ghcr.io/tttapa/docker-crosstool-ng-multiarch:master

WORKDIR /home/develop
RUN mkdir /home/develop/host-config && mkdir /home/develop/src
WORKDIR /home/develop/host-config
COPY arm-pico-eabi.config .config

RUN V=1 ct-ng build || { cat build.log && false; } && rm -rf .build

ENV TOOLCHAIN_PATH=/home/develop/x-tools/arm-pico-eabi
ENV PATH=${TOOLCHAIN_PATH}/bin:$PATH
WORKDIR /home/develop
