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


setup:
	@mkdir -p $(BIN_DIR)
	@curl -SL $(GOTPL_DOWNLOAD_DARWIN_URL) | tar -xf - -C $(BIN_DIR)
	@chmod +x $(GOTPL)

init-cluster:  get-values get-cluster-credentials
	@$(GOTPL) $(CLUSTER_MANIFESTS_HELM_PATH)/manifests -f $(TERRAFORM_VALUES_FILEPATH) | kubectl apply -f -
	@helm init --service-account tiller --history-max 200 --upgrade --wait

deploy-cluster: init-cluster
	helm repo update
	$(GOTPL) $(CLUSTER_MANIFESTS_RBAC_PATH)/manifests -f $(TERRAFORM_VALUES_FILEPATH) | kubectl apply -f -
	@$(GOTPL) $(CLUSTER_MANIFESTS_EXTERNALDNS_PATH)/helm -f $(TERRAFORM_VALUES_FILEPATH) | helm upgrade --install onion stable/external-dns --namespace external-dns --wait -f -
	@$(GOTPL) $(CLUSTER_MANIFESTS_CERTMANAGER_PATH)/manifests -f $(TERRAFORM_VALUES_FILEPATH) | kubectl apply -f -
	helm repo add jetstack https://charts.jetstack.io
	@$(GOTPL) $(CLUSTER_MANIFESTS_CERTMANAGER_PATH)/helm -f $(TERRAFORM_VALUES_FILEPATH) | helm upgrade --install raisin jetstack/cert-manager --namespace cert-manager --wait -f -
	@$(GOTPL) $(CLUSTER_MANIFESTS_NGINXINGRESS_PATH)/helm -f $(TERRAFORM_VALUES_FILEPATH) | helm upgrade --install peach stable/nginx-ingress --namespace nginx --wait -f -
	@$(GOTPL) $(CLUSTER_MANIFESTS_OAUTH_PATH)/manifests -f $(TERRAFORM_VALUES_FILEPATH) | kubectl apply -f -
	@$(GOTPL) $(CLUSTER_MANIFESTS_PDBS_PATH)/manifests -f $(TERRAFORM_VALUES_FILEPATH) | kubectl apply -f -
	helm upgrade --install potato stable/prometheus-operator --namespace monitoring --wait

deploy-prow: get-values
	$(GOTPL) $(PROW_MANIFESTS_PATH) -f $(TERRAFORM_VALUES_FILEPATH) | kubectl apply -f - 
	$(GOTPL) plugins.yaml -f $(TERRAFORM_VALUES_FILEPATH) > plugins.yaml.rendered && kubectl create configmap plugins --from-file=plugins.yaml=plugins.yaml.rendered --dry-run -o yaml -n prow | kubectl apply -f - && rm plugins.yaml.rendered
	$(GOTPL) labels.yaml -f $(TERRAFORM_VALUES_FILEPATH) > labels.yaml.rendered && kubectl create configmap label-config --from-file=labels.yaml=labels.yaml.rendered --dry-run -o yaml -n prow | kubectl apply -f - && rm labels.yaml.rendered
	$(GOTPL) config.yaml -f $(TERRAFORM_VALUES_FILEPATH) > config.yaml.rendered && kubectl create configmap config --from-file=config.yaml=config.yaml.rendered --dry-run -o yaml -n prow | kubectl apply -f - && rm config.yaml.rendered

deploy: cluster-deploy prow-deploy

get-cluster-credentials:
	@$(MAKE) -C ../infrastructure get-cluster-credentials

get-values:
	@$(MAKE) -C ../infrastructure output | jq -r .valuesyaml.value | base64 -D > $(TERRAFORM_VALUES_FILEPATH)