variable "gke_region" {
  description = "GKE cluster region"
}

variable "aws_region" {
  description = "AWS region"
}

variable "project" {
  description = "Name of the project"
}

variable "name" {
  description = "Name of the environment"
}

# See: https://cloud.google.com/kubernetes-engine/docs/how-to/ip-aliases
variable "gke_node_cidr_range" {
  description = "VPC nodes CIDR range"
}

variable "gke_pod_cidr_range" {
  description = "VPC pods CIDR range"
}

variable "gke_service_cidr_range" {
  description = "VPC services CIDR range"
}

variable "gke_master_cidr_range" {
  description = "CIDR range for masters"
}

variable "gke_node_scopes" {
  description = "The GKE node scopes"
  type        = list(string)
  default = [
    "https://www.googleapis.com/auth/compute",
    "https://www.googleapis.com/auth/devstorage.read_write",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring",
  ]
}

variable "gke_zones" {
  description = "GKE Cluster zones"
  type        = list(string)
}

variable "gke_auth_cidr_blocks" {
  type        = list
  description = "Authorized cidr blocks for the API"
}

variable "gke_kubernetes_version" {
  description = "Minimum k8s master version"
}

variable "gke_machine_type" {
  description = "Instance type for the primary pool of workers"
}

variable "gke_machine_disk_size" {
  description = "Disk size for the primary pool of workers"
}

variable "gke_machine_is_preemptible" {
  description = "If true use preemptible instances"
}

variable "gke_min_nodes" {
  description = "Min number of workers"
  default     = 0
}

variable "gke_max_nodes" {
  description = "Max number of workers"
}

variable "gke_daily_maintenance" {
  default = "02:00"
}

variable "gke_disable_hpa" {
  default = false
}

variable "gke_disable_lb" {
  default = false
}

variable "gke_disable_dashboard" {
  default = false
}

variable "gke_disable_network_policy" {
  default = false
}

variable "gke_enable_calico" {
  default = true
}

variable "gke_init_nodes" {
}

variable "gke_authenticator_groups_security_group" {
}

variable "prow_artefact_bucket_location" {
  type = string
}

variable "github_bot_token_credstash_key" {
  type = string
}

variable "prow-github-oauth-client-id_credstash_key" {
  type = string
}

variable "prow-github-oauth-client-secret_credstash_key" {
  type = string
}

variable "prow-github-oauth-cookie-secret_credstash_key" {
  type = string
}

variable "prow-cookie-secret_credstash_key" {
  type = string
}

variable "credstash_region" {
  type = string
}

variable "base_domain" {
  type = string
}

variable "slack-token_secret_credstash_key" {
  type = string
}

variable "github_bot_ssh_key_credstash_key" {
  type = string
}

variable "google_credentials_file_path" {
  type = string
  
}
