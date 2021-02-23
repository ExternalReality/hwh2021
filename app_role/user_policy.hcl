path "secret/data/apps/app1" {
    capabilities = ["read", "create", "update"]
}

path "secret/data/*" {
    capabilities = ["read"]
}