backend "consul" {
  address = "localhost:8500"
  path = "vault"
  disable_clustering = "true"
}

listener "tcp" {
  address = "0.0.0.0:8200"
  cluster_address = "0.0.0.0:8201"
  tls_disable = "true"
}
