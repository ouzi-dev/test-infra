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

output "prow_aws_access_key_id" {
  value = module.prow-cluster.prow_terraform_aws_svc_account_access_key_id
  sensitive = true
}

output "prow_aws_secret_access_key" {
  value = module.prow-cluster.prow_terraform_aws_svc_account_secret_access_key
  sensitive = true
}