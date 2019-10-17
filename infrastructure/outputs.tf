# GCloud outputs
output "gcloud_region" {
  value = var.gcloud_region
}

output "gcloud_project" {
  value = var.gcloud_project
}

# GKE outputs

output "gke_name" {
  value = module.prow-cluster.gke_name
}

output "valuesyaml" {
  value     = module.prow-cluster.valuesyaml
  sensitive = true
}