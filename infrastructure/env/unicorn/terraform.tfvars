gke_region = "us-east1"
aws_region = "eu-west-1"
project    = "testinfra-251013"
name       = "unicorn"
base_domain = "ouzi.io"

gke_zones              = ["us-east1-b", "us-east1-c", "us-east1-d"]
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
gke_machine_type           = "n1-standard-2"
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
prow_artefact_bucket_location           = "us"

ouzibot_credstash_key = "github_bot_personal_access_token_prow"
prow-github-oauth-client-id_credstash_key = "prow-github-oauth-client-id"
prow-github-oauth-client-secret_credstash_key = "prow-github-oauth-client-secret"
prow-github-oauth-cookie-secret_credstash_key = "prow-github-oauth-cookie-secret"
prow-cookie-secret_credstash_key = "prow-cookie-secret"
credstash_region      = "eu-west-1"

