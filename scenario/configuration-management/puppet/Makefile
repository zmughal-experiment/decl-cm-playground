$(eval $(init-include))
THIS_DIR := $(call get-relative-makefile-dir)
#$(info $(CURRENT_MAKEFILE) : $(CURRENT_MAKEFILE_STACK))

define RULE :=
puppet: bin-guard-docker ## Build Puppet Docker
	docker build -t puppet-test --build-arg THIS_DIR=$(THIS_DIR) -f $(THIS_DIR)/Dockerfile.debian .
	docker run --rm puppet-test
endef

$(eval $(RULE))
