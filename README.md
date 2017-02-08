# Local dev setup for Consul and Vault

Configs and scripts for running local versions of

- Consul (1 node in server/client mode) with persistent storage
- Vault (1 node) backed by Consul

## Usage

Install `consul` and `vault` (OSX `brew install consul vault`).

Run `./startup.sh`. It will boot consul, boot vault and initialize and unseal it. The vault unseal key will be written to `.unseal_key` and the root token to `.root_token`. Shutting down everything works with `./shutdown.sh`.
