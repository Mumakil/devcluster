# Local dev setup for Consul, Vault and Nomad

Configs and scripts for running local versions of

- Consul (1 node in server/client mode) with persistent storage
- Vault (1 node) backed by Consul
- Nomad (1 node) with Vault integration

## Usage

Install `consul`, `nomad` and `vault` (OSX `brew install consul vault nomad`).

Run `./startup.sh`. It will boot consul, boot vault and initialize and unseal it, and boot nomad. The vault unseal key will be written to `.unseal_key` and the root token to `.root_token`. Shutting down everything works with `./shutdown.sh`.
