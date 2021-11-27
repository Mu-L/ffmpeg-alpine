FROM alpine:3.14 AS build

WORKDIR /tmp/workdir

ARG PREFIX=/usr/local
ARG MAKEFLAGS="-j2"
ENV HTTP_PROXY "http://docker.for.mac.host.internal:7890"
ENV HTTPS_PROXY "http://docker.for.mac.host.internal:7890"
ENV FDKAAC_VERSION=2.0.1      \
    LAME_VERSION=3.100       \
    LIBASS_VERSION=0.15.0     \
    OGG_VERSION=1.3.2         \
    OPENCOREAMR_VERSION=0.1.2 \
    OPUS_VERSION=1.3.1          \
    OPENJPEG_VERSION=2.4.0    \
    THEORA_VERSION=1.1.1      \
    VORBIS_VERSION=1.3.7      \
    VPX_VERSION=1.10.0         \
    X264_VERSION=20210211 \
    X265_VERSION=3.4          \
    XVID_VERSION=1.3.7        \
    FREETYPE_VERSION=2.10.4    \
    FRIBIDI_VERSION=1.0.9    \
    FONTCONFIG_VERSION=2.13.1 \
    LIBVIDSTAB_VERSION=1.1.0  \
    KVAZAAR_VERSION=1.2.0     \
    AOM_VERSION=v1.0.0        \
    SRC=/usr/local

ARG ACC_SHA256SUM="840133aa9412153894af03b27b03dde1188772442c316a4ce2a24ed70093f271  fdk-aac-2.0.1.tar.gz"
ARG OGG_SHA256SUM="e19ee34711d7af328cb26287f4137e70630e7261b17cbe3cd41011d73a654692  libogg-1.3.2.tar.gz"
ARG OPUS_SHA256SUM="65b58e1e25b2a114157014736a3d9dfeaad8d41be1c8179866f144a2fb44ff9d  opus-1.3.1.tar.gz"
ARG VORBIS_SHA256SUM="b33cc4934322bcbf6efcbacf49e3ca01aadbea4114ec9589d1b1e9d20f72954b  libvorbis-1.3.7.tar.xz"
ARG THEORA_SHA256SUM="f36da409947aa2b3dcc6af0a8c2e3144bc19db2ed547d64e9171c59c66561c61  libtheora-1.1.1.tar.xz"
ARG XVID_SHA256SUM="abbdcbd39555691dd1c9b4d08f0a031376a3b211652c0d8b3b8aa9be1303ce2d  xvidcore-1.3.7.tar.gz"
ARG FREETYPE_SHA256SUM="86a854d8905b19698bbc8f23b860bc104246ce4854dcea8e3b0fb21284f75784  freetype-2.10.4.tar.xz"
ARG LIBVIDSTAB_SHA256SUM="14d2a053e56edad4f397be0cb3ef8eb1ec3150404ce99a426c4eb641861dc0bb  v1.1.0.tar.gz"
ARG LIBASS_SHA256SUM="9f09230c9a0aa68ef7aa6a9e2ab709ca957020f842e52c5b2e52b801a7d9e833  libass-0.15.0.tar.xz"
ARG FRIBIDI_SHA256SUM="c5e47ea9026fb60da1944da9888b4e0a18854a0e2410bbfe7ad90a054d36e0c7  fribidi-1.0.9.tar.xz"


RUN buildDeps="autoconf \
    automake \
    bash \
    binutils \
    bzip2 \
    cmake \
    curl \
    coreutils \
    diffutils \
    expat-dev \
    file \
    g++ \
    gcc \
    gperf \
    libtool \
    libuuid \
    util-linux \
    make \
    meson \
    nasm \
    ninja \
    openssl-dev \
    python3 \
    tar \
    xz \
    yasm \
    zlib-dev" && \
    apk  add --update ${buildDeps} libgcc libstdc++ ca-certificates libcrypto1.1 libssl1.1

## opencore-amr https://sourceforge.net/projects/opencore-amr/
RUN \
    DIR=/tmp/opencore-amr && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -skL https://kent.dl.sourceforge.net/project/opencore-amr/opencore-amr/${OPENCOREAMR_VERSION}/opencore-amr-${OPENCOREAMR_VERSION}.tar.gz | \
    tar -zx --strip-components=1 && \
    ./configure --prefix="${PREFIX}" --enable-shared  && \
    make && \
    make install && \
    rm -rf ${DIR}
## x264 http://www.videolan.org/developers/x264.html
RUN \
    DIR=/tmp/x264 && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -skL https://anduin.linuxfromscratch.org/BLFS/x264/x264-${X264_VERSION}.tar.xz | \
    tar -Jvx --strip-components=1 && \
    ./configure --prefix="${PREFIX}" --enable-shared --enable-pic --disable-cli && \
    make && \
    make install && \
    rm -rf ${DIR}
### x265 http://x265.org/
RUN \
    DIR=/tmp/x265 && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sL http://anduin.linuxfromscratch.org/BLFS/x265/x265_${X265_VERSION}.tar.gz  | \
    tar -zx && \
    cd x265_${X265_VERSION}/build/linux && \
    sed -i "/-DEXTRA_LIB/ s/$/ -DCMAKE_INSTALL_PREFIX=\${PREFIX}/" multilib.sh && \
    sed -i "/^cmake/ s/$/ -DENABLE_CLI=OFF/" multilib.sh && \
    ./multilib.sh && \
    make -C 8bit install && \
    rm -rf ${DIR}
### libogg https://www.xiph.org/ogg/
RUN \
    DIR=/tmp/ogg && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO http://downloads.xiph.org/releases/ogg/libogg-${OGG_VERSION}.tar.gz && \
    echo ${OGG_SHA256SUM} | sha256sum --check && \
    tar -zx --strip-components=1 -f libogg-${OGG_VERSION}.tar.gz && \
    ./configure --prefix="${PREFIX}" --enable-shared  && \
    make && \
    make install && \
    rm -rf ${DIR}
### libopus https://www.opus-codec.org/
RUN \
    DIR=/tmp/opus && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO https://archive.mozilla.org/pub/opus/opus-${OPUS_VERSION}.tar.gz && \
    echo ${OPUS_SHA256SUM} | sha256sum --check && \
    tar -zx --strip-components=1 -f opus-${OPUS_VERSION}.tar.gz && \
    autoreconf -fiv && \
    ./configure --prefix="${PREFIX}" --enable-shared && \
    make && \
    make install && \
    rm -rf ${DIR}
### libvorbis https://xiph.org/vorbis/
RUN \
    DIR=/tmp/vorbis && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO http://downloads.xiph.org/releases/vorbis/libvorbis-${VORBIS_VERSION}.tar.xz && \
    echo ${VORBIS_SHA256SUM} | sha256sum --check && \
    tar -Jx --strip-components=1 -f libvorbis-${VORBIS_VERSION}.tar.xz && \
    ./configure --prefix="${PREFIX}" --with-ogg="${PREFIX}" --enable-shared && \
    make && \
    make install && \
    rm -rf ${DIR}
### libtheora http://www.theora.org/
RUN \
    DIR=/tmp/theora && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO https://downloads.xiph.org/releases/theora/libtheora-${THEORA_VERSION}.tar.xz && \
    echo ${THEORA_SHA256SUM} | sha256sum --check && \
    tar -Jx --strip-components=1 -f libtheora-${THEORA_VERSION}.tar.xz && \
    ./configure --prefix="${PREFIX}" --with-ogg="${PREFIX}" --enable-shared && \
    make && \
    make install && \
    rm -rf ${DIR}
### libvpx https://www.webmproject.org/code/
RUN \
    DIR=/tmp/vpx && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sL https://github.com/webmproject/libvpx/archive/refs/tags/v${VPX_VERSION}.tar.gz | \
    tar -zx --strip-components=1 && \
    ./configure --prefix="${PREFIX}" --enable-vp8 --enable-vp9 --enable-pic --enable-shared \
    --disable-debug --disable-examples --disable-docs --disable-install-bins  && \
    make && \
    make install && \
    rm -rf ${DIR}
### libmp3lame http://lame.sourceforge.net/
RUN \
    DIR=/tmp/lame && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -skL https://downloads.sourceforge.net/lame/lame-${LAME_VERSION}.tar.gz | \
    tar -zx --strip-components=1 && \
    ./configure --prefix="${PREFIX}" --bindir="${PREFIX}/bin" --enable-shared --enable-nasm --enable-pic --disable-frontend && \
    make && \
    make install && \
    rm -rf ${DIR}
### xvid https://www.xvid.com/
RUN \
    DIR=/tmp/xvid && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -skLO https://downloads.xvid.com/downloads/xvidcore-${XVID_VERSION}.tar.gz && \
    tar -zx -f xvidcore-${XVID_VERSION}.tar.gz && \
    cd xvidcore/build/generic && \
    ./configure --prefix="${PREFIX}" --bindir="${PREFIX}/bin" --datadir="${DIR}" --enable-shared --enable-shared && \
    make && \
    make install && \
    rm -rf ${DIR}
### fdk-aac https://github.com/mstorsjo/fdk-aac
RUN \
    DIR=/tmp/fdk-aac && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -skLO http://downloads.sourceforge.net/opencore-amr/fdk-aac-${FDKAAC_VERSION}.tar.gz && \
    echo ${ACC_SHA256SUM} | sha256sum --check && \
    tar -zx --strip-components=1 -f fdk-aac-${FDKAAC_VERSION}.tar.gz && \
    autoreconf -fiv && \
    ./configure --prefix="${PREFIX}" --enable-shared --datadir="${DIR}" && \
    make && \
    make install && \
    rm -rf ${DIR}
