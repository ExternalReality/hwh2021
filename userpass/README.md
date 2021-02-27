# hwh2021

## Hacking With The Homies Vault Presentation

### UserPass Auth Method

As we had spoken about in the presentation, Vault, among other things, is designed to help users manage identiy. One simple way to manage identity is with classic username/password identification. As such, vault supports a username passworld authentication backend called `userpass`.

If you haven't already, start a vault server:

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

If everything is ok, we can practice using our userpass authetication backend by making our first identity!

First we want to enable the userpass authentication backend.

```
vault auth enable userpass
```

Now before we make an identity, we are going to want to establish a user policy. A policy describes what a entity is authorized to do once authenticated with vault. In the repository, we have policy file named `user_policy.hcl` let's write that policy to vault with the following command. **Note: please ensure that the path to `user_policy.hcl` is correct; this tutorial assumes `user_policy.hcl` is in the present working directory.**

vault policy write user user_policy.hcl

`user_policy.hcl` constains the following policy.

```
cat user_policy.hcl
```

You should see the following.

```
path "secret/data/*" {
    capabilities = ["read"]
}
```

The policy authorizes entities to read from the secret/data path.

Now lets write a simple identity to vault using our new policy:

```
vault write auth/userpass/users/ericj \
    password=pass \
    policies=user
```

Great! Now let's login with our newly created identity

```
vault login -method=userpass username=ericj password=pass
```

Vault should output something similar to the following:

```
Key                    Value
---                    -----
token                  s.EYbR30ZdvoPdoLOy7Nn7lN0W
token_accessor         j9WpGVV5rqWppeYlDuI6z09R
token_duration         768h
token_renewable        true
token_policies         ["default" "user"]
identity_policies      []
policies               ["default" "user"]
token_meta_username    ericj
```

We can see a new auth token has been generated, and we can also the duration of that token, and the policies associated with the token. These tokens are similar to session tokens, we can use them to restablish our identity with vault should we login as a different user. The token above is my token, if you are running these commands your token should be different. Save your token to an environment variable.

```
YOUR_TOKEN=<YOUR TOKEN FROM ABOVE>
```

Let's try loging back in with our root token:

```
vault login root
```

Now let's log back in with our newly created userpass token:

```
vault login $YOUR_TOKEN
```

You should see that Vault has honored your token. 
