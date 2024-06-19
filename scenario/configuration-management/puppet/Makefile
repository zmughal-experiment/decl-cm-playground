$(eval $(init-include))
THIS_DIR := $(call get-relative-makefile-dir)
#$(info $(CURRENT_MAKEFILE) : $(CURRENT_MAKEFILE_STACK))

define RULE :=
puppet:
	docker build -t puppet-test -f $(THIS_DIR)/Dockerfile.debian .
	docker run --rm puppet-test
endef

$(eval $(RULE))
