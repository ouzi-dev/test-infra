# test-infra

This repo contains all the configuration needed to run Prow](https://github.com/kubernetes/test-infra/tree/master/prow) for the ouzi-dev GitHub org. 

## Short summary

- Enforce branch protection in all branches of all of our repos with some exclusions ( you can see them in the [config.yaml](prow/config.yaml) )
- Automatically merge all PRs if they have been aproved by the OWNERS of the repo and all checks have passed
- Trigger a config reload of Prow automatically if the PR has changed them
- Ability to hold off a PR from being merged if an issue outside of checks is detected
- Automatically assign a reviewer
- Allow the ability re-run tests 
- Support WIP PRs by blocking merging if the PR is in draft mode or title starts with WIP:
- Supports PR approvals by /approve 
- Supports /lgtm with automatic approval 

To see the current running jobs, visit [Deck](https://prow.test-infra.ouzi.io/)

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

## Test Prow Jobs

* First you need to get [mkpj](https://github.com/kubernetes/test-infra/tree/master/prow/cmd/mkpj)
* Write your new job and add it to [config/jobs](config/jobs)
* Generate a github token an create a file with your new token (you can use the token used by Prow as well)
* Generate the manifest for you job with a command like this (from the root path of the test-infra repo):
```
$ mkpj -github-token-path ./token -config-path prow/config.yaml -job-config-path ./config/jobs/my_org/my_repo/my_repo_jobs.yaml -job job_name > prow_job_manifest.yaml
```
* Now you just need to apply that manifest in the Prow namespace:
```
$ kubectl apply -f prow_job_manifest.yaml -n prow
prowjob.prow.k8s.io/377d3c1c-f0c1-11e9-959c-acde48001122 created
```
* You can check the logs for the job with:
```
kubectl logs -n prow-test-pods -f 377d3c1c-f0c1-11e9-959c-acde48001122 -c test
```
