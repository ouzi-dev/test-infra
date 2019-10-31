.PHONY: cluster-init cluster-install cluster-uninstall prow-install prow-update prow-update-plugins prow-update-config prow-update-labels prow-uninstall install uninstall get-cluster-credentials

# Get current directory
DIR := ${CURDIR}
BIN_DIR := $(DIR)/.bin/

# GoTPL version and dowload locations
# https://github.com/belitre/gotpl/releases
GOTPL_VERSION := v0.7
GOTPL_DOWNLOAD_DARWIN_URL := https://github.com/belitre/gotpl/releases/download/v0.7/gotpl-$(GOTPL_VERSION)-darwin-amd64.tar.gz
GOTPL := $(DIR)/.bin/darwin-amd64/gotpl

# Terraform values
TERRAFORM_VALUES_FILEPATH := .terraform-values.yaml

CLUSTER_MANIFESTS_PATH = cluster
CLUSTER_MANIFESTS_RBAC_PATH = $(CLUSTER_MANIFESTS_PATH)/00-rbac
CLUSTER_MANIFESTS_HELM_PATH = $(CLUSTER_MANIFESTS_PATH)/01-helm
CLUSTER_MANIFESTS_EXTERNALDNS_PATH = $(CLUSTER_MANIFESTS_PATH)/02-external-dns
CLUSTER_MANIFESTS_NGINXINGRESS_PATH = $(CLUSTER_MANIFESTS_PATH)/03-nginx-ingress
CLUSTER_MANIFESTS_CERTMANAGER_PATH = $(CLUSTER_MANIFESTS_PATH)/04-cert-manager
CLUSTER_MANIFESTS_OAUTH_PATH = $(CLUSTER_MANIFESTS_PATH)/05-oauth
CLUSTER_MANIFESTS_PDBS_PATH = $(CLUSTER_MANIFESTS_PATH)/06-pdbs

PROW_MANIFESTS_PATH = manifests

BASE_DOMAIN := test-infra.ouzi.io

test-bleh: init-cluster
	@$(GOTPL) $(CLUSTER_MANIFESTS_NGINXINGRESS_PATH)/helm -f $(TERRAFORM_VALUES_FILEPATH) | helm upgrade --install peach stable/nginx-ingress --version 1.24.3 --namespace nginx --debug --dry-run -f -


setup:
	@mkdir -p $(BIN_DIR)
	@curl -SL $(GOTPL_DOWNLOAD_DARWIN_URL) | tar -xf - -C $(BIN_DIR)
	@chmod +x $(GOTPL)

init-cluster:  get-values get-cluster-credentials
	@$(GOTPL) $(CLUSTER_MANIFESTS_HELM_PATH)/manifests -f $(TERRAFORM_VALUES_FILEPATH) | kubectl apply -f -
	@helm init --service-account tiller --history-max 200 --upgrade --wait

deploy-cluster: init-cluster
	@helm repo update
	@$(GOTPL) $(CLUSTER_MANIFESTS_RBAC_PATH)/manifests -f $(TERRAFORM_VALUES_FILEPATH) | kubectl apply -f -
	@$(GOTPL) $(CLUSTER_MANIFESTS_EXTERNALDNS_PATH)/helm -f $(TERRAFORM_VALUES_FILEPATH) | helm upgrade --install onion stable/external-dns --version 2.9.0 --namespace external-dns --wait -f -
	@helm repo add jetstack https://charts.jetstack.io
	@$(GOTPL) $(CLUSTER_MANIFESTS_CERTMANAGER_PATH)/helm -f $(TERRAFORM_VALUES_FILEPATH) | helm upgrade --install raisin jetstack/cert-manager --version v0.11.0 --namespace cert-manager --wait -f -
	@$(GOTPL) $(CLUSTER_MANIFESTS_CERTMANAGER_PATH)/manifests -f $(TERRAFORM_VALUES_FILEPATH) | kubectl apply --validate=false -f -
	@$(GOTPL) $(CLUSTER_MANIFESTS_NGINXINGRESS_PATH)/helm -f $(TERRAFORM_VALUES_FILEPATH) | helm upgrade --install peach stable/nginx-ingress --version 1.24.3 --namespace nginx --wait -f -
	@$(GOTPL) $(CLUSTER_MANIFESTS_OAUTH_PATH)/manifests -f $(TERRAFORM_VALUES_FILEPATH) -s base_domain=$(BASE_DOMAIN) | kubectl apply -f -
	@$(GOTPL) $(CLUSTER_MANIFESTS_PDBS_PATH)/manifests -f $(TERRAFORM_VALUES_FILEPATH) | kubectl apply -f -

template-prow-config: get-values
	$(GOTPL) templates/plugins.yaml.template -f $(TERRAFORM_VALUES_FILEPATH) > plugins.yaml
	$(GOTPL) templates/labels.yaml.template -f $(TERRAFORM_VALUES_FILEPATH) > labels.yaml 
	$(GOTPL) templates/config.yaml.template -f $(TERRAFORM_VALUES_FILEPATH) > config.yaml

deploy-prow: template-prow-config get-values
	@$(GOTPL) $(PROW_MANIFESTS_PATH) -f $(TERRAFORM_VALUES_FILEPATH) | kubectl apply -f - 
	@kubectl create configmap plugins --from-file=plugins.yaml=plugins.yaml --dry-run -o yaml -n prow | kubectl apply -f - 
	@kubectl create configmap label-config --from-file=labels.yaml=labels.yaml --dry-run -o yaml -n prow | kubectl apply -f -
	@kubectl create configmap config --from-file=config.yaml=config.yaml --dry-run -o yaml -n prow | kubectl apply -f - 

deploy: deploy-cluster deploy-prow

test-job: template-prow-config get-values
	$(MAKE) -C ../infrastructure output | jq -r .prow_github_bot_token.value > .github_token
	@go run k8s.io/test-infra/prow/cmd/mkpj --job=$(PROW_JOB) --config-path=config.yaml --job-config-path=../config/jobs/ouzi-dev/test-infra/jobs.yaml -github-token-path=.github_token | kubectl apply -n prow -f -

get-cluster-credentials:
	@$(MAKE) -C ../infrastructure get-cluster-credentials

get-values:
	@$(MAKE) -C ../infrastructure output | jq -r .valuesyaml.value | base64 -D > $(TERRAFORM_VALUES_FILEPATH)