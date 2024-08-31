$(eval $(init-include))
THIS_DIR := $(call get-relative-makefile-dir)

.PHONY: gradle
gradle: ## Build Gradle Docker
define RULE :=
gradle: bin-guard-docker
	docker build -t gradle-test --build-arg THIS_DIR=$(THIS_DIR) -f $(THIS_DIR)/Dockerfile.debian .
	docker run --rm gradle-test
endef

$(eval $(RULE))
