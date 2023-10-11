# syntax=docker/dockerfile:1.4
FROM debian:bullseye-slim as base

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
