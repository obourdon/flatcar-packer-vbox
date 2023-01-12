#!/usr/bin/env bash

set -e

# python3 -m http.server 8000
# wget http://192.168.1.22:8000/script.sh && bash script.sh

CONSUL_VERSION=${CONSUL_VERSION:-1.14.3}
NOMAD_VERSION=${NOMAD_VERSION:-1.4.3}
LOKI_VERSION=${LOKI_VERSION:-2.7.1}
VAULT_VERSION=${VAULT_VERSION:-1.12.2}
CNI_VERSION=${CNI_VERSION:-1.1.1}

/usr/bin/sudo /usr/bin/mkdir -p /opt/bin

# TODO: parametrize linux and amd64 according to uname (-m -s)
# TODO: factorize Hashicorp product same download and extract function
echo -n "Installing Consul ${CONSUL_VERSION} ..."
/usr/bin/curl -sL -o /tmp/consul.zip https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip
/usr/bin/sudo /usr/bin/unzip -o -q -d /opt/bin /tmp/consul.zip
/usr/bin/rm -f /tmp/consul.zip
echo " Done"

echo -n "Installing Nomad ${NOMAD_VERSION} ..."
/usr/bin/curl -sL -o /tmp/nomad.zip https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip
/usr/bin/sudo /usr/bin/unzip -o -q -d /opt/bin /tmp/nomad.zip
/usr/bin/rm -f /tmp/nomad.zip
echo " Done"

echo -n "Installing Vault ${VAULT_VERSION} ..."
/usr/bin/curl -sL -o /tmp/vault.zip https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip
/usr/bin/sudo /usr/bin/unzip -o -q -d /opt/bin /tmp/vault.zip
/usr/bin/rm -f /tmp/vault.zip
echo " Done"

echo -n "Installing CNI plugins ${CNI_VERSION} ..."
/usr/bin/curl -sL -o /tmp/cni-plugins.tgz https://github.com/containernetworking/plugins/releases/download/v${CNI_VERSION}/cni-plugins-linux-amd64-v${CNI_VERSION}.tgz
/usr/bin/sudo /usr/bin/mkdir -p /opt/cni/bin
/usr/bin/sudo tar -C /opt/cni/bin -xzf /tmp/cni-plugins.tgz
/usr/bin/rm -f /tmp/cni-plugins.tgz
echo " Done"

echo -n "Installing Loki ${LOKI_VERSION} ..."
/usr/bin/curl -sL -o /tmp/loki.zip https://github.com/grafana/loki/releases/download/v${LOKI_VERSION}/loki-linux-amd64.zip
/usr/bin/sudo /usr/bin/unzip -o -q -d /opt/bin /tmp/loki.zip
/usr/bin/sudo /usr/bin/mv /opt/bin/loki-linux-amd64 /opt/bin/loki
/usr/bin/rm -f /tmp/loki.zip
/usr/bin/sudo /usr/bin/mkdir -p /etc/loki /var/lib/loki

# https://grafana.com/docs/loki/latest/configuration/examples/
# https://github.com/boltdb/bolt
# https://grafana.com/blog/2020/02/19/how-loki-reduces-log-storage/
echo " Done"

echo -n "Installing Promtail ${LOKI_VERSION} ..."
/usr/bin/curl -sL -o /tmp/promtail.zip https://github.com/grafana/loki/releases/download/v${LOKI_VERSION}/promtail-linux-amd64.zip
/usr/bin/sudo /usr/bin/unzip -o -q -d /opt/bin /tmp/promtail.zip
/usr/bin/sudo /usr/bin/mv /opt/bin/promtail-linux-amd64 /opt/bin/promtail
/usr/bin/rm -f /tmp/promtail.zip
/usr/bin/sudo /usr/bin/mkdir -p /etc/promtail

# From https://gitlab.com/xavki/presentations-loki-fr/-/blob/master/3-installation-promtail/slides.md
# /etc/promtail/promtail.yml.sample
echo " Done"

echo -n "Installing Logcli ${LOKI_VERSION} ..."
/usr/bin/curl -sL -o /tmp/logcli.zip https://github.com/grafana/loki/releases/download/v${LOKI_VERSION}/logcli-linux-amd64.zip
/usr/bin/sudo /usr/bin/unzip -o -q -d /opt/bin /tmp/logcli.zip
/usr/bin/sudo /usr/bin/mv /opt/bin/logcli-linux-amd64 /opt/bin/logcli
/usr/bin/rm -f /tmp/logcli.zip
echo " Done"

# Configure of call logcli
# export LOKI_ADDR=http://localhost:3100 logcli
# logcli --addr=http://localhost:3100
# List labels
# logcli labels
# logcli labels host
# Query
# logcli query '{host="my-test-serv",job="nginx"}'
# Tail mode
# logcli query '{host="my-test-serv",job="nginx"}' --tail

echo -n "Installing Docker ..."
/usr/bin/sudo /usr/bin/systemctl enable docker
/usr/bin/sudo /usr/bin/systemctl start docker
echo " Done"

echo -n "Installing cAdvisor ..."
/usr/bin/sudo /usr/bin/mv /tmp/cadvisor /opt/bin
/usr/bin/sudo /usr/bin/chown root:root /opt/bin/cadvisor
/usr/bin/sudo /usr/bin/chmod 755 /opt/bin/cadvisor
echo " Done"
