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

module "prow-cluster" {
  source = "git@github.com:ouzi-dev/prow-gke-terraform.git?ref=v0.2"

  gcloud_region              = var.gcloud_region
  gcloud_project             = var.gcloud_project
  gke_kubernetes_version     = var.gke_kubernetes_version
  dockerconfig_credstash_key = var.dockerconfig_credstash_key

  base_domain = var.base_domain
  github_org  = var.github_org

  slack_bot_token_credstash_key = var.slack_bot_token_credstash_key
  prow_artefact_bucket_location = var.prow_artefact_bucket_location

  gke_authenticator_groups_security_group = var.gke_authenticator_groups_security_group
}