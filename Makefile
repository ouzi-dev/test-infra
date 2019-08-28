.PHONY: fmt infra-plan infra-apply infra-destroy infra-output deploy-validate deploy-dry-run deploy get-kubeconfig

ifndef ENV
$(error ENV is not set)
endif

fmt:
	@ENV=$(ENV) $(MAKE) -C infrastructure fmt

infra-setup:
	@ENV=$(ENV) $(MAKE) -C infrastructure setup

infra-plan:
	@ENV=$(ENV) $(MAKE) -C infrastructure plan

infra-apply:
	@ENV=$(ENV) $(MAKE) -C infrastructure apply

infra-destroy:
	@ENV=$(ENV) $(MAKE) -C infrastructure destroy	

infra-output:
	@ENV=$(ENV) $(MAKE) -C infrastructure output	

install: infra-apply get-kubeconfig 
	@ENV=$(ENV) $(MAKE) -C hack install

uninstall: get-kubeconfig
	@ENV=$(ENV) $(MAKE) -C hack uninstall
	@ENV=$(ENV) $(MAKE) infra-destroy

get-kubeconfig:
	@ENV=$(ENV) $(MAKE) -C infrastructure get-kubeconfig	