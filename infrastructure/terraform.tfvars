gcloud_region  = "europe-west4"
gcloud_project = "ouzidev-testinfra-252513"
gke_name       = "spacepro-prowiverse"
aws_region     = "eu-west-1"

base_domain    = "test-infra.ouzi.io"

gke_kubernetes_version = "1.14.8-gke.12"
gke_min_nodes = 1
gke_authenticator_groups_security_group = "gke-security-groups@ouzi.dev"
prow_artefact_bucket_location           = "eu"