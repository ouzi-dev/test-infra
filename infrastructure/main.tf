## Backend
terraform {
  backend "gcs" {}
}

## Providers
provider "google" {
  region      = var.gcloud_region
  project     = var.gcloud_project
  version     = "3.8.0"
  credentials = file(var.google_credentials_file_path)
}

provider "google-beta" {
  region      = var.gcloud_region
  project     = var.gcloud_project
  version     = "3.8.0"
  credentials = file(var.google_credentials_file_path)
}

provider "aws" {
  region  = var.aws_region
  version = "2.24"
}

provider "credstash" {
  region  = "eu-west-1"
  version = "0.4"
}

provider "kubernetes" {
  host                   = module.gke-cluster.cluster_endpoint
  cluster_ca_certificate = base64decode(module.gke-cluster.cluster_ca_certificate)
  token                  = data.google_client_config.current.access_token
  load_config_file       = false
  version                = "1.9"
}

provider "random" {
  version = "2.2"
}

module "prow-cluster" {
  source = "github.com/ouzi-dev/prow-gke-terraform?ref=v0.9.0"
  # source = "../../prow-gke-terraform"
  gcloud_region              = var.gcloud_region
  gcloud_project             = var.gcloud_project
  gke_name                   = var.gke_name
  gke_kubernetes_version     = var.gke_kubernetes_version
  gke_min_nodes              = var.gke_min_nodes
  
  base_domain = var.base_domain

  prow_artefact_bucket_location = var.prow_artefact_bucket_location

  gke_authenticator_groups_security_group = var.gke_authenticator_groups_security_group
}

### AWS Service Account for credstash secret fetching 
resource "aws_iam_user" "prow_credstash_reader" {
  name = "prow_credstash_reader"
  tags = {
    "SYSTEM" : "prow"
  }
}

### AWS Service Account access key for credstash secret fetching 
resource "aws_iam_access_key" "prow_credstash_reader" {
  user = aws_iam_user.prow_credstash_reader.name
}

### AWS Service Account IAM policy for credstash secret fetching 
resource "aws_iam_user_policy" "prow_credstash_reader" {
  name = "prow_credstash_reader"
  user = aws_iam_user.prow_credstash_reader.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "kms:Decrypt"
            ],
            "Effect": "Allow",
            "Resource": "arn:aws:kms:eu-west-1:257496065652:key/2bfa85d6-dc94-4866-95b1-540de40ab41c"
        },
        {
            "Action": [
                "dynamodb:GetItem",
                "dynamodb:Query",
                "dynamodb:Scan"
            ],
            "Effect": "Allow",
            "Resource": "arn:aws:dynamodb:eu-west-1:257496065652:table/*"
        }
    ]
}
EOF
}