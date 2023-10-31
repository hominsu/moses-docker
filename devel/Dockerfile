# syntax=docker/dockerfile:1.4
FROM debian:bullseye-slim

# image info
ARG AUTHOR_NAME
ARG AUTHOR_EMAIL
ARG VERSION

# label
LABEL author=${AUTHOR_NAME} email=${AUTHOR_EMAIL} version=${VERSION}

ARG PREFIX=/opt/moses
ARG MOSES=/moses

ENV BUILD_DEPS="autoconf    \
                automake    \
                ca-certificates \
                cmake   \
                curl    \
                g++ \
                gcc \
                git \
                libbz2-dev  \
                libicu-dev  \
                libtool \
                libunistring-dev    \
                make    \
                pkg-config  \
                tk-dev  \
                zlib1g-dev"

RUN apt-get -yqq update &&  \
    apt-get install -yq --no-install-recommends ${BUILD_DEPS}

# CMPH https://sourceforge.net/projects/cmph/files/v2.0.2/cmph-2.0.2.tar.gz/download
RUN DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sL https://sourceforge.net/projects/cmph/files/v2.0.2/cmph-2.0.2.tar.gz/download | \
    tar -zx --strip-components=1 && \
    ./configure --prefix="${PREFIX}" && \
    make -j $(nproc) && \
    make install && \
    rm -rf ${DIR}

# boost https://boostorg.jfrog.io/artifactory/main/release/1.83.0/source/boost_1_83_0.tar.gz
RUN DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sL https://boostorg.jfrog.io/artifactory/main/release/1.83.0/source/boost_1_83_0.tar.gz | \
    tar -zx --strip-components=1 && \
    ./bootstrap.sh && \
    ./b2 --prefix=${PREFIX} --libdir=${PREFIX}/lib64 --layout=system link=static install -j$(nproc) && \
    rm -rf ${DIR}

# mgiza https://github.com/moses-smt/mgiza
RUN DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sL https://github.com/moses-smt/mgiza/archive/refs/heads/master.tar.gz | \
    tar -zx --strip-components=1 && \
    cd mgizapp && \
    BOOST_ROOT=${PREFIX} BOOST_LIBRARYDIR=${BOOST_ROOT}/lib64 \
    cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=${PREFIX} -DCMAKE_INSTALL_BINDIR=bin && \
    cmake --build ./build --parallel $(nproc) && \
    cmake --install ./build && \
    rm -rf ${DIR}

# moses https://github.com/moses-smt/mosesdecoder
RUN DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sL https://github.com/moses-smt/mosesdecoder/archive/refs/heads/master.tar.gz | \
    tar -zx --strip-components=1 && \
    ./bjam \
    --with-boost=${PREFIX} \
    --with-cmph=${PREFIX} \
    --prefix=${MOSES} \
    -j$(nproc) && \
    cp -r scripts /moses/ && \
    rm -rf ${DIR}

# cleanup
RUN for bin in $(find ${PREFIX}/bin -type f -executable); do \
        if file ${bin} | grep -q "dynamically linked"; \
          then ldd ${bin} | grep /opt/moses; \
    fi; \
    done | cut -d ' ' -f 3 | xargs -i cp {} /usr/local/lib/ && \
    for lib in /usr/local/lib/*.so.*; do ln -s "${lib##*/}" "${lib%%.so.*}".so; done && \
    cp -r ${PREFIX}/bin/* /usr/local/bin/ && \
    hash -r

ENV LD_LIBRARY_PATH=/usr/local/lib
ENV PATH="/moses/bin:${PATH}"
