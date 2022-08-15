.PHONY: clean init plan apply destroy format validate bootstrap-init bootstrap-plan bootstrap-apply bootstrap-destroy

# Get current directory
DIR := ${CURDIR}

UNAME := $(shell uname)

AWS_ACCOUNT_ID := 257496065652
CREDSTASH_AWS_REGION:= eu-west-1
CREDSTASH_ARGS := --region $(CREDSTASH_AWS_REGION) -t credential-store

# source the terraform vars as env vars 
include terraform.tfvars

GOOGLE_APPLICATION_CREDENTIALS_PATH := $(DIR)/.terraform-account.json
GOOGLE_APPLICATION_CREDENTIALS_CREDSTASH_KEY := ouzidev-testinfra-terraform-svcaccount

# Credstash version and dowload locations
CREDSTASH_VERSION := v0.4.0
CREDSTASH_DOWNLOAD_LINUX_URL := https://github.com/sspinc/terraform-provider-credstash/releases/download/$(CREDSTASH_VERSION)/terraform-provider-credstash_linux_amd64
CREDSTASH_DOWNLOAD_DARWIN_URL := https://github.com/sspinc/terraform-provider-credstash/releases/download/$(CREDSTASH_VERSION)/terraform-provider-credstash_darwin_amd64
CREDSTASH_FILEPATH := $(HOME)/.terraform.d/plugins/terraform-provider-credstash_$(CREDSTASH_VERSION)

setup:
	@mkdir -p $(HOME)/.terraform.d/plugins
	@rm -f $(CREDSTASH_FILEPATH)
ifeq ($(UNAME),Linux)
	@curl -Ls "$(CREDSTASH_DOWNLOAD_LINUX_URL)" -o $(CREDSTASH_FILEPATH) -z $(CREDSTASH_FILEPATH)
endif
ifeq ($(UNAME),Darwin)
	@curl -Ls "$(CREDSTASH_DOWNLOAD_DARWIN_URL)" -o $(CREDSTASH_FILEPATH) -z $(CREDSTASH_FILEPATH)
endif
	@chmod +x $(CREDSTASH_FILEPATH)

.PHONY: aws-identity-check
aws-identity-check:
	@if [ `aws sts get-caller-identity | jq -r .Account` != $(AWS_ACCOUNT_ID) ]; then echo "Pointing to the wrong AWS account..You may not proceed"; exit 1; fi;

clean:
	@rm -rf .terraform

fmt:
	@terraform fmt --recursive
	
validate:
	@terraform validate .

init: get-google-service-account
	@terraform init -backend-config=backend.tfvars  -backend-config=credentials=$(GOOGLE_APPLICATION_CREDENTIALS_PATH)
	
plan: init 
	@terraform plan --var-file=terraform.tfvars -var google_credentials_file_path=$(GOOGLE_APPLICATION_CREDENTIALS_PATH) 

apply: init 
	@terraform apply --var-file=terraform.tfvars -var google_credentials_file_path=$(GOOGLE_APPLICATION_CREDENTIALS_PATH) $(TF_ARGS)

output:
	@$(MAKE) init > /dev/null 2>&1
	@terraform output --json -no-color

destroy: init
	@terraform destroy --var-file=terraform.tfvars -var google_credentials_file_path=$(GOOGLE_APPLICATION_CREDENTIALS_PATH)

get-cluster-credentials:
	@$(MAKE) init > /dev/null 2>&1
	gcloud container clusters get-credentials $(gke_name) --region=$(gcloud_region)

get-google-service-account: 
	@credstash $(CREDSTASH_ARGS) get $(GOOGLE_APPLICATION_CREDENTIALS_CREDSTASH_KEY) > $(GOOGLE_APPLICATION_CREDENTIALS_PATH)

