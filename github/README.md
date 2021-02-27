# hwh2021

## Hacking With The Homies Vault Presentation

### Vault GitHub Auth Backend

Establishing identity with Vault's userpass authentication backend was easy, but let's try another authentication backend this time. Let's try to establish identity with GitHub.

Again, let's start vault in development mode and unsealed and with a simple root token `root`.

```
VAULT_UI=true VAULT_REDIRECT_ADDR=http://127.0.0.1:8210 vault server -log-level=trace -dev -dev-root-token-id=root -dev-listen-address=127.0.0.1:8210 -dev-transactional'
```

Open a new terminal tab from which we will intereact with vault.

Since we've told vault to listen on port 8210, we need to let the environment that.

```
export VAULT_ADDR=http://127.0.0.1:8210
```

First, we need to enable the GitHub authentication backend.

```
vault auth enable github
```

We can see that the GitHub auth backend is enabled if we do the following

```
vault auth list
```

Let's write a user policy. If you remember from earlier, a policy is just a way to tell Vault what an entity is authorized to do.

In the repository, we have policy file named user_policy.hcl let's write that policy to vault with the following command. **Note: please ensure that the path to user_policy.hcl is correct; this tutorial assumes user_policy.hcl is in the present working directory.**

```
vault policy write user user_policy.hcl
```

To configure the GitHub backend Vault needs to know the organization to which our users or teams belong. Let's give Vault that information. **Note: don't forget to replace <My GitHub Organization Name> with a valid GitHub organization name.**

```
vault write auth/github/config organization=<My GitHub Organization Name>
```

Now we can establish our first GitHub identity! Remember the GitHub user that you provide below must belong to the organization that you provided above. **Note: `vaule` is set to the policy we created above.**

```
vault write auth/github/map/users/<My GitHub Username> value=user
```

Now we have established a github identity. How do we login to vault with this identity?

First we need a personal access token for the user we provided above. Follow the guild below to make a personal access token:

https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token

Now that you have an access token. Log in using the GitHub Auth Method and personal access token.

```
vault login --method=github token=<Token You Just Created>
```