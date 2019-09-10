# Infrastructure

## Summary

This folder contains all the infra needed to stand up a k8s cluster for prow

## Makefile

- init: Initialise the infra
- plan: Execute a plan for the infrastructure
- apply:  Apply the infrastructure 
- get-cluster-credentials: Get credentials (kubeconfig) to access the k8s cluster
- get-google-service-account: Get the service account used to interact with Google Cloud

## Project setup

The project in GCloud has been setup manually, the bucket for terraform created manually and the service account for terraform also manually. The key of hte service account is in credstash AWS.