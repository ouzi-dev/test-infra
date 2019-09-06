# Infrastructure

## Summary

This folder contains all the infra needed to stand up a k8s cluster for prow

## Makefile

- init: Initialise the infra
- plan: Execute a plan for the infrastructure
- apply:  Apply the infrastructure 
- get-cluster-credentials: Get credentials (kubeconfig) to access the k8s cluster
- get-google-service-account: Get the service account used to interact with Google Cloud

## Bootstrap

Bootstrap contains any infra we need to get the project up and running. The project and bucket was created manually and then imported. Then we used terraform to enable the apis needed and create the service account we will use to interact with Google cloud.