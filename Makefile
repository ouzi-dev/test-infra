.PHONY: infra-plan infra-apply

ifndef ENV
$(error ENV is not set)
endif

infra-plan:
	ENV=$(ENV) $(MAKE) -C infrastructure plan

infra-apply:
	ENV=$(ENV) $(MAKE) -C infrastructure apply

deploy-validate:
	./prow/scripts/validate-config.sh

deploy-dry-run:
	./prow/scripts/apply-manifests.sh -d

deploy:
	./prow/scripts/apply-manifests.sh