variable "tf_state_region" {
  description = "GCE region"
}

variable "gke_project" {
  description = "Name of the project"
}

variable "tf_bucket_name" {
  description = "Name of the bucket for terraform state"
}

variable "tf_bucket_location" {
  description = "Location of the bucket for terraform state"
}

variable "gke_org_id" {
  description = "The organisation id of the Google Cloud account"
}

variable "gke_billing_account" {
  description = "The billing account to use"
}
