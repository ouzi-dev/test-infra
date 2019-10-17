variable "gcloud_region" {
  description = "Google Cloud region"
}

variable "aws_region" {
  description = "AWS region"
}

variable "gcloud_project" {
  description = "Name of the GKE project"
}

variable "gke_kubernetes_version" {
  description = "Minimum k8s master version"
}

variable "gke_authenticator_groups_security_group" {
}

variable "prow_artefact_bucket_location" {
  type = string
}

variable "github_bot_token_credstash_key" {
  type = string
}

variable "github_bot_ssh_key_credstash_key" {
  type = string
}

variable "github_org" {
  type = string
}

variable "prow_github_oauth_client_id_credstash_key" {
  type = string
}

variable "prow_github_oauth_client_secret_credstash_key" {
  type = string
}

variable "prow_cluster_github_oauth_client_id_credstash_key" {
  type = string
}

variable "prow_cluster_github_oauth_client_secret_credstash_key" {
  type = string
}

variable "slack_bot_token_credstash_key" {
  type = string
}

variable "dockerconfig_credstash_key" {
  type = string
}

variable "credstash_region" {
  type = string
}

variable "base_domain" {
  type = string
}

variable "google_credentials_file_path" {
  type = string
}
