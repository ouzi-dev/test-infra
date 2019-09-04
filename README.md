# test-infra

This repo contains all the configuration needed to run Prow for the ouzi-dev GitHub org. 

## OWNERS

The owners file defines who are the approvers and reviewers for ouzi-dev repos. For more info, see the OWNERS docs at https://go.k8s.io/owners

## Makefile

The Makefile provides easy to run targets for creating the infrastructure and setting up Prow. 
We list below the most useful targets

- infra-setup: Setups all components needed to run the infrastracture 
- infra-plan: Executes terraform plan on the infrastructure
- infra-apply: Executes terraform apply on the infrastructure
- install: Install all components needed in the cluster including Prow
- uninstall: Uninstalls all components from the cluster including Prow
- get-cluster-credentials: Returns a kubeconfg with the required credentials to connect to the cluster. 

## Prow

The Prow folder contains all the resources necessary to get Prow operational in a k8s cluster. We make some assumptions, that the cluster supports fully RBAC and that some secrets have been pre-seeded and also install various componenets that are not Prow specific necessarily.

See [prow/README.md](prow/README.md) for more details

## Infrastructure

The infrastructure folder contains all the infrastucture we need to stand up in order to install and get Prow operations. 

See [infrastructure/README.md](infrastructure/README.md) for more details
