.PHONY: deploy-cluster
deploy-cluster:
	@$(MAKE) -C cluster deploy

.PHONY: deploy-prow-config
deploy-prow-config: 
	@kubectl create configmap plugins --from-file=plugins.yaml=plugins.yaml --dry-run -o yaml -n prow | kubectl apply -f - 
	@kubectl create configmap label-config --from-file=labels.yaml=labels.yaml --dry-run -o yaml -n prow | kubectl apply -f -
	@kubectl create configmap config --from-file=config.yaml=config.yaml --dry-run -o yaml -n prow | kubectl apply -f - 

.PHONY: get-cluster-credentials
get-cluster-credentials:
	@$(MAKE) -C cluster get-cluster-credentials