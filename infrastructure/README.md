# Infrastructure

## Summary

This folder contains all the infra needed to stand up a k8s cluster for prow

## Makefile

- init: Initialise the infra
- plan: Execute a plan for the infrastructure
- apply:  Apply the infrastructure 
- get-cluster-credentials: Get credentials (kubeconfig) to access the k8s cluster
- get-google-service-account: Get the service account used to interact with Google Cloud

## GCloud Project setup

The project in GCloud is setup manually.

Manual steps:
- the bucket for terraform
- the service account for terraform. The key of the service account must be in credstash AWS.

## Google DNS

Terraform creates a subdomain - we manually link it to the root ouzi.io domain by creating an NS record.

## Google APIs

Manually enable the:
- Google Cloud DNS API,
- Kubernetes API,
- IAM API,
- Cloud Resource Manager API 
  
## Encrypting sensitive text

```
$ echo -n my-secret-password | gcloud kms encrypt \
> --project var.gcloud_project \
> --location var.gcloud_region \
> --keyring test-infra \
> --key build \
> --plaintext-file - \
> --ciphertext-file - \
> | base64
```