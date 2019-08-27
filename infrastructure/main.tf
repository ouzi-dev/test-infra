terraform {
  backend "gcs" {}
}

provider "google" {
  region  = var.region
  project = var.project
}

provider "google-beta" {
  region  = var.region
  project = var.project
}

module "gke-cluster" {
  source  = "../../gke-terraform"
  region  = var.region
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

  daily_maintenance      = var.gke_daily_maintenance
  disable_hpa            = var.gke_disable_hpa
  disable_lb             = var.gke_disable_lb
  disable_dashboard      = var.gke_disable_dashboard
  disable_network_policy = var.gke_disable_network_policy
  enable_calico          = var.gke_enable_calico
  init_nodes             = var.gke_init_nodes
}

resource "google_storage_bucket" "prow-bucket" {
  name          = "${var.name}_prow-artifacts"
  location      = var.prow_artefact_bucket_location
  force_destroy = true

  versioning {
    enabled = true
  }
}

resource "google_service_account" "prow-bucket-editor" {
  account_id   = "${var.name}-prow-bucket"
  display_name = "service account for the prow bucket"
}

resource "google_storage_bucket_iam_member" "prow-bucket-editor" {
  bucket      = google_storage_bucket.prow-bucket.name
  role        = "roles/storage.objectAdmin"
  member      = "serviceAccount:${google_service_account.prow-bucket-editor.email}"
}

resource "google_service_account_key" "prow-bucket-editor_key" {
  service_account_id = google_service_account.prow-bucket-editor.name
}

data "google_client_config" "current" {
}

provider "kubernetes" {
  host                   = module.gke-cluster.cluster_endpoint
  cluster_ca_certificate = base64decode(module.gke-cluster.cluster_ca_certificate)
  token                  = data.google_client_config.current.access_token
  load_config_file       = false
}

resource "kubernetes_secret" "gcs-bucket-credentials" {
  metadata {
    name = "gcs-bucket-credentials"
  }

  data = {
    "service-account.json" = base64decode(google_service_account_key.prow-bucket-editor_key.private_key)
  }
}

resource "google_dns_managed_zone" "cluster-zone" {
  name = "${var.name}-zone"
  dns_name = "${var.name}.ouzi.io."
  description = "${var.name} zone"
}
