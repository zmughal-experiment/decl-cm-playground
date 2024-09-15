# NOTE: GNU Makefile
TOP := $(patsubst %/,%,$(dir $(realpath $(lastword $(MAKEFILE_LIST)))))
include $(TOP)/inc/common.mk
$(eval $(init-first))

THIS_DIR := $(call get-relative-makefile-dir)
TOP_DIR  := $(THIS_DIR)

TARGETS :=         \
       ansible     \
       cfengine    \
       chef        \
       puppet      \
       saltstack   \
       bass        \
       bazel       \
       earthly     \
       gradle      \
       maven       \
       nix         \
       terraform   \
       #

.PHONY: $(TARGETS)

define MESSAGE
Targets for $(MAKE):

endef

define TARGETS_MESSAGE

## Targets

$(TARGETS)

endef

MESSAGE += $(TARGETS_MESSAGE)

# Default target
export MESSAGE
.PHONY: help
help: ## Show help
	@$(ECHO) "$$MESSAGE"
	@grep -HE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort -t: -k1,2 | cut -d: -f2- | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: all
all: $(TARGETS)

.PHONY: nop
nop:
	@true

include $(THIS_DIR)/inc/guard.mk

INCLUDES := \
	$(THIS_DIR)/scenario/configuration-management/ansible/Makefile     \
	$(THIS_DIR)/scenario/configuration-management/cfengine/Makefile    \
	$(THIS_DIR)/scenario/configuration-management/chef/Makefile        \
	$(THIS_DIR)/scenario/configuration-management/puppet/Makefile      \
	$(THIS_DIR)/scenario/configuration-management/saltstack/Makefile   \
	$(THIS_DIR)/scenario/build-automation/bass/Makefile                \
	$(THIS_DIR)/scenario/build-automation/bazel/Makefile               \
	$(THIS_DIR)/scenario/build-automation/earthly/Makefile             \
	$(THIS_DIR)/scenario/build-automation/gradle/Makefile              \
	$(THIS_DIR)/scenario/build-automation/maven/Makefile               \
	$(THIS_DIR)/scenario/package-manager/nix/Makefile                  \
	$(THIS_DIR)/scenario/infrastructure-as-code/terraform/Makefile     \
	\
	$(THIS_DIR)/strategy/anitya/Makefile                               \
	$(THIS_DIR)/strategy/debian-udd/Makefile                           \
	$(THIS_DIR)/strategy/repology/Makefile                             \
	#

$(foreach inc,$(INCLUDES),$(eval $(call scoped-include,$(inc))))
