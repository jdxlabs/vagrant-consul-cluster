#!/usr/bin/env bash

set -e

# setup configs
apt install -y unzip
mkdir -p /etc/consul
mkdir -p /etc/consul.d
mv /tmp/master-consul.json  /etc/consul/config.json

# setup the consul binary
wget --quiet https://releases.hashicorp.com/consul/1.8.6/consul_1.8.6_linux_amd64.zip
unzip consul_1.8.6_linux_amd64.zip
chmod +x consul
mv consul /usr/local/bin/consul

# launch the consul agent, in background
current_ip=$(/sbin/ip -o -4 addr list enp0s8 | awk '{print $4}' | cut -d/ -f1)
consul agent \
  -node=$(hostname) \
  -bind=${current_ip} \
  -config-dir=/etc/consul.d \
  -config-file=/etc/consul/config.json > /dev/null 2>&1 &
