FROM ghcr.io/tttapa/docker-crosstool-ng-multiarch:master

ARG HOST_TRIPLE

WORKDIR /home/develop
RUN mkdir /home/develop/RPi && mkdir /home/develop/src
WORKDIR /home/develop/RPi
COPY ${HOST_TRIPLE}.config .config
COPY ${HOST_TRIPLE}.env .env
RUN mkdir -p patches/binutils/2.31.1 && \
    cp /home/develop/129_multiarch_libpath.patch patches/binutils/2.31.1
RUN ls -lah

# https://www.raspberrypi.org/forums/viewtopic.php?f=91&t=280707&p=1700861#p1700861
# RUN . ./.env; export DEB_TARGET_MULTIARCH="${HOST_TRIPLE_LIB_DIR}"; \
#     ct-ng build || { cat build.log && false; } && rm -rf .build

RUN . ./.env; export DEB_TARGET_MULTIARCH="${HOST_TRIPLE_LIB_DIR}"; \
    mkdir -p /home/develop/x-tools; \
    echo "${DEB_TARGET_MULTIARCH} - ${HOST_TRIPLE}" > /home/develop/x-tools/output.txt

ENV TOOLCHAIN_PATH=/home/develop/x-tools/${HOST_TRIPLE}
ENV PATH=${TOOLCHAIN_PATH}/bin:$PATH
WORKDIR /home/develop