.PHONY: export-secrets-to-credstash
export-secrets-to-credstash: aws-identity-check
	$(shell $(MAKE) -s output > .tf_output.json)
	$(shell cat .tf_output.json | jq -r .certmanager_svc_account_key.value | base64 -D > .CREDSTASH_CERT_MANAGER_SVC_ACCOUNT_KEY )
	$(shell cat .tf_output.json | jq -r .prow_bucket_svc_account_key.value | base64 -D > .CREDSTASH_PROW_BUCKET_SVC_ACCOUNT_KEY )
	$(shell cat .tf_output.json | jq -r .prow_terraform_gcloud_svc_account_key.value | base64 -D > .CREDSTASH_PROW_TERRAFORM_SVC_ACCOUNT_KEY )
	$(shell cat .tf_output.json | jq -r .preemptible_killer_svc_account_key.value | base64 -D > .CREDSTASH_GKE_PREEMPTIBLE_KILLER_SVC_ACCOUNT_KEY )
	$(shell cat .tf_output.json | jq -r .prow_credstash_reader_aws_access_key_id.value | tr -d '\n' > .CREDSTASH_PROW_CREDSTASH_READER_AWS_ACCESS_KEY_ID )
	$(shell cat .tf_output.json | jq -r .prow_credstash_reader_aws_secret_access_key.value | tr -d '\n' > .CREDSTASH_PROW_CREDSTASH_READER_AWS_SECRET_ACCESS_KEY )
	@credstash $(CREDSTASH_ARGS) delete prow-cert-manager-svc-account-key || true
	@credstash $(CREDSTASH_ARGS) put prow-cert-manager-svc-account-key @.CREDSTASH_CERT_MANAGER_SVC_ACCOUNT_KEY
	@credstash $(CREDSTASH_ARGS) delete prow-bucket-svc-account-key || true
	@credstash $(CREDSTASH_ARGS) put prow-bucket-svc-account-key @.CREDSTASH_PROW_BUCKET_SVC_ACCOUNT_KEY
	@credstash $(CREDSTASH_ARGS) delete prow-terraform-svc-account-key || true
	@credstash $(CREDSTASH_ARGS) put prow-terraform-svc-account-key @.CREDSTASH_PROW_TERRAFORM_SVC_ACCOUNT_KEY
	@credstash $(CREDSTASH_ARGS) delete prow-gke-preemptible-killer-svc-account-key || true
	@credstash $(CREDSTASH_ARGS) put prow-gke-preemptible-killer-svc-account-key @.CREDSTASH_GKE_PREEMPTIBLE_KILLER_SVC_ACCOUNT_KEY
	@credstash $(CREDSTASH_ARGS) delete prow-credstash-reader-aws-access-key-id || true
	@credstash $(CREDSTASH_ARGS) put prow-credstash-reader-aws-access-key-id @.CREDSTASH_PROW_CREDSTASH_READER_AWS_ACCESS_KEY_ID
	@credstash $(CREDSTASH_ARGS) delete prow-credstash-reader-aws-secret-access-key || true
	@credstash $(CREDSTASH_ARGS) put prow-credstash-reader-aws-secret-access-key @.CREDSTASH_PROW_CREDSTASH_READER_AWS_SECRET_ACCESS_KEY
	$(eval SERVER=$(shell gcloud container clusters describe $(gke_name) --region=$(gcloud_region) --format='value(endpoint)' ))
	$(eval CA=$(shell gcloud container clusters describe $(gke_name) --region=$(gcloud_region) --format='value(masterAuth.clusterCaCertificate)' ))
	@gotpl .kubeconfig.yaml.tpl --set server=$(SERVER) --set ca=$(CA) > .kubeconfig.yaml 
	@credstash $(CREDSTASH_ARGS) delete ouzi-prow-gke-kubeconfig || true
	@credstash $(CREDSTASH_ARGS) put ouzi-prow-gke-kubeconfig @.kubeconfig.yaml
	@rm .kubeconfig.yaml
	@rm .CREDSTASH_CERT_MANAGER_SVC_ACCOUNT_KEY
	@rm .CREDSTASH_PROW_BUCKET_SVC_ACCOUNT_KEY
	@rm .CREDSTASH_PROW_TERRAFORM_SVC_ACCOUNT_KEY
	@rm .CREDSTASH_GKE_PREEMPTIBLE_KILLER_SVC_ACCOUNT_KEY
	@rm .CREDSTASH_PROW_CREDSTASH_READER_AWS_ACCESS_KEY_ID
	@rm .CREDSTASH_PROW_CREDSTASH_READER_AWS_SECRET_ACCESS_KEY
	@rm .tf_output.json

.PHONY: get-google-cloud-build-docker-creds
get-google-cloud-build-docker-creds:
	@echo Quay username: `credstash $(CREDSTASH_ARGS) get quay_bot_username | gcloud kms encrypt \
		--project $(gcloud_project) \
		--location $(gcloud_region) \
		--keyring test-infra \
		--key build \
		--plaintext-file - \
		--ciphertext-file - \
		| base64`
	@echo Quay token: `credstash $(CREDSTASH_ARGS) get quay_bot_password | gcloud kms encrypt \
		--project $(gcloud_project) \
		--location $(gcloud_region) \
		--keyring test-infra \
		--key build \
		--plaintext-file - \
		--ciphertext-file - \
		| base64`