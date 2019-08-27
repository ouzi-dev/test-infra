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
  zones   = var.zones

  cluster_name = var.cluster_name

  node_cidr_range    = var.node_cidr_range
  pod_cidr_range     = var.pod_cidr_range
  service_cidr_range = var.service_cidr_range
  master_cidr_range  = var.master_cidr_range
  gke_node_scopes    = var.gke_node_scopes
  auth_cidr_blocks   = var.auth_cidr_blocks
  kubernetes_version = var.kubernetes_version

  machine_type           = var.machine_type
  machine_disk_size      = var.machine_disk_size
  machine_is_preemptible = var.machine_is_preemptible
  min_nodes              = var.min_nodes
  max_nodes              = var.max_nodes

  daily_maintenance      = var.daily_maintenance
  disable_hpa            = var.disable_hpa
  disable_lb             = var.disable_lb
  disable_dashboard      = var.disable_dashboard
  disable_network_policy = var.disable_network_policy
  enable_calico          = var.enable_calico
  init_nodes             = var.init_nodes
}