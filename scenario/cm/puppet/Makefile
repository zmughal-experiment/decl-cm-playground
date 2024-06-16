$(eval $(init-include))
THIS_DIR := $(call get-relative-makefile-dir)
#$(info $(CURRENT_MAKEFILE) : $(CURRENT_MAKEFILE_STACK))

puppet:
	docker build -t puppet-test -f $(THIS_DIR)/Dockerfile.debian .
	docker run --rm puppet-test
