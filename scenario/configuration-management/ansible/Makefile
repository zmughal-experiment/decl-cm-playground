$(eval $(init-include))
THIS_DIR := $(call get-relative-makefile-dir)
#$(info $(CURRENT_MAKEFILE) : $(CURRENT_MAKEFILE_STACK))

define RULE :=
ansible:
	docker build -t ansible-test -f $(THIS_DIR)/Dockerfile.debian .
	docker run --rm ansible-test
endef

$(eval $(RULE))
