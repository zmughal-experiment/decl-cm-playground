$(eval $(init-include))
THIS_DIR := $(call get-relative-makefile-dir)

THIS_DIR_REL_ROOT := $(call get-relative-path-with-base,$(THIS_DIR),$(ROOT_DIR_ABSOLUTE))
export MY_BAZEL_OUTPUT_ROOT := $(ROOT_DIR_ABSOLUTE)/work/$(THIS_DIR_REL_ROOT)
#DOCKER_BAZEL_OUTPUT  := /home/ubuntu/.cache/bazel/_bazel_ubuntu
DOCKER_BAZEL_OUTPUT  := /bazel-output-root
DOCKER_UID := $(shell id -u)

define PARALLEL_RENAME_PERL_CODE :=
$$_ = readlink($$_);           $\
s,^\Q$$ENV{FROM}\E/,$$ENV{TO}/,
endef

define DEB_PACKAGE_LOCK_FILE
{ "packages": [], "version": 1 }
endef

define BAZEL_DOCKER_RUN_CMD
docker run --rm \
	-v $(ROOT_DIR_ABSOLUTE)/$(THIS_DIR_REL_ROOT)/debian_snapshot:/workspace    \
	-v $(MY_BAZEL_OUTPUT_ROOT):$(DOCKER_BAZEL_OUTPUT)   \
	-u $(DOCKER_UID)                                    \
	-w /workspace                                       \
	gcr.io/bazel-public/bazel:latest                    \
		\
		--output_user_root $(DOCKER_BAZEL_OUTPUT)
endef

# Requires:
# docker, find, parallel, ln, rm
.PHONY: bazel
bazel: ## Build Bazel Docker
define RULE :=
BAZEL_TARGET_BIN_GUARDS := \
	bin-guard-docker \
	bin-guard-find \
	bin-guard-parallel \
	bin-guard-ln \
	bin-guard-rm
bazel: $$(BAZEL_TARGET_BIN_GUARDS)
	$(MKDIR_P) $(MY_BAZEL_OUTPUT_ROOT)
	# Create Debian package lock file
	$(ECHO) '$(DEB_PACKAGE_LOCK_FILE)' > $(THIS_DIR)/debian_snapshot/bullseye.lock.json
	$(BAZEL_DOCKER_RUN_CMD) \
			run @bullseye//:lock
	# Create image
	$(BAZEL_DOCKER_RUN_CMD) \
			build //...
	# Relink symlinks from Docker to host
	export FROM="$(DOCKER_BAZEL_OUTPUT)" TO="$(MY_BAZEL_OUTPUT_ROOT)"; \
		find $(THIS_DIR)/debian_snapshot \
			-type l -name 'bazel-*'  \
			| parallel 'ln -nsf $\
				{= $(call escape-dollar,$(PARALLEL_RENAME_PERL_CODE)) =} $\
				{}'
	# Load Docker image
	docker load --input $(THIS_DIR)/debian_snapshot/bazel-bin/tarball/tarball.tar
	docker run --rm -it distroless/test:latest apache2ctl -v
	rm $(THIS_DIR)/debian_snapshot/bullseye.lock.json
endef

$(eval $(RULE))
