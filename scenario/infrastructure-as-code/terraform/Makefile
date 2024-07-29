$(eval $(init-include))
THIS_DIR := $(call get-relative-makefile-dir)

define RULE :=
terraform: bin-guard-docker ## Build Terraform Docker
	docker build -t terraform-test --build-arg THIS_DIR=$(THIS_DIR) -f $(THIS_DIR)/Dockerfile.debian .
	docker run --rm terraform-test
endef

$(eval $(RULE))
