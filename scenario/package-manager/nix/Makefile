$(eval $(init-include))
THIS_DIR := $(call get-relative-makefile-dir)

define RULE :=
nix:
	docker build -t nix-test --build-arg THIS_DIR=$(THIS_DIR) -f $(THIS_DIR)/Dockerfile.nixos .
	docker run --rm nix-test
endef

$(eval $(RULE))
