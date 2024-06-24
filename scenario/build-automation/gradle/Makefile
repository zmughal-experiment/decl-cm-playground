$(eval $(init-include))
THIS_DIR := $(call get-relative-makefile-dir)

define RULE :=
gradle:
	docker build -t gradle-test --build-arg THIS_DIR=$(THIS_DIR) -f $(THIS_DIR)/Dockerfile.debian .
	docker run --rm gradle-test
endef

$(eval $(RULE))
