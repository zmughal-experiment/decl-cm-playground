$(eval $(init-include))
THIS_DIR := $(call get-relative-makefile-dir)
#$(info $(CURRENT_MAKEFILE) : $(CURRENT_MAKEFILE_STACK))

define RULE :=
ansible: bin-guard-docker ## Build Ansible Docker
	docker build -t ansible-test --build-arg THIS_DIR=$(THIS_DIR) -f $(THIS_DIR)/Dockerfile.debian .
	docker run --rm ansible-test
endef

$(eval $(RULE))
