#!/usr/bin/env bash

set -e

# key needed for admin manipulations
export CONSUL_HTTP_TOKEN=BigS3cr3t

# Set agent token
AGENT_TOKEN=$1
consul acl set-agent-token agent $AGENT_TOKEN