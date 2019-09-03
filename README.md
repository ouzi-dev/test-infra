# test-infra

This repo contains all the configuration needed to run Prow for the ouzi-dev GitHub org. 

## OWNERS

The owners file defines who are the approvers and reviewers for ouzi-dev repos. For more info, see the OWNERS docs at https://go.k8s.io/owners

## Makefile

The Makefile provides easy to run targets for creating the infrastructure and setting up Prow

## Prow

The Prow folder contains all the resources necessary to get Prow operational in a k8s cluster. We make some assumptions, that the cluster supports fully RBAC and that some secrets have been pre-seeded and also install various componenets that are not Prow specific necessarily.

See [prow/README.md](prow/README.md) for more details

## Infrastructure

The infrastructure folder contains all the infrastucture we need to stand up in order to install and get Prow operations. 

See [infrastructure/README.md](infrastructure/README.md) for more details
