region  = "europe-west2"
project = "testinfra-251013"
name    = "ouzi-unicorn"

gke_zones              = ["europe-west2-a", "europe-west2-b", "europe-west2-c"]
gke_kubernetes_version = "1.13.7-gke.24"
gke_node_cidr_range    = "10.101.0.0/22"
gke_pod_cidr_range     = "172.20.0.0/14"
gke_service_cidr_range = "10.200.0.0/16"
gke_master_cidr_range  = "172.16.0.32/28"
gke_node_scopes = [
  "https://www.googleapis.com/auth/compute",
  "https://www.googleapis.com/auth/devstorage.read_write",
  "https://www.googleapis.com/auth/logging.write",
  "https://www.googleapis.com/auth/monitoring"
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
gke_min_nodes              = 0
gke_max_nodes              = 4
gke_init_nodes             = 1
gke_disable_lb             = true
gke_disable_dashboard      = true
gke_enable_calico          = false
gke_disable_network_policy = true
gke_disable_hpa            = true

prow_artefact_bucket_location = "EU"
