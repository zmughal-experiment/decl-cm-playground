$(eval $(init-include))
THIS_DIR := $(call get-relative-makefile-dir)
#$(info $(CURRENT_MAKEFILE) : $(CURRENT_MAKEFILE_STACK))

define RULE :=
cfengine:
	docker build -t cfengine-test -f $(THIS_DIR)/Dockerfile.debian .
	docker run --rm cfengine-test
endef

$(eval $(RULE))
