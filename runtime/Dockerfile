# syntax=docker/dockerfile:1.4
ARG REPO

FROM ${REPO}/moses:devel as devel
FROM ${REPO}/moses:base

# image info
ARG AUTHOR_NAME
ARG AUTHOR_EMAIL
ARG VERSION

# label
COPY --from=devel /moses /moses
COPY --from=devel /usr/local/bin /usr/local/bin
COPY --from=devel /usr/local/lib /usr/local/lib

ENV LD_LIBRARY_PATH=/usr/local/lib
ENV PATH="/moses/bin:${PATH}"

WORKDIR /workspace
