.PHONY: clean init plan apply destroy format validate bootstrap-init bootstrap-plan bootstrap-apply bootstrap-destroy get-cluster-credentials

ifndef ENV
$(error ENV is not set)
endif

cluster-init: get-cluster-credentials
	kubectl apply -f env/$(ENV)/helm/helm-init.yaml
	helm init --service-account tiller --history-max 200 --upgrade --wait

cluster-install: cluster-init
	helm repo update
	kubectl apply -f env/$(ENV)/rbac/
	kubectl apply -f env/$(ENV)/pdbs/
	kubectl apply -f env/$(ENV)/helm/helm-init.yaml
	helm upgrade --install onion stable/external-dns -f env/$(ENV)/external-dns/helm.yaml --namespace external-dns --wait
	kubectl apply -f env/$(ENV)/cert-manager/crds.yaml
	helm repo add jetstack https://charts.jetstack.io
	helm upgrade --install raisin jetstack/cert-manager -f env/$(ENV)/cert-manager/helm.yaml --namespace cert-manager   --wait
	kubectl apply -f env/$(ENV)/cert-manager/cluster-issuer-letsencrypt.yaml
	helm upgrade --install peach stable/nginx-ingress -f env/$(ENV)/nginx-ingress/helm.yaml --namespace nginx  --wait
	kubectl apply -f env/$(ENV)/oauth/resources.yaml
#	helm upgrade --install potato stable/prometheus-operator --namespace monitoring --wait

cluster-uninstall: get-cluster-credentials
	helm delete peach --purge
	helm delete onion --purge
	helm delete potato --purge
	#kubectl delete -f env/$(ENV)/helm/helm-init.yaml

prow-install: get-cluster-credentials
	kubectl apply -f env/$(ENV)/prow/manifests

prow-update: prow-update-plugins prow-update-config prow-update-labels

prow-update-plugins: get-cluster-credentials
	kubectl create configmap plugins --from-file=plugins.yaml=env/$(ENV)/prow/plugins.yaml --dry-run -o yaml -n prow | kubectl replace configmap plugins -n prow -f -

prow-update-config: get-cluster-credentials
	kubectl create configmap config --from-file=config.yaml=env/$(ENV)/prow/config.yaml --dry-run -o yaml -n prow | kubectl replace configmap config -n prow -f -

prow-update-labels: get-cluster-credentials
	kubectl create configmap label-config --from-file=lebels.yaml=env/$(ENV)/prow/labels.yaml --dry-run -o yaml -n prow | kubectl replace configmap label-config -n prow -f -

prow-uninstall: get-cluster-credentials
	kubectl delete -f env/$(ENV)/prow/manifests

install: cluster-install prow-install

uninstall: cluster-uninstall prow-uninstall

get-cluster-credentials:
	@ENV=$(ENV) $(MAKE) -C ../infrastructure get-cluster-credentials
