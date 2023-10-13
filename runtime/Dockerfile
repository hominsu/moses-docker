# syntax=docker/dockerfile:1.4
ARG REPO

FROM ${REPO}/moses:devel as devel
FROM debian:bullseye-slim

# image info
ARG AUTHOR_NAME
ARG AUTHOR_EMAIL
ARG VERSION

# label
LABEL author=${AUTHOR_NAME} email=${AUTHOR_EMAIL} version=${VERSION}

RUN apt-get -yqq update &&  \
    apt-get install -yq --no-install-recommends \
    default-jre-headless \
    libgomp1 \
    perl \
    python2-minimal \
    python-is-python2 && \
    apt-get autoremove -y && \
    apt-get clean -y

COPY --from=devel /moses /moses
COPY --from=devel /usr/local/bin /usr/local/bin
COPY --from=devel /usr/local/lib /usr/local/lib

ENV LD_LIBRARY_PATH=/usr/local/lib
ENV PATH="/moses/bin:${PATH}"

WORKDIR /workspace
