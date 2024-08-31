$(eval $(init-include))
THIS_DIR := $(call get-relative-makefile-dir)
#$(info $(CURRENT_MAKEFILE) : $(CURRENT_MAKEFILE_STACK))

.PHONY: ansible
ansible: ## Build Ansible Docker
define RULE :=
ansible: bin-guard-docker
	docker build -t ansible-test --build-arg THIS_DIR=$(THIS_DIR) -f $(THIS_DIR)/Dockerfile.debian .
	docker run --rm ansible-test
endef

$(eval $(RULE))
