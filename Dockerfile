FROM golang:1.16-alpine3.13

WORKDIR /go
RUN apk add --no-cache bash \
        g++ \
        git \
        linux-headers \
        musl-dev \
        make \
        yarn \
        npm \
        c-ares-dev

ARG CADVISOR_VERSION=0.44.1
RUN mkdir -p src/github.com/google/cadvisor && \
        cd src/github.com/google/cadvisor && \
        git clone -b v${CADVISOR_VERSION} https://github.com/google/cadvisor.git . && \
        make build