## openjpeg https://github.com/uclouvain/openjpeg
RUN \
    DIR=/tmp/openjpeg && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO https://github.com/uclouvain/openjpeg/archive/v${OPENJPEG_VERSION}/openjpeg-${OPENJPEG_VERSION}.tar.gz && \
    tar -zx --strip-components=1 -f openjpeg-${OPENJPEG_VERSION}.tar.gz && \
    cmake -DBUILD_THIRDPARTY:BOOL=ON -DCMAKE_INSTALL_PREFIX="${PREFIX}" . && \
    make && \
    make install && \
    rm -rf ${DIR}
## freetype https://www.freetype.org/
RUN  \
    DIR=/tmp/freetype && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -skLO http://downloads.sourceforge.net/freetype/freetype-${FREETYPE_VERSION}.tar.xz && \
    echo ${FREETYPE_SHA256SUM} | sha256sum --check && \
    tar -Jx --strip-components=1 -f freetype-${FREETYPE_VERSION}.tar.xz && \
    ./configure --prefix="${PREFIX}" --disable-static --enable-shared && \
    make && \
    make install && \
    rm -rf ${DIR}
## libvstab https://github.com/georgmartius/vid.stab
RUN  \
    DIR=/tmp/vid.stab && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO https://github.com/georgmartius/vid.stab/archive/v${LIBVIDSTAB_VERSION}.tar.gz &&\
    echo ${LIBVIDSTAB_SHA256SUM} | sha256sum --check && \
    tar -zx --strip-components=1 -f v${LIBVIDSTAB_VERSION}.tar.gz && \
    cmake -DCMAKE_INSTALL_PREFIX="${PREFIX}" . && \
    make && \
    make install && \
    rm -rf ${DIR}
## fridibi https://www.fribidi.org/
# + https://github.com/fribidi/fribidi/issues/8
RUN  \
    DIR=/tmp/fribidi && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO https://github.com/fribidi/fribidi/releases/download/v${FRIBIDI_VERSION}/fribidi-${FRIBIDI_VERSION}.tar.xz && \
    echo ${FRIBIDI_SHA256SUM} | sha256sum --check && \
    tar -Jx --strip-components=1 -f fribidi-${FRIBIDI_VERSION}.tar.xz && \
    mkdir build && \
    cd    build && \
    meson --prefix="${PREFIX}" .. && \
    ninja && \
    rm -rf ${DIR}
## fontconfig https://www.freedesktop.org/wiki/Software/fontconfig/
RUN  \
    DIR=/tmp/fontconfig && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO https://www.freedesktop.org/software/fontconfig/release/fontconfig-${FONTCONFIG_VERSION}.tar.bz2 &&\
    tar -jx --strip-components=1 -f fontconfig-${FONTCONFIG_VERSION}.tar.bz2 && \
    ./configure -prefix="${PREFIX}" --disable-static --enable-shared && \
    make && \
    make install && \
    rm -rf ${DIR}
## libass https://github.com/libass/libass
RUN  \
    DIR=/tmp/libass && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO https://github.com/libass/libass/releases/download/${LIBASS_VERSION}/libass-${LIBASS_VERSION}.tar.xz &&\
    echo ${LIBASS_SHA256SUM} | sha256sum --check && \
    tar -Jx --strip-components=1 -f libass-${LIBASS_VERSION}.tar.xz && \
    ./autogen.sh && \
    ./configure -prefix="${PREFIX}" --disable-static --enable-shared && \
    make && \
    make install && \
    rm -rf ${DIR}
## kvazaar https://github.com/ultravideo/kvazaar
RUN \
    DIR=/tmp/kvazaar && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO https://github.com/ultravideo/kvazaar/archive/v${KVAZAAR_VERSION}.tar.gz &&\
    tar -zx --strip-components=1 -f v${KVAZAAR_VERSION}.tar.gz && \
    ./autogen.sh && \
    ./configure -prefix="${PREFIX}" --disable-static --enable-shared && \
    make && \
    make install && \
    rm -rf ${DIR}

RUN \
    dir=/tmp/aom ; \
    mkdir -p ${dir} ; \
    cd ${dir} ; \
    curl -sLO https://aomedia.googlesource.com/aom/+archive/${AOM_VERSION}.tar.gz ; \
    tar -zx -f ${AOM_VERSION}.tar.gz ; \
    rm -rf CMakeCache.txt CMakeFiles ; \
    mkdir -p ./aom_build ; \
    cd ./aom_build ; \
    cmake -DCMAKE_INSTALL_PREFIX="${PREFIX}" -DBUILD_SHARED_LIBS=1 ..; \
    make ; \
    make install ; \
    rm -rf ${dir}
