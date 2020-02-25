output "prow_bucket_name" {
  value = module.prow-cluster.prow_artefacts_bucket_name
}

output "prow_bucket_svc_account_key" {
  value = module.prow-cluster.prow_bucket_svc_account_key
  sensitive = true
}

output "certmanager_svc_account_key" {
  value = module.prow-cluster.certmanager_svc_account_key
  sensitive = true
}

output "preemptible_killer_svc_account_key" {
  value = module.prow-cluster.preemptible_killer_key_svc_account_key
  sensitive = true
}