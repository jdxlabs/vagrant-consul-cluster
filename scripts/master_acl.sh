#!/usr/bin/env bash

set -e

# key needed for admin manipulations
export CONSUL_HTTP_TOKEN=BigS3cr3t

if [[ $(hostname) == "consulmaster1" ]]; then
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

else
  # Set agent token
  AGENT_TOKEN=$1
  consul acl set-agent-token agent $AGENT_TOKEN
fi
