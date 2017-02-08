#!/usr/bin/env bash

PWD=$(pwd)
PID_FILES="$PWD/tmp/run"
CONSUL_PID_FILE="$PID_FILES/consul.pid"
VAULT_PID_FILE="$PID_FILES/vault.pid"

if [ -f $CONSUL_PID_FILE ]; then
  CONSUL_PID=$(cat $CONSUL_PID_FILE)
fi
if [ -f $VAULT_PID_FILE ]; then
  VAULT_PID=$(cat $VAULT_PID_FILE)
fi

if [[ $CONSUL_PID ]]; then
  echo "Killing consul ($CONSUL_PID)"
  kill $CONSUL_PID
fi
if [[ $VAULT_PID ]]; then
echo "Killing vault ($VAULT_PID)"
  kill $VAULT_PID
fi

rm -rf $CONSUL_PID_FILE $VAULT_PID_FILE
