$(eval $(init-include))
THIS_DIR := $(call get-relative-makefile-dir)
#$(info $(CURRENT_MAKEFILE) : $(CURRENT_MAKEFILE_STACK))

define RULE :=
chef:
	docker build -t chef-test --build-arg THIS_DIR=$(THIS_DIR) -f $(THIS_DIR)/Dockerfile.debian .
	docker run --rm -e CHEF_LICENSE=accept chef-test
endef

$(eval $(RULE))
