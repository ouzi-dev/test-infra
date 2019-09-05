provider "google" {
  region  = var.tf_state_region
  project = var.gke_project
}

resource "google_project" "project" {
  name = var.gke_project
  project_id = var.gke_project
  org_id     = var.gke_org_id
  billing_account = var.gke_billing_account
}

resource "google_storage_bucket" "terraform-bucket" {
  name          = var.tf_bucket_name
  location      = var.tf_bucket_location
  force_destroy = true

  versioning {
    enabled = true
  }

  depends_on = [
    google_project.project,
    google_project_services.main,
  ]
}

resource "google_project_services" "main" {
  project  = var.gke_project
  services = [
    "bigquery-json.googleapis.com",
    "bigquerystorage.googleapis.com",
    "cloudapis.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "dns.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "storage-api.googleapis.com",
    "storage-component.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "oslogin.googleapis.com",
    "pubsub.googleapis.com",
    "servicemanagement.googleapis.com",
    "serviceusage.googleapis.com",
    "sql-component.googleapis.com",
    "containerregistry.googleapis.com",
    "datastore.googleapis.com",
    "clouddebugger.googleapis.com",
    "cloudtrace.googleapis.com",
  ]

  depends_on = [
    google_project.project,
  ]
}