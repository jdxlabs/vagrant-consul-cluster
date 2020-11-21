#!/usr/bin/env bash

set -ex

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
current_ip=$(/sbin/ip -o -4 addr list enp0s8 | awk '{print $4}' | cut -d/ -f1)
consul agent \
  -node=$(hostname) \
  -bind=${current_ip} \
  -config-dir=/etc/consul.d \
  -config-file=/etc/consul/config.json > /dev/null 2>&1 &

if [[ $(hostname) == "consulmaster1" ]]; then
  # waits cluster readyness..
  sleep 30

  # key needed for admin manipulations
  export CONSUL_HTTP_TOKEN=BigS3cr3t

  # Set some KVs
  consul kv put var1 value1
  consul kv put var2 value2
  consul kv put var3 value3

  # Set ACLs config
  #
  # Allow anonymous access for DNS
  # https://www.consul.io/docs/commands/acl/token/update
  ##
  consul acl policy create -name "dns-requests" -rules @/tmp/dns-request-policy.hcl
  consul acl token update -id "00000000-0000-0000-0000-000000000002" -policy-name dns-requests
  # Create agent token
  # https://www.consul.io/docs/commands/acl/token/create
  # https://www.consul.io/docs/commands/acl/set-agent-token
  ##
  consul acl policy create -name "agent" -rules @/tmp/agent-policy.hcl
  RES=$(consul acl token create -description "Agent Token" -policy-name agent)
  AGENT_TOKEN=$(echo $RES  | cut -d" " -f4)
  consul acl set-agent-token agent $AGENT_TOKEN
fi

