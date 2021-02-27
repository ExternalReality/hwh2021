# hwh2021

Hacking With The Homies Vault Presentation

Vault Key Value Secrets Store

To get a feel for a simple Vault `secrets engine` let's start vault and test out the KV (V2) secrets engine.

First start vault in development mode and unsealed and with a simple root token `root`.

```
VAULT_UI=true VAULT_REDIRECT_ADDR=http://127.0.0.1:8210 vault server -log-level=trace -dev -dev-root-token-id=root -dev-listen-address=127.0.0.1:8210 -dev-transactional'
```

Open a new terminal tab from which we will intereact with vault.

Since we've told vault to listen on port 8210, we need to let the environment that.

```
export VAULT_ADDR=http://127.0.0.1:8210
```

Now let' check to see if Vault can hear us.

```
vault status
```

If everything is ok, we can make our first key value secret!

Let's check to see if we have the kv secrtes engine enabled
```
vault secrets list
```

Vault should outpus a line similar what below, to show you that the kv secrets engin is enabled.

```
secret/       kv           kv_2294a647           key/value secret storage
```

If the kv secrets engine is not enabled (you don't see the line above), then simply enable it:

```
vault secrets enable kv
```

We can see that the secrets engine is enabled if we do the following

```
vault secrets list
```

Now lets go ahead and write a kv secret to vault

```
vault kv put secret/data/greeting hello=world
```

Since we've written a secret we should be able read it

```
vault kv get secret/data/greeting
```

The kv secrets engine (v2) can version secrets. Let try to overwrite our original secret.

```
vault kv put secret/data/greeting hello="world, again"
```

Let's read the secret again.

```
vault kv get secret/data/greeting
```

And now let's read the original version

```
vault kv get --version=1 secret/data/greeting
```