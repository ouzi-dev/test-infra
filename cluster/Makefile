DRY_RUN ?= false

AWS_ACCOUNT_ID := 257496065652
CREDSTASH_AWS_REGION:= eu-west-1

# source the terraform vars as env vars 
include ../infrastructure/terraform.tfvars

CERTMANAGER_CHART_VERSION := v0.11.0
EXTERNALDNS_CHART_VERSION := 2.10.0
NGINX_INGRESS_CHART_VERSION := 1.24.4
PROW_CHART_VERSION := v0.4.10

setup: 
	helm plugin install https://github.com/databus23/helm-diff --version v3.0.0-rc.6 

.PHONY: aws-identity-check
aws-identity-check:
	@if [ `aws sts get-caller-identity | jq -r .Account` != $(AWS_ACCOUNT_ID) ]; then echo "Pointing to the wrong AWS account..You may not proceed"; exit 1; fi;

.PHONY: init
init: 
	helm repo add stable https://kubernetes-charts.storage.googleapis.com/
	helm repo add jetstack https://charts.jetstack.io
	helm repo update

.PHONY: deploy
deploy: render install-bootstrap install-credstash-controller install-cert-manager install-oauth-proxy install-external-dns install-nginx-ingress install-prow install-build-secrets

.PHONY: render
render: render-bootstrap render-credstash-controller render-cert-manager render-oauth-proxy render-external-dns render-nginx-ingress render-prow render-build-secrets

.PHONY: render-bootstrap
render-bootstrap: 
	@$(MAKE) FOLDER=00-storage render-gotpl-manifests
	@$(MAKE) FOLDER=01-rbac render-gotpl-manifests
	@$(MAKE) FOLDER=02-pod-disruption-budget render-gotpl-manifests

.PHONY: render-credstash-controller
render-credstash-controller:
	@$(MAKE) FOLDER=03-credstash-controller render-gotpl-manifests

.PHONY: render-cert-manager
render-cert-manager:
	@$(MAKE) FOLDER=04-cert-manager render-gotpl-manifests
	@$(MAKE) FOLDER=04-cert-manager render-helm-manifests

.PHONY: render-oauth-proxy
render-oauth-proxy:
	@$(MAKE) FOLDER=05-oauth-proxy render-gotpl-manifests

.PHONY: render-external-dns
render-external-dns:
	@$(MAKE) FOLDER=06-external-dns render-gotpl-manifests
	@$(MAKE) FOLDER=06-external-dns render-helm-manifests

.PHONY: render-nginx-ingress
render-nginx-ingress:
	@$(MAKE) FOLDER=07-nginx-ingress render-gotpl-manifests
	@$(MAKE) FOLDER=07-nginx-ingress render-helm-manifests

.PHONY: render-prow
render-prow:
	@$(MAKE) FOLDER=08-prow render-gotpl-manifests
	@$(MAKE) FOLDER=08-prow render-helm-manifests

.PHONY: render-build-secrets
render-build-secrets:
	@$(MAKE) FOLDER=09-build-secrets render-gotpl-manifests

.PHONY: render-gotpl-manifests
render-gotpl-manifests:
	@echo Rendering gotpl values in $(FOLDER)
	@gotpl \
		$(FOLDER)/manifests_values.yaml.tpl \
		--values values.yaml \
		--set gcloud.project=${gcloud_project} \
		--strict \
		> $(FOLDER)/manifests_values.yaml
	@touch $(FOLDER)/manifests_values.yaml

.PHONY: render-helm-manifests
render-helm-manifests:
	@echo Rendering helm values in $(FOLDER)
	@gotpl \
		$(FOLDER)/helm_values.yaml.tpl \
		--values values.yaml \
		--set gcloud.project=${gcloud_project} \
		--strict \
		> $(FOLDER)/helm_values.yaml
	@touch $(FOLDER)/helm_values.yaml

.PHONY: install-bootstrap
install-bootstrap:
	@$(MAKE) FOLDER=00-storage/manifests/pre install-manifests-gotpl
	@$(MAKE) FOLDER=01-rbac/manifests/pre install-manifests-gotpl
	@$(MAKE) FOLDER=02-pod-disruption-budget/manifests/pre install-manifests-gotpl

.PHONY: install-credstash-controller
install-credstash-controller: aws-identity-check
	$(eval CREDSTASH_AWS_ACCESS_KEY_ID=$(shell credstash --region $(CREDSTASH_AWS_REGION) get prow-aws-access-key-id ))
	$(eval CREDSTASH_AWS_SECRET_ACCESS_KEY=$(shell credstash --region $(CREDSTASH_AWS_REGION) get prow-aws-secret-access-key ))
	@$(MAKE) \
		FOLDER=03-credstash-controller/manifests/pre \
		EXTRA_ARGS='--set aws.access_key_id="$(CREDSTASH_AWS_ACCESS_KEY_ID)" --set aws.secret_access_key="$(CREDSTASH_AWS_SECRET_ACCESS_KEY)"' \
		install-manifests-gotpl

