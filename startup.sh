#!/usr/bin/env bash

DATA="./data"
CONFIG="./config"

PIDS="./tmp/run"
LOGS="./tmp/logs"

mkdir -p $PIDS $LOGS "$DATA/consul"

echo "Starting consul"
consul agent \
  -server \
  -bootstrap-expect=1 \
  -bind=127.0.0.1 \
  -client=0.0.0.0 \
  -recursor=8.8.8.8 \
  -ui \
  -data-dir="${DATA}/consul" \
  -pid-file="${PIDS}/consul.pid" \
  > "$LOGS/consul.log" 2>&1 &

echo "Waiting for consul to start"
./tools/wait_for_it.sh localhost:8500 -t 0 -- echo "Consul up"


echo "Starting vault"
vault server \
  -config="${CONFIG}/vault" \
  > "$LOGS/vault.log" 2>&1 &
VAULT_PID=$!
echo $VAULT_PID > "$PIDS/vault.pid"

echo "Waiting for vault to start"
./tools/wait_for_it.sh localhost:8200 -t 0 -- echo "Vault up"

./vault.sh init
./vault.sh unseal
