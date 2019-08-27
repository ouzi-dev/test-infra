# test-infra


## Infrastructure

### Google Credential setup 

Generate SDK creds via `gcloud auth application-default login` such that terraform can interract with GCloud on your behalf.

### Getting a kubeconfig

```
gcloud container clusters get-credentials CLUSTER_NAME --region=REGION
```