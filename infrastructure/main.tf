## Backend
terraform {
  backend "gcs" {}
}

## Providers
provider "google" {
  region      = var.gcloud_region
  project     = var.gcloud_project
  version     = "2.13"
  credentials = "${file("${var.google_credentials_file_path}")}"
}

provider "google-beta" {
  region      = var.gcloud_region
  project     = var.gcloud_project
  version     = "2.13"
  credentials = "${file("${var.google_credentials_file_path}")}"
}

provider "aws" {
  region  = var.aws_region
  version = "2.24"
}

provider "credstash" {
  region  = var.credstash_region
  version = "0.4"
}

provider "kubernetes" {
  host                   = module.gke-cluster.cluster_endpoint
  cluster_ca_certificate = base64decode(module.gke-cluster.cluster_ca_certificate)
  token                  = data.google_client_config.current.access_token
  load_config_file       = false
  version                = "1.9"
}

provider "random" {
  version = "2.2"
}

## Data
data "credstash_secret" "github_bot_token" {
  name = var.github_bot_token_credstash_key
}

data "credstash_secret" "github_bot_ssh_key" {
  name = var.github_bot_ssh_key_credstash_key
}

data "credstash_secret" "prow_github_oauth_client_secret" {
  name = var.prow_github_oauth_client_secret_credstash_key
}

data "credstash_secret" "prow_github_oauth_client_id" {
  name = var.prow_github_oauth_client_id_credstash_key
}

data "credstash_secret" "prow_github_oauth_cookie_secret" {
  name = var.prow_github_oauth_cookie_secret_credstash_key
}

data "credstash_secret" "prow_cookie_secret" {
  name = var.prow_cookie_secret_credstash_key
}

data "credstash_secret" "slack_ouzibot_token" {
  name = var.slack_ouzibot_token_credstash_key  
}


data "google_client_config" "current" {
}

## ID of this infrastructure - we use this for uniquness and tracking resources
resource "random_string" "id" {
  length  = 8
  special = false
}

## locals
locals {
  infra_id      = random_string.id.result
  prow_base_url = "prow.${var.base_domain}"
  gke_name      = "prow"
  tags = {
    SYSTEM = var.system
    UUID   = random_string.id.result
  }
}

## Modules
module "gke-cluster" {
  source  = "git@github.com:ouzi-dev/gke-terraform.git?ref=v0.3"
  region  = var.gcloud_region
  project = var.gcloud_project

  cluster_name       = local.gke_name
  zones              = var.gke_zones
  node_cidr_range    = var.gke_node_cidr_range
  pod_cidr_range     = var.gke_pod_cidr_range
  service_cidr_range = var.gke_service_cidr_range
  master_cidr_range  = var.gke_master_cidr_range
  gke_node_scopes    = var.gke_node_scopes
  auth_cidr_blocks   = var.gke_auth_cidr_blocks
  kubernetes_version = var.gke_kubernetes_version

  machine_type           = var.gke_machine_type
  big_machine_type       = var.gke_big_machine_type
  machine_disk_size      = var.gke_machine_disk_size
  machine_is_preemptible = var.gke_machine_is_preemptible
  min_nodes              = var.gke_min_nodes
  max_nodes              = var.gke_max_nodes

  daily_maintenance                   = var.gke_daily_maintenance
  disable_hpa                         = var.gke_disable_hpa
  disable_lb                          = var.gke_disable_lb
  disable_dashboard                   = var.gke_disable_dashboard
  disable_network_policy              = var.gke_disable_network_policy
  enable_calico                       = var.gke_enable_calico
  authenticator_groups_security_group = var.gke_authenticator_groups_security_group
  init_nodes                          = var.gke_init_nodes
}

## Extra resources

### Bucket for Prow
resource "google_storage_bucket" "prow_bucket" {
  name          = "${var.gcloud_project}-prow-artefacts"
  location      = var.prow_artefact_bucket_location
  force_destroy = true

  versioning {
    enabled = true
  }
}

### Service Account for Prow to write/read the artefacts in the bucket
resource "google_service_account" "prow_bucket_editor" {
  account_id   = "prow-bucket"
  display_name = "Service Account for the Prow artefact bucket"
}

resource "google_storage_bucket_iam_member" "prow_bucket_editor" {
  bucket = google_storage_bucket.prow_bucket.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.prow_bucket_editor.email}"
}

### Key for the Prow bucket service account
resource "google_service_account_key" "prow_bucket_editor_key" {
  service_account_id = google_service_account.prow_bucket_editor.name
}

### Service Account for CertManager to create DNS entries
resource "google_service_account" "certmanager_dns_editor" {
  account_id   = "certmanager"
  display_name = "Service Account for CertManager to manage dns entries"
}

resource "google_project_iam_member" "certmanager_dns_editor_role" {
  role   = "roles/dns.admin"
  member = "serviceAccount:${google_service_account.certmanager_dns_editor.email}"
}

### Key for the Cert-Manager Service Account
resource "google_service_account_key" "certmanager_dns_editor_key" {
  service_account_id = google_service_account.certmanager_dns_editor.name
}

### Token for Prow Webhook secret
resource "random_string" "hmac_token" {
  length  = 30
  special = false
}

### Service Account for Terraform
resource "google_service_account" "prow_terraform" {
  account_id   = "prow-tf"
  display_name = "Service account for Prow to execute Terraform Google Provider Resources"
}

resource "google_project_iam_member" "prow_terraform" {
  role   = "roles/editor"
  member = "serviceAccount:${google_service_account.prow_terraform.email}"
}

### Key for the Cert-Manager Service Account
resource "google_service_account_key" "prow_terraform" {
  service_account_id = google_service_account.prow_terraform.name
}

### AWS Service Account for terraform 
resource "aws_iam_user" "prow_terraform" {
  name = "tf_ouzidev_aws_service_account_${local.infra_id}"
  tags = local.tags
}

resource "aws_iam_access_key" "prow_terraform" {
  user = "${aws_iam_user.prow_terraform.name}"
}

resource "aws_iam_user_policy" "prow_terraform" {
  name = "tf_ouzidev_aws_service_account_${local.infra_id}"
  user = "${aws_iam_user.prow_terraform.name}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
        }
    ]
}
EOF
}

### DNS Zone for the Base Domain we are using
resource "google_dns_managed_zone" "cluster_zone" {
  name        = replace(var.base_domain, ".", "-")
  dns_name    = "${var.base_domain}."
  description = "${var.system} zone"
}

# resource "google_bigquery_dataset" "metering_dataset" {
#   dataset_id                  = "${var.name}_gke_metering_dataset"
#   friendly_name               = "${var.name}_gke_metering_dataset"
#   description                 = "GKE metering usage for cluster ${var.name}"
#   location                    = "EU"
#   default_table_expiration_ms = 3600000
#   delete_contents_on_destroy  = true
# }