$(eval $(init-include))
THIS_DIR := $(call get-relative-makefile-dir)
#$(info $(CURRENT_MAKEFILE) : $(CURRENT_MAKEFILE_STACK))

.PHONY: cfengine
cfengine: ## Build CFEngine Docker
define RULE :=
cfengine: bin-guard-docker
	docker build -t cfengine-test --build-arg THIS_DIR=$(THIS_DIR) -f $(THIS_DIR)/Dockerfile.debian .
	docker run --rm cfengine-test
endef

$(eval $(RULE))
