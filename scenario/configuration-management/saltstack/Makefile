$(eval $(init-include))
THIS_DIR := $(call get-relative-makefile-dir)

define RULE :=
saltstack: bin-guard-docker ## Build SaltStack Docker
	docker build -t saltstack-test --build-arg THIS_DIR=$(THIS_DIR) -f $(THIS_DIR)/Dockerfile.debian .
	docker run --rm saltstack-test
endef

$(eval $(RULE))
