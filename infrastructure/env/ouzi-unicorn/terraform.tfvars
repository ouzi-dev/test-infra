region             = "europe-west2"
project            = "testinfra-251013"
zones              = ["europe-west2-a", "europe-west2-b", "europe-west2-c"]
cluster_name       = "ouzi-unicorn"
kubernetes_version = "1.13.7-gke.24"
node_cidr_range    = "10.101.0.0/22"
pod_cidr_range     = "172.20.0.0/14"
service_cidr_range = "10.200.0.0/16"
master_cidr_range  = "172.16.0.32/28"
gke_node_scopes = [
  "https://www.googleapis.com/auth/compute",
  "https://www.googleapis.com/auth/devstorage.read_write",
  "https://www.googleapis.com/auth/logging.write",
  "https://www.googleapis.com/auth/monitoring"
]
machine_type           = "n1-standard-2"
machine_disk_size      = 50
machine_is_preemptible = true
auth_cidr_blocks = [
  {
    cidr_block   = "0.0.0.0/0",
    display_name = "everyone"
  }
]
min_nodes              = 0
max_nodes              = 4
init_nodes             = 1
disable_lb             = true
disable_dashboard      = true
enable_calico          = false
disable_network_policy = true
disable_hpa            = true
