# Prow

The Prow folder contains all the resources necessary to get Prow operational in a k8s cluster. We make some assumptions, that the cluster supports fully RBAC and that some secrets have been pre-seeded. 

## Make targets

This is not an exhaustive list of make targets but the ones we will use more often

- cluster-install: Installs all required components on the cluster minus Prow
- cluster-uninstall: Uninstalls all required components on the cluster minus Prow
- prow-install: Installs prow
- prow-config-update: Update the Prow config found in [config.yaml](config.yaml) [plugins.yaml](plugins.yaml) [labels.yaml](labels.yaml)
- prow-uninstall: Uninstalls Prow
- install: Installs everything needed including Prow
- uninstall: Uninstalls everything from the cluster

## Secrets needed

Secrets expected in the cluster:
- Name: oauth-token
  Namespace: prow 
  Description: The user/token Prow will use to interface with GitHub. User is `ouzibot` - Settings/Developer settings/Personal Access Tokens with scopes: admin:org_hook, repo
  Credash Key: `github_bot_*`
- Name: github-oauth-config
  Namespace: prow
  Description: The oauth config for Prow PR. Format is:
  ```
    client_id: ${client_id}
    client_secret: ${client_secret}
    redirect_url: ${redirect_url}
    final_redirect_url: ${final_redirect_url}
    scopes:
      - repo  
  ```
  Credash Key: `prow-github-oauth-*`
- Name: github-oauth-secret
  Namespace: prow
  Description: The oauth config for everything in Prow.
  ```
    client-id: {{.oauth.client_id}}
    client-secret: {{.oauth.client_secret}}
    cookie-secret:  {{.oauth.cookie_secret}}
  ```
  Credash Key: `prow-cluster-github-oauth-*`
- Name: cookie
  Namespace: prow
  Description: A randomly generated cookine for Prow oauth `openssl rand -out cookie.txt -base64 32`
  Credash Key: `prow-cookie-secret`

## GitHub user - ouzibot

Prow requires a user to interact with GitHub. We use the ouzibot and have created a personal access token which Prow uses from credstash

## Configuring Org-wide webhooks

Prow needs to be told when changes happen in GitHub. To do that, you should create an Org wide webhook with endpoint PROW_DOMAIN/hook, send all events and use `kubectl get secret hmac-token -n prow -o json | jq -r .data.hmac | base64 -D` as the secret.

## Cluster-Bootstrap

This folder contains all the components required in the cluster in order to get:
- Helm operational
- RBAC access to the cluster
- Various components like tls certificate management, cloud dns record management etc 

## Manifests

This folder contains all the propw manifests needed to get Prow up and running.

## Config

Prow's config

## Plugins

Prow's plugins config

## Labels

Prow's labels config