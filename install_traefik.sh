#!/usr/bin/env bash
set -e

VERSION=v2.9.9
TARGET=linux_amd64
DEST="/opt/bin"

/usr/bin/curl -sL -o /tmp/traefik.tar.gz https://github.com/containous/traefik/releases/download/${VERSION}/traefik_${VERSION}_${TARGET}.tar.gz
/usr/bin/sudo /usr/bin/tar -C ${DEST} -xzf /tmp/traefik.tar.gz traefik
/usr/bin/sudo /usr/bin/mkdir -p /var/lib/traefik/{conf,tls}
/usr/bin/rm -rf /tmp/traefik.tar.gz
