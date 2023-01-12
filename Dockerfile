FROM fedora:33

WORKDIR /go
RUN dnf update -y && dnf install -y wget git cmake gcc g++ flex bison file zlib-devel systemd-devel rsync && \
	wget -q https://go.dev/dl/go1.17.13.linux-amd64.tar.gz -O - | tar zxf - && \
	rsync -a /go/go/ /usr/local && rm -rf /go/go

ARG CADVISOR_VERSION=0.47.0
RUN mkdir -p src/github.com/google/cadvisor && \
	cd src/github.com/google/cadvisor && \
	git clone -b v${CADVISOR_VERSION} https://github.com/google/cadvisor.git . && \
	make build
