.PHONY: fmt infra-plan infra-apply infra-destroy infra-output deploy-validate deploy-dry-run deploy get-cluster-credentials

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

install: infra-apply get-cluster-credentials
	@ENV=$(ENV) $(MAKE) -C prow install

uninstall: get-cluster-credentials
	@ENV=$(ENV) $(MAKE) -C prow uninstall
	@ENV=$(ENV) $(MAKE) infra-destroy

get-cluster-credentials:
	@ENV=$(ENV) $(MAKE) -C infrastructure get-cluster-credentials