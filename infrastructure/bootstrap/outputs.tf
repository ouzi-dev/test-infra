output "gke_project" {
  value = var.gke_project
}

output "service_account_key" {
  value       = google_service_account_key.terraform.private_key
  description = "The service account terraform will use to create things in this project"
  sensitive   = true
}