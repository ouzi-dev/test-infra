variable "gcloud_region" {
  description = "Google Cloud region"
}

variable "aws_region" {
  description = "AWS region"
}

variable "gcloud_project" {
  description = "Name of the GKE project"
}

variable "gke_name" {
  description = "Name of the GKE cluster"
}

variable "gke_min_nodes" {
  description = "Min number of workers"
  default     = 0
}

variable "gke_max_nodes" {
  description = "Max number of workers"
  default     = 4
}

variable "gke_kubernetes_version" {
  description = "Minimum k8s master version"
}

variable "gke_authenticator_groups_security_group" {
}

variable "prow_artefact_bucket_location" {
  type = string
}

variable "base_domain" {
  type = string
}

variable "google_credentials_file_path" {
  type = string
}

