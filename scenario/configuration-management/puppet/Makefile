$(eval $(init-include))
THIS_DIR := $(call get-relative-makefile-dir)
#$(info $(CURRENT_MAKEFILE) : $(CURRENT_MAKEFILE_STACK))

.PHONY: puppet
puppet: ## Build Puppet Docker
define RULE :=
puppet: bin-guard-docker
	docker build -t puppet-test --build-arg THIS_DIR=$(THIS_DIR) -f $(THIS_DIR)/Dockerfile.debian .
	docker run --rm puppet-test
endef

$(eval $(RULE))
