gcloud_region  = "europe-west4"
gcloud_project = "ouzidev-testinfra-252513"

aws_region = "eu-west-1"

base_domain = "test-infra.ouzi.io"

credstash_region = "eu-west-1"

gke_kubernetes_version = "1.14.6-gke.13"

gke_authenticator_groups_security_group = "gke-security-groups@ouzi.dev"
prow_artefact_bucket_location           = "eu"

github_bot_token_credstash_key   = "github_bot_personal_access_token_prow"
github_bot_ssh_key_credstash_key = "github_bot_ssh_private_key"
github_org                       = "ouzi-dev"

# Prow oauth integration ( only for PR status )
prow_github_oauth_client_id_credstash_key     = "prow-github-oauth-client-id"
prow_github_oauth_client_secret_credstash_key = "prow-github-oauth-client-secret"

# Protect Prow's deck behind oauth 
prow_cluster_github_oauth_client_id_credstash_key     = "prow-cluster-github-oauth-client-id"
prow_cluster_github_oauth_client_secret_credstash_key = "prow-cluster-github-oauth-client-secret"

slack_bot_token_credstash_key = "ouzibot_slack_legacytoken"
dockerconfig_credstash_key    = "quay_bot_dockerconfig"
