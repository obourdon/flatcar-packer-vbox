#!/usr/bin/env bash
set -e

NETDATA_VERSION=1.45.3
DEST="/opt/bin"

/usr/bin/sudo /usr/bin/curl -sL -o ${DEST}/kickstart.sh https://raw.githubusercontent.com/netdata/netdata/v${NETDATA_VERSION}/packaging/installer/kickstart.sh
/usr/bin/sudo /usr/bin/bash ${DEST}/kickstart.sh --non-interactive --stable-channel --dont-start-it --no-updates --install-version ${NETDATA_VERSION}
/usr/bin/sudo /usr/bin/rm -rf ${DEST}/kickstart.sh

# Do not launch netdata by default
/usr/bin/sudo /usr/bin/systemctl stop netdata
/usr/bin/sudo /usr/bin/systemctl disable netdata
