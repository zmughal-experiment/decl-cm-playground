$(eval $(init-include))
THIS_DIR := $(call get-relative-makefile-dir)

.PHONY: terraform
terraform: ## Build Terraform Docker
define RULE :=
terraform: bin-guard-docker
	docker build -t terraform-test --build-arg THIS_DIR=$(THIS_DIR) -f $(THIS_DIR)/Dockerfile.debian .
	docker run --rm terraform-test
endef

$(eval $(RULE))
