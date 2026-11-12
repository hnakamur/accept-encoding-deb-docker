# syntax=docker/dockerfile:1
ARG FROM=ubuntu:26.04
FROM ${FROM}

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install tzdata git curl build-essential rustc cargo && \
    cargo install cargo-deb@3.8.0

ARG SRC_DIR=/src
ARG BUILD_USER=build
RUN useradd -m -d ${SRC_DIR} ${BUILD_USER}

ARG SRC_DIR=/src
WORKDIR ${SRC_DIR}
ARG PKG_VERSION
RUN git clone --depth 1 --branch ${PKG_VERSION} https://github.com/hnakamur/accept-encoding
WORKDIR ${SRC_DIR}/accept-encoding
ARG DEB_REVISION=1
RUN cargo deb --deb-revision ${DEB_REVISION} --output /src --dbgsym

USER root
