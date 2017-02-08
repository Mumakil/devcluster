#!/usr/bin/env bash

PWD=$(pwd)
DATA="$PWD/data"
CONFIG="$PWD/config"

PIDS="./tmp/run"
LOGS="./tmp/logs"

mkdir -p $PIDS $LOGS "$DATA/consul" "$DATA/nomad"

echo "Starting consul"
consul agent \
  -server \
  -bootstrap-expect=1 \
  -bind=127.0.0.1 \
  -client=0.0.0.0 \
  -recursor=8.8.8.8 \
  -ui \
  -data-dir="$DATA/consul" \
  -pid-file="$PIDS/consul.pid" \
  > "$LOGS/consul.log" 2>&1 &

echo "Waiting for consul to start"
./tools/wait_for_it.sh localhost:8500 -t 0 -- echo "Consul up"
sleep 2

echo "Starting vault"
vault server \
  -config="${CONFIG}/vault" \
  > "$LOGS/vault.log" 2>&1 &
VAULT_PID=$!
echo $VAULT_PID > "$PIDS/vault.pid"

echo "Waiting for vault to start"
./tools/wait_for_it.sh localhost:8200 -t 0 -- echo "Vault up"
sleep 2

echo "Ensuring vault is initialized and unsealed"
./vault.sh init
./vault.sh unseal

VAULT_TOKEN=$(cat .root_token | tr -d \[:blank:\])

echo "Starting nomad"
nomad agent \
  -server \
  -bootstrap-expect=1 \
  -bind=127.0.0.1 \
  -client \
  -dc=dc1 \
  -data-dir="$DATA/nomad" \
  -vault-enabled \
  -vault-address="http://127.0.0.1:8200" \
  -vault-token="$VAULT_TOKEN" \
  -config="$CONFIG/nomad" \
  > "$LOGS/nomad.log" 2>&1 &
NOMAD_PID=$!
echo $NOMAD_PID > "$PIDS/nomad.pid"

echo "Waiting for nomad to start"
./tools/wait_for_it.sh localhost:4646 -t 0 -- echo "Nomad up"