.PHONY: install-cert-manager
install-cert-manager:
	@$(MAKE) FOLDER=04-cert-manager/manifests/crds KUBECTL_ARGS=--validate=false install-manifests-gotpl
	@$(MAKE) FOLDER=04-cert-manager/manifests/pre install-manifests-gotpl
	@$(MAKE) \
		CHART=jetstack/cert-manager \
		NAME=raisin \
		VERSION=$(CERTMANAGER_CHART_VERSION) \
		NAMESPACE=cert-manager \
		FOLDER=04-cert-manager \
		install-helm-chart
	@$(MAKE) FOLDER=04-cert-manager/manifests/post install-manifests-gotpl

.PHONY: install-oauth-proxy
install-oauth-proxy:
	@$(MAKE) FOLDER=05-oauth-proxy/manifests/pre install-manifests-gotpl

.PHONY: install-external-dns
install-external-dns:
	@$(MAKE) FOLDER=06-external-dns/manifests/pre install-manifests-gotpl
	@$(MAKE) \
		CHART=stable/external-dns \
		NAME=onion \
		VERSION=$(EXTERNALDNS_CHART_VERSION) \
		NAMESPACE=external-dns \
		FOLDER=06-external-dns \
		install-helm-chart

.PHONY: install-nginx-ingress
install-nginx-ingress:
	@$(MAKE) FOLDER=07-nginx-ingress/manifests/pre install-manifests-gotpl
	@$(MAKE) \
		CHART=stable/nginx-ingress \
		NAME=peach \
		VERSION=$(NGINX_INGRESS_CHART_VERSION) \
		NAMESPACE=nginx-ingress \
		FOLDER=07-nginx-ingress \
		install-helm-chart

.PHONY: install-prow
install-prow:
	@$(MAKE) FOLDER=08-prow/manifests/pre install-manifests-gotpl
	@$(MAKE) \
		CHART=https://github.com/ouzi-dev/prow-helm-chart/releases/download/$(PROW_CHART_VERSION)/prow-$(PROW_CHART_VERSION).tgz \
		NAME=raspberry \
		NAMESPACE=prow \
		FOLDER=08-prow \
		install-helm-chart-tar

.PHONY: install-build-secrets
install-build-secrets:
	@$(MAKE) FOLDER=09-build-secrets/manifests/pre install-manifests-gotpl

.PHONY: install-helm-chart
install-helm-chart:
ifeq ($(DRY_RUN),true)
	@echo **Upgrading \(Dry Run\) helm chart $(CHART) $(NAME) $(VERSION) from $(FOLDER) in $(NAMESPACE)
	@helm diff upgrade \
		$(NAME) \
		$(CHART) \
		--version $(VERSION) \
		--no-hooks \
		--namespace $(NAMESPACE) \
		--set gcloud.project=${gcloud_project} \
		--values $(FOLDER)/helm_values.yaml
else
	@echo **Upgrading helm chart $(CHART) $(NAME) $(VERSION) from $(FOLDER) in $(NAMESPACE)
	@helm upgrade \
		$(NAME) \
		$(CHART) \
		--version $(VERSION) \
		--install \
		--wait \
		--namespace $(NAMESPACE) \
		--set gcloud.project=${gcloud_project} \
		--values $(FOLDER)/helm_values.yaml
endif

.PHONY: install-helm-chart-tar
install-helm-chart-tar:
ifeq ($(DRY_RUN),true)
	@echo **Upgrading \(Dry Run\) helm chart $(CHART) $(NAME) $(VERSION) from $(FOLDER) in $(NAMESPACE)
	@helm diff upgrade \
		$(NAME) \
		$(CHART) \
		--no-hooks \
		--namespace $(NAMESPACE) \
		--set gcloud.project=${gcloud_project} \
		--values $(FOLDER)/helm_values.yaml 		
else
	@echo **Upgrading helm chart $(CHART) $(NAME) $(VERSION) from $(FOLDER) in $(NAMESPACE)
	@helm upgrade \
		$(NAME) \
		$(CHART) \
		--install \
		--wait \
		--namespace $(NAMESPACE) \
		--set gcloud.project=${gcloud_project} \
		--values $(FOLDER)/helm_values.yaml 	
endif

.PHONY: install-manifests-gotpl
install-manifests-gotpl:
ifeq ($(DRY_RUN),true)
	@echo **Applying $(FOLDER) \(Dry Run\)
	@gotpl \
		$(FOLDER) \
		--values $(FOLDER)/../../manifests_values.yaml \
		--set gcloud.project=${gcloud_project} \
		--strict \
		$(EXTRA_ARGS) \
		| kubectl apply $(KUBECTL_ARGS) --dry-run -f -	
else
	@echo **Applying $(FOLDER)
	@gotpl \
		$(FOLDER) \
		--set gcloud.project=${gcloud_project} \
		--values $(FOLDER)/../../manifests_values.yaml \
		--strict \
		$(EXTRA_ARGS) \
		| kubectl apply $(KUBECTL_ARGS) -f -
endif

.PHONY: get-cluster-credentials
get-cluster-credentials:
	$(MAKE) -C ../infrastructure get-cluster-credentials