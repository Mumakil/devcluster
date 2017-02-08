#!/usr/bin/env bash

export VAULT_ADDR=http://127.0.0.1:8200

function parse_unseal_key() {
  head -n 1 vault_keys.txt | awk '{ print $4 }' > .unseal_key
}

function parse_root_token() {
  head -n 2 vault_keys.txt | tail -n 1 | awk '{ print $4 }' > .root_token
}

function init_vault() {
  vault init -check
  if [[ $! -eq 0 ]]; then
    echo "Doing nothing."
    exit 0
  fi
  vault init -key-shares=1 -key-threshold=1 > vault_keys.txt
  parse_unseal_key
  parse_root_token
  echo "Vault initialized, wrote key info to vault_keys.txt"
}

function unseal_vault() {
  local unseal_key=$(cat .unseal_key)
  vault unseal $unseal_key
}

if [[ $1 == "init" ]]; then
  init_vault
fi

if [[ $1 == "unseal" ]]; then
  unseal_vault
fi
