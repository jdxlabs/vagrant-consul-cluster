#!/bin/sh

touch /init-done

# setup the consul binary
wget https://releases.hashicorp.com/consul/1.8.6/consul_1.8.6_linux_amd64.zip
unzip consul_1.8.6_linux_amd64.zip
chmod +x consul
mv consul /usr/local/bin/consul

# launch the consul agent, in background
consul agent \
  -server \
  -bootstrap-expect=1 \
  -node=agent-one \
  -bind=10.0.0.10 \
  -data-dir=/tmp/consul \
  -config-dir=/etc/consul.d > /dev/null 2>&1 &
