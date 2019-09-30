# test-infra

This repo contains all the configuration needed to run Prow for the ouzi-dev GitHub org. 

Short summary:
- **Enforces branch protection in all branches of all of our repos with some exclusions ( you can see them in the [confgi.yaml](prow/config.yaml) )**
- **Automatically merges all PRs if they have been aproved by the OWNERS of the repo and all checks have passed**
- **Any PRs to this repo also trigger a config reload of Prow automatically**
- **Ability to hold off a PR from being merged if an issue outside of checks is detected**
- **Automatically assign a reviewer**
- **Allow the ability re-run tests** 
- **Support WIP PRs by blocking merging if the PR is in draft mode or title starts with WIP:**
- **Supports PR approvals by /approve** 
- **Supports /lgtm with automatic approval** 

## OWNERS

The [owners](OWNERS) file defines who are the approvers and reviewers for ouzi-dev repos. For more info, see the OWNERS docs at https://go.k8s.io/owners

## Makefile

The [Makefile](Makefile) provides easy to run targets for creating the infrastructure and setting up Prow. 
We list below the most useful targets

- **infra-setup**: Setups all components needed to run the infrastracture 
- **infra-plan**: Executes terraform plan on the infrastructure
- **infra-apply**: Executes terraform apply on the infrastructure
- **deploy**: Bring up a cluster, install all components needed in the cluster including Prow and set everything up
- **get-cluster-credentials**: Returns a kubeconfg with the required credentials to connect to the cluster. 

## Prow

The Prow folder contains all the resources necessary to get [Prow](https://github.com/kubernetes/test-infra/tree/master/prow) operational in a k8s cluster. We make some assumptions, that the cluster supports fully RBAC and that some secrets have been pre-seeded and also install various componenets that are not Prow specific necessarily. Please note that this is not meant to be reusable by others, this is just how we manage Prow.

See [prow/README.md](prow/README.md) for more details

## Infrastructure

The infrastructure folder contains all the infrastucture we need to stand up in order to install and get Prow operations. 

See [infrastructure/README.md](infrastructure/README.md) for more details
