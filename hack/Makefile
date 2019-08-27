.PHONY: clean init plan apply destroy format validate bootstrap-init bootstrap-plan bootstrap-apply bootstrap-destroy

ifndef ENV
$(error ENV is not set)
endif

helm-init: get-kubeconfig
	kubectl apply -f env/$(ENV)/helm/helm-init.yaml
	helm init --service-account tiller --history-max 200 --upgrade 

helm-install: helm-init
	kubectl apply -f env/$(ENV)/helm/helm-init.yaml
	helm upgrade --install peach stable/nginx-ingress -f env/$(ENV)/helm/nginx-ingress.yaml --namespace nginx 
	helm upgrade --install onion stable/external-dns -f env/$(ENV)/helm/nginx-ingress.yaml --namespace external-dns 
	helm upgrade --install potato stable/prometheus-operator --namespace monitoring

helm-uninstall: get-kubeconfig
	helm delete peach --purge
	helm delete onion --purge
	helm delete potato --purge
	kubectl delete -f env/$(ENV)/helm/helm-init.yaml

prow-uninstall: get-kubeconfig
	kubectl delete -f prow/manifests/resources -R
	kubectl delete -f prow/manifests/init -R

install: helm-install prow-install

uninstall: helm-uninstall prow-uninstall

get-kubeconfig:
	@ENV=$(ENV) $(MAKE) -C ../infrastructure get-kubeconfig
