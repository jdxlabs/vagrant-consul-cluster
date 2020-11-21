#!/bin/sh

# setup configs
apt install -y unzip
mkdir /etc/consul
mkdir /etc/consul.d
mv /tmp/master-consul.json  /etc/consul/config.json

# setup the consul binary
wget --quiet https://releases.hashicorp.com/consul/1.8.6/consul_1.8.6_linux_amd64.zip
unzip consul_1.8.6_linux_amd64.zip
chmod +x consul
mv consul /usr/local/bin/consul

# launch the consul agent, in background
consul agent \
  -server \
  -ui \
  -bootstrap-expect=1 \
  -node=$(hostname) \
  -bind=10.0.0.11 \
  -data-dir=/tmp/consul \
  -config-dir=/etc/consul.d > /dev/null 2>&1 &
