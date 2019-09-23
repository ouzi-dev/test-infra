gcloud_region  = "europe-west4"
gcloud_project = "ouzidev-testinfra-252513"

aws_region = "eu-west-1"

base_domain = "test-infra.ouzi.io"

credstash_region = "eu-west-1"

gke_zones              = ["europe-west4-a", "europe-west4-b", "europe-west4-c"]
gke_kubernetes_version = "1.13.7-gke.24"
gke_node_cidr_range    = "10.101.0.0/22"
gke_pod_cidr_range     = "172.20.0.0/14"
gke_service_cidr_range = "10.200.0.0/16"
gke_master_cidr_range  = "172.16.0.32/28"
gke_node_scopes = [
  "https://www.googleapis.com/auth/compute",
  "https://www.googleapis.com/auth/devstorage.read_write",
  "https://www.googleapis.com/auth/logging.write",
  "https://www.googleapis.com/auth/monitoring",
  "https://www.googleapis.com/auth/ndev.clouddns.readwrite"
]
gke_machine_type           = "n2-standard-2"
gke_big_machine_type       = "n2-standard-4"
gke_machine_disk_size      = 50
gke_machine_is_preemptible = true
gke_auth_cidr_blocks = [
  {
    cidr_block   = "0.0.0.0/0",
    display_name = "everyone"
  }
]
gke_min_nodes                           = 0
gke_max_nodes                           = 4
gke_init_nodes                          = 1
gke_disable_lb                          = true
gke_disable_dashboard                   = true
gke_enable_calico                       = true
gke_disable_network_policy              = false
gke_disable_hpa                         = true
gke_authenticator_groups_security_group = "gke-security-groups@ouzi.dev"
prow_artefact_bucket_location           = "eu"

github_bot_token_credstash_key   = "github_bot_personal_access_token_prow"
github_bot_ssh_key_credstash_key = "github_bot_ssh_private_key"
github_org                       = "ouzi-dev"

prow_github_oauth_client_id_credstash_key     = "prow-github-oauth-client-id"
prow_github_oauth_client_secret_credstash_key = "prow-github-oauth-client-secret"
prow_github_oauth_cookie_secret_credstash_key = "prow-github-oauth-cookie-secret"
prow_cookie_secret_credstash_key              = "prow-cookie-secret"
slack_ouzibot_token_credstash_key             = "ouzibot_slack_legacytoken"
quay_bot_dockerconfig_credstash_key           = "quay_bot_dockerconfig"
