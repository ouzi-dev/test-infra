.PHONY: clean init plan apply destroy format validate bootstrap-init bootstrap-plan bootstrap-apply bootstrap-destroy

ifndef ENV
$(error ENV is not set)
endif

cluster-init: get-kubeconfig
	kubectl apply -f env/$(ENV)/helm/helm-init.yaml
	helm init --service-account tiller --history-max 200 --upgrade --wait

cluster-install: cluster-init
	kubectl apply -f env/$(ENV)/rbac/
	kubectl apply -f env/$(ENV)/pdbs/
	kubectl apply -f env/$(ENV)/helm/helm-init.yaml
	helm upgrade --install onion stable/external-dns -f env/$(ENV)/external-dns/helm.yaml --namespace external-dns --wait
	kubectl apply -f env/$(ENV)/cert-manager/crds.yaml
	helm upgrade --install raisin stable/cert-manager -f env/$(ENV)/cert-manager/helm.yaml --namespace cert-manager   --wait
	kubectl apply -f env/$(ENV)/cert-manager/cluster-issuer-letsencrypt.yaml
	helm upgrade --install peach stable/nginx-ingress -f env/$(ENV)/nginx-ingress/helm.yaml --namespace nginx  --wait
#	helm upgrade --install potato stable/prometheus-operator --namespace monitoring --wait

cluster-uninstall: get-kubeconfig
	helm delete peach --purge
	helm delete onion --purge
	helm delete potato --purge
	#kubectl delete -f env/$(ENV)/helm/helm-init.yaml

prow-uninstall: get-kubeconfig
	kubectl delete -f prow/manifests/resources -R
	kubectl delete -f prow/manifests/init -R

install: cluster-install prow-install

uninstall: cluster-uninstall prow-uninstall

get-kubeconfig:
	@ENV=$(ENV) $(MAKE) -C ../infrastructure get-kubeconfig
