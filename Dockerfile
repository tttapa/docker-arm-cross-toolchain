FROM ghcr.io/tttapa/docker-crosstool-ng-multiarch:master

ARG HOST_TRIPLE

WORKDIR /home/develop
RUN mkdir /home/develop/src
COPY ${HOST_TRIPLE}.defconfig defconfig
COPY ${HOST_TRIPLE}.env .env
RUN ls -lah

RUN ct-ng defconfig
# https://www.raspberrypi.org/forums/viewtopic.php?f=91&t=280707&p=1700861#p1700861
RUN . ./.env; export DEB_TARGET_MULTIARCH="${HOST_TRIPLE_LIB_DIR}"; \
    V=1 ct-ng build || { cat build.log && false; } && rm -rf .build

RUN chmod +w /home/develop/x-tools/${HOST_TRIPLE}
COPY cmake/Common.toolchain.cmake /home/develop/x-tools/${HOST_TRIPLE}/
COPY cmake/${HOST_TRIPLE}/* /home/develop/x-tools/${HOST_TRIPLE}/
RUN chmod -w /home/develop/x-tools/${HOST_TRIPLE}

ENV TOOLCHAIN_PATH=/home/develop/x-tools/${HOST_TRIPLE}
ENV PATH=${TOOLCHAIN_PATH}/bin:$PATH
WORKDIR /home/develop
