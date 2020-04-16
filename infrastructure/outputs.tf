output "prow_bucket_name" {
  value = module.prow-cluster.prow_artefacts_bucket_name
}

output "prow_bucket_svc_account_key" {
  value     = module.prow-cluster.prow_bucket_svc_account_key
  sensitive = true
}

output "prow_terraform_gcloud_svc_account_key" {
  value     = module.prow-cluster.prow_terraform_gcloud_svc_account_key
  sensitive = true
}

output "certmanager_svc_account_key" {
  value     = module.prow-cluster.certmanager_svc_account_key
  sensitive = true
}

output "preemptible_killer_svc_account_key" {
  value     = module.prow-cluster.preemptible_killer_key_svc_account_key
  sensitive = true
}

output "prow_credstash_reader_aws_access_key_id" {
  value = aws_iam_access_key.prow_credstash_reader.id
}

output "prow_credstash_reader_aws_secret_access_key" {
  value     = aws_iam_access_key.prow_credstash_reader.secret
  sensitive = true
}