# GKE outputs
output "gke_region" {
  value = var.gke_region
}

output "gke_project" {
  value = var.gke_project
}

## Prow related outputs
output "prow_bucket_svc_account_key" {
  value     = google_service_account_key.prow_bucket_editor_key.private_key
  sensitive = true
}

output "prow_webhook_hmac_token" {
  value     = random_string.hmac_token.result
  sensitive = true
}

output "prow_github_bot_token" {
  value     = data.credstash_secret.github_bot_token.value
  sensitive = true
}

output "prow_github_bot_ssh_key" {
  value     = data.credstash_secret.github_bot_ssh_key.value
  sensitive = true
}

output "prow_github_oauth_client_id" {
  value     = data.credstash_secret.prow_github_oauth_client_id.value
  sensitive = true
}

output "prow_github_oauth_client_secret" {
  value     = data.credstash_secret.prow_github_oauth_client_secret.value
  sensitive = true
}

output "prow_github_oauth_cookie_secret" {
  value     = data.credstash_secret.prow_github_oauth_cookie_secret.value
  sensitive = true
}

output "prow_cookie_secret" {
  value     = data.credstash_secret.prow_cookie_secret.value
  sensitive = true
}

output "prow_terraform_gcloud_svc_account_key" {
  value     = google_service_account_key.prow_terraform.private_key
  sensitive = true
}

output "prow_terraform_aws_svc_account_access_key_id" {
  value     = aws_iam_access_key.prow_terraform.id
  sensitive = true
}

output "prow_terraform_aws_svc_account_secret_access_key" {
  value     = aws_iam_access_key.prow_terraform.secret
  sensitive = true
}

output "prow_artefacts_bucket_name" {
  value = google_storage_bucket.prow_bucket.name
}

output "prow_base_url" {
  value = local.prow_base_url
}

## Cert-Manager outputs
output "certmanager_svc_account_key" {
  value     = google_service_account_key.certmanager_dns_editor_key.private_key
  sensitive = true
}

output "valuesyaml" {
  value = templatefile(
    "${path.module}/templates/_prow_values.yaml",
    {
      gke_region                                       = var.gke_region,
      gke_project                                      = var.gke_project,
      gke_authenticator_groups_security_group          = var.gke_authenticator_groups_security_group,
      prow_terraform_gcloud_svc_account_key            = base64encode(google_service_account_key.prow_terraform.private_key),
      prow_terraform_aws_svc_account_access_key_id     = aws_iam_access_key.prow_terraform.id,
      prow_terraform_aws_svc_account_secret_access_key = aws_iam_access_key.prow_terraform.secret,
      prow_base_url                                    = local.prow_base_url,
      prow_bucket_svc_account_key                      = base64encode(google_service_account_key.prow_bucket_editor_key.private_key),
      prow_webhook_hmac_token                          = random_string.hmac_token.result,
      prow_cookie_secret                               = data.credstash_secret.prow_cookie_secret.value,
      prow_artefacts_bucket_name                       = google_storage_bucket.prow_bucket.name,
      prow_github_bot_token                            = data.credstash_secret.github_bot_token.value,
      prow_github_bot_ssh_key                          = data.credstash_secret.github_bot_ssh_key.value,
      prow_github_oauth_client_id                      = data.credstash_secret.prow_github_oauth_client_id.value,
      prow_github_oauth_client_secret                  = data.credstash_secret.prow_github_oauth_client_secret.value,
      prow_github_oauth_cookie_secret                  = data.credstash_secret.prow_github_oauth_cookie_secret.value,
      prow_redirect_url                                = "${local.prow_base_url}/github-login/redirect",
      prow_final_redirect_url                          = "${local.prow_base_url}/pr",
      certmanager_svc_account_key                      = base64encode(google_service_account_key.certmanager_dns_editor_key.private_key)
    }
  )
  sensitive = true
}