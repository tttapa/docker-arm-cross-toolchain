# Crosstool-NG -----------------------------------------------------------------

FROM ubuntu:bionic AS ct-ng

# Install dependencies to build crosstool-ng and the toolchain
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update -y && \
    apt-get install -y \
        autoconf automake libtool-bin make texinfo help2man \
        sudo file gawk patch \
        g++ bison flex gperf \
        libncurses5-dev python3-dev \
        perl libthread-queue-perl \
        ca-certificates wget git \
        bzip2 xz-utils unzip rsync && \
    apt-get clean autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Add a user called `develop` and add him to the sudo group
RUN useradd -m develop && echo "develop:develop" | chpasswd && \
    usermod -aG sudo develop

USER develop
WORKDIR /home/develop

# Install autoconf
RUN wget https://ftp.gnu.org/gnu/autoconf/autoconf-2.72.tar.gz -O- | tar xz && \
    cd autoconf-2.72 && \
    ./configure --prefix=/home/develop/.local && \
    make -j$(nproc) && \
    make install && \
    cd .. && \
    rm -rf autoconf-2.72
ENV PATH=/home/develop/.local/bin:$PATH

# Build crosstool-ng
RUN git clone -b master --single-branch --depth 1 \
        https://github.com/crosstool-ng/crosstool-ng.git
WORKDIR /home/develop/crosstool-ng
RUN git show --summary && \
    ./bootstrap && \
    mkdir build && cd build && \
    ../configure --prefix=/home/develop/.local && \
    make -j$(($(nproc) * 2)) && \
    make install &&  \
    cd .. && rm -rf build
WORKDIR /home/develop

# Patches
# https://www.raspberrypi.org/forums/viewtopic.php?f=91&t=280707&p=1700861#p1700861
RUN wget https://ftp.debian.org/debian/pool/main/b/binutils/binutils_2.43.1-2.debian.tar.xz -O- | \
    tar xJ debian/patches/129_multiarch_libpath.patch && \
    mkdir -p patches/binutils/2.43 && \
    mv debian/patches/129_multiarch_libpath.patch patches/binutils/2.43 && \
    rm -rf debian

# Toolchain --------------------------------------------------------------------

FROM ct-ng AS gcc-build

ARG HOST_TRIPLE
ARG GCC_VERSION

# Build the toolchain
COPY --chown=develop:develop ${HOST_TRIPLE}.defconfig .
COPY --chown=develop:develop ${HOST_TRIPLE}.env .
RUN [ -n "${GCC_VERSION}" ] && { echo "CT_GCC_V_${GCC_VERSION}=y" >> ${HOST_TRIPLE}.defconfig; }
RUN cp ${HOST_TRIPLE}.defconfig defconfig && ct-ng defconfig
RUN . ./${HOST_TRIPLE}.env && \
    ct-ng build || { cat build.log && false; } && rm -rf .build

RUN chmod +w /home/develop/x-tools/${HOST_TRIPLE}
COPY cmake/Common.toolchain.cmake /home/develop/x-tools/${HOST_TRIPLE}/
COPY cmake/${HOST_TRIPLE}/* /home/develop/x-tools/${HOST_TRIPLE}/
RUN chmod -w /home/develop/x-tools/${HOST_TRIPLE}

# Build container --------------------------------------------------------------

FROM ubuntu:jammy

ARG HOST_TRIPLE

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update -y && \
    apt-get install --no-install-recommends -y \
        ninja-build cmake make bison flex \
        tar xz-utils gzip zip unzip bzip2 zstd \
        ca-certificates wget git sudo && \
    apt-get clean autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Add a user called `develop` and add him to the sudo group
RUN useradd -m develop && \
    echo "develop:develop" | chpasswd && \
    adduser develop sudo

USER develop
WORKDIR /home/develop

ENV TOOLCHAIN_PATH=/home/develop/opt/x-tools/${HOST_TRIPLE}
ENV PATH=${TOOLCHAIN_PATH}/bin:$PATH

# Copy the toolchain
COPY --chown=develop:develop --from=gcc-build /home/develop/x-tools /home/develop/opt/x-tools
