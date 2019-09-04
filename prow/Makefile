.PHONY: cluster-init cluster-install cluster-uninstall prow-install prow-update prow-update-plugins prow-update-config prow-update-labels prow-uninstall install uninstall get-cluster-credentials

ifndef ENV
$(error ENV is not set)
endif

BOOTSTRAP_MANIFESTS_PATH = cluster-bootstrap

init-cluster: 
	kubectl apply -f $(BOOTSTRAP_MANIFESTS_PATH)/helm/00-init.yaml
	helm init --service-account tiller --history-max 200 --upgrade --wait

deploy-cluster: init-cluster
	helm repo update
	kubectl apply -f $(BOOTSTRAP_MANIFESTS_PATH)/rbac/
	kubectl apply -f $(BOOTSTRAP_MANIFESTS_PATH)/pdbs/
	helm upgrade --install onion stable/external-dns -f $(BOOTSTRAP_MANIFESTS_PATH)/external-dns/helm.yaml --namespace external-dns --wait
	kubectl apply -f $(BOOTSTRAP_MANIFESTS_PATH)/cert-manager/crds.yaml
	helm repo add jetstack https://charts.jetstack.io
	helm upgrade --install raisin jetstack/cert-manager -f $(BOOTSTRAP_MANIFESTS_PATH)/cert-manager/helm.yaml --namespace cert-manager   --wait
	kubectl apply -f $(BOOTSTRAP_MANIFESTS_PATH)/cert-manager/cluster-issuer-letsencrypt.yaml
	helm upgrade --install peach stable/nginx-ingress -f $(BOOTSTRAP_MANIFESTS_PATH)/nginx-ingress/helm.yaml --namespace nginx  --wait
	kubectl apply -f $(BOOTSTRAP_MANIFESTS_PATH)/oauth/resources.yaml
#	helm upgrade --install potato stable/prometheus-operator --namespace monitoring --wait

deploy-prow: 
	kubectl apply -f manifests
	kubectl create configmap plugins --from-file=plugins.yaml=plugins.yaml --dry-run -o yaml -n prow | kubectl replace configmap plugins -n prow -f -
	kubectl create configmap config --from-file=config.yaml=config.yaml --dry-run -o yaml -n prow | kubectl replace configmap config -n prow -f -
	kubectl create configmap label-config --from-file=lebels.yaml=labels.yaml --dry-run -o yaml -n prow | kubectl replace configmap label-config -n prow -f -

deploy-prow-dry-run: 
	kubectl apply -f manifests	--dry-run
	kubectl create configmap plugins --from-file=plugins.yaml=plugins.yaml --dry-run -o yaml -n prow 
	kubectl create configmap config --from-file=config.yaml=config.yaml --dry-run -o yaml -n prow 
	kubectl create configmap label-config --from-file=lebels.yaml=labels.yaml --dry-run -o yaml -n prow

deploy: cluster-deploy prow-deploy

get-cluster-credentials:
	$(MAKE) -C ../infrastructure get-cluster-credentials
