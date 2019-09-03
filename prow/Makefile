.PHONY: cluster-init cluster-install cluster-uninstall prow-install prow-update prow-update-plugins prow-update-config prow-update-labels prow-uninstall install uninstall get-cluster-credentials

ifndef ENV
$(error ENV is not set)
endif

BOOTSTRAP_MANIFESTS_PATH = cluster-bootstrap

cluster-init: get-cluster-credentials
	kubectl apply -f $(BOOTSTRAP_MANIFESTS_PATH)/helm/00-init.yaml
	helm init --service-account tiller --history-max 200 --upgrade --wait

cluster-install: cluster-init
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

cluster-uninstall: get-cluster-credentials
	helm delete peach --purge
	helm delete onion --purge
	helm delete potato --purge
	#kubectl delete -f $(BOOTSTRAP_MANIFESTS_PATH)/helm/helm-init.yaml

prow-install: get-cluster-credentials
	kubectl apply -f $(BOOTSTRAP_MANIFESTS_PATH)/prow/manifests

prow-update: prow-update-plugins prow-update-config prow-update-labels

prow-update-plugins: get-cluster-credentials
	kubectl create configmap plugins --from-file=plugins.yaml=$(BOOTSTRAP_MANIFESTS_PATH)/prow/plugins.yaml --dry-run -o yaml -n prow | kubectl replace configmap plugins -n prow -f -

prow-update-config: get-cluster-credentials
	kubectl create configmap config --from-file=config.yaml=$(BOOTSTRAP_MANIFESTS_PATH)/prow/config.yaml --dry-run -o yaml -n prow | kubectl replace configmap config -n prow -f -

prow-update-labels: get-cluster-credentials
	kubectl create configmap label-config --from-file=lebels.yaml=$(BOOTSTRAP_MANIFESTS_PATH)/prow/labels.yaml --dry-run -o yaml -n prow | kubectl replace configmap label-config -n prow -f -

prow-uninstall: get-cluster-credentials
	kubectl delete -f $(BOOTSTRAP_MANIFESTS_PATH)/prow/manifests

install: cluster-install prow-install

uninstall: cluster-uninstall prow-uninstall

get-cluster-credentials:
	$(MAKE) -C ../infrastructure get-cluster-credentials
