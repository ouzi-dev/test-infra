.PHONY: infra-plan infra-apply

ifndef ENV
$(error ENV is not set)
endif

fmt:
	@ENV=$(ENV) $(MAKE) -C infrastructure fmt

infra-plan:
	@ENV=$(ENV) $(MAKE) -C infrastructure plan

infra-apply:
	@ENV=$(ENV) $(MAKE) -C infrastructure apply

infra-output:
	@ENV=$(ENV) $(MAKE) -C infrastructure output	

deploy-validate:
	@cd ./prow/scripts; ENV=$(ENV) ./validate-config.sh

deploy-dry-run: get-kubeconfig
	@cd ./prow/scripts; ENV=$(ENV) ./apply-manifests.sh -d

deploy: get-kubeconfig 
	@cd ./prow/scripts; ENV=$(ENV) ./apply-manifests.sh

get-kubeconfig:
	@ENV=$(ENV) $(MAKE) -C infrastructure get-kubeconfig	