terraform {
  backend "gcs" {}
}

## Providers
provider "google" {
  region  = var.gke_region
  project = var.project
  version = "2.13"
}

provider "google-beta" {
  region  = var.gke_region
  project = var.project
  version = "2.13"
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

data "credstash_secret" "prow-github-oauth-client-secret" {
  name = var.prow-github-oauth-client-secret_credstash_key
}

data "credstash_secret" "prow-github-oauth-client-id" {
  name = var.prow-github-oauth-client-id_credstash_key
}

data "credstash_secret" "prow-github-oauth-cookie-secret" {
  name = var.prow-github-oauth-cookie-secret_credstash_key
}

data "credstash_secret" "prow-cookie-secret" {
  name = var.prow-cookie-secret_credstash_key
}

data "google_client_config" "current" {
}

## locals
locals {
  prow_base_url = "prow.${var.name}.${var.base_domain}"
}


## Modules
module "gke-cluster" {
  source  = "git@github.com:ouzi-dev/gke-terraform.git?ref=v0.1"
  region  = var.gke_region
  project = var.project

  cluster_name       = var.name
  zones              = var.gke_zones
  node_cidr_range    = var.gke_node_cidr_range
  pod_cidr_range     = var.gke_pod_cidr_range
  service_cidr_range = var.gke_service_cidr_range
  master_cidr_range  = var.gke_master_cidr_range
  gke_node_scopes    = var.gke_node_scopes
  auth_cidr_blocks   = var.gke_auth_cidr_blocks
  kubernetes_version = var.gke_kubernetes_version

  machine_type           = var.gke_machine_type
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

### Google Cloud Storage for prow artefacts
resource "google_storage_bucket" "prow-bucket" {
  name          = "${var.name}_prow-artifacts"
  location      = var.prow_artefact_bucket_location
  force_destroy = true

  versioning {
    enabled = true
  }
}

### Google Service Account for Prow to write/read the artefacts in the bucket
resource "google_service_account" "prow-bucket-editor" {
  account_id   = "${var.name}-prow-bucket"
  display_name = "service account for the prow bucket"
}

resource "google_storage_bucket_iam_member" "prow-bucket-editor" {
  bucket = google_storage_bucket.prow-bucket.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.prow-bucket-editor.email}"
}

resource "google_service_account_key" "prow-bucket-editor_key" {
  service_account_id = google_service_account.prow-bucket-editor.name
}

resource "kubernetes_secret" "gcs-credentials" {
  metadata {
    name      = "gcs-credentials"
    namespace = "prow"
  }

  data = {
    "service-account.json" = base64decode(google_service_account_key.prow-bucket-editor_key.private_key)
  }
}

### Google Service Account for CertManager to create DNS entries
resource "google_service_account" "certmanager-dns-editor" {
  account_id   = "${var.name}-certmanager-dns-editor"
  display_name = "service account for certmanager to edit dns entries"
}

resource "google_project_iam_binding" "certmanager-dns-editor_role" {
  role = "roles/dns.admin"
  members = [
    "serviceAccount:${google_service_account.certmanager-dns-editor.email}",
  ]
}

resource "google_service_account_key" "certmanager-dns-editor_key" {
  service_account_id = google_service_account.certmanager-dns-editor.name
}

resource "kubernetes_secret" "certmanager-dns-editor" {
  metadata {
    name      = "clouddns-dns01-solver-svc-acct"
    namespace = "cert-manager"
  }

  data = {
    "key.json" = base64decode(google_service_account_key.certmanager-dns-editor_key.private_key)
  }
}

resource "random_string" "hmac-token" {
  length  = 30
  special = false
}

resource "kubernetes_secret" "hmac-token" {
  metadata {
    name      = "hmac-token"
    namespace = "prow"
  }

  data = {
    hmac = random_string.hmac-token.result
  }
}

resource "kubernetes_secret" "oauth-token" {
  metadata {
    name      = "oauth-token"
    namespace = "prow"
  }

  data = {
    oauth = data.credstash_secret.github_bot_token.value
  }
}

resource "kubernetes_secret" "oauth2proxy-github-oauth-config" {
  metadata {
    name      = "github-oauth-secret"
    namespace = "oauth2-proxy"
  }

  data = {
    client-id     = data.credstash_secret.prow-github-oauth-client-id.value
    client-secret = data.credstash_secret.prow-github-oauth-client-secret.value
    cookie-secret = data.credstash_secret.prow-github-oauth-cookie-secret.value
  }
}

resource "kubernetes_secret" "prow-github-oauth-config" {
  metadata {
    name      = "github-oauth-config"
    namespace = "prow"
  }

  data = {
    secret = templatefile(
      "${path.module}//templates/_prow_github_oauth_config.yaml",
      {
        client_id          = data.credstash_secret.prow-github-oauth-client-id.value,
        client_secret      = data.credstash_secret.prow-github-oauth-client-secret.value,
        redirect_url       = "https://${local.prow_base_url}/github-login/redirect",
        final_redirect_url = "https://${local.prow_base_url}/pr",
      }
    )
  }
}

resource "kubernetes_secret" "prow-cookie" {
  metadata {
    name      = "cookie"
    namespace = "prow"
  }

  data = {
    secret = data.credstash_secret.prow-cookie-secret.value
  }
}

resource "google_dns_managed_zone" "cluster-zone" {
  name        = "${var.name}-zone"
  dns_name    = "${var.name}.ouzi.io."
  description = "${var.name} zone"
}

resource "google_bigquery_dataset" "metering_dataset" {
  dataset_id                  = "${var.name}_gke_metering_dataset"
  friendly_name               = "${var.name}_gke_metering_dataset"
  description                 = "GKE metering usage for cluster ${var.name}"
  location                    = "EU"
  default_table_expiration_ms = 3600000
  delete_contents_on_destroy  = true
}