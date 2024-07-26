$(eval $(init-include))
THIS_DIR := $(call get-relative-makefile-dir)

define RULE :=
maven: bin-guard-docker
	docker build -t maven-test --build-arg THIS_DIR=$(THIS_DIR) -f $(THIS_DIR)/Dockerfile.debian .
	docker run --rm maven-test
endef

$(eval $(RULE))
