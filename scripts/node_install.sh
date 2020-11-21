#!/bin/sh

# setup configs
mkdir /etc/consul
mv /tmp/node-consul.json  /etc/consul/config.json

# setup the consul binary
wget https://releases.hashicorp.com/consul/1.8.6/consul_1.8.6_linux_amd64.zip
unzip consul_1.8.6_linux_amd64.zip
chmod +x consul
mv consul /usr/local/bin/consul

# launch the consul agent, in background
consul agent \
  -node=agent-two \
  -bind=10.0.0.20 \
  -enable-script-checks=true \
  -data-dir=/tmp/consul \
  -config-dir=/etc/consul.d > /dev/null 2>&1 &

# join the master
consul join 10.0.0.10
