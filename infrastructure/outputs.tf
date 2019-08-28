output "prow_artefacts_bucket_name" {
  value = google_storage_bucket.prow-bucket.name
}

output "name" {
  value = var.name
}
output "region" {
  value = var.gke_region
}