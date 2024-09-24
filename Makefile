# NOTE: GNU Makefile

TOP := $(patsubst %/,%,$(dir $(realpath $(lastword $(MAKEFILE_LIST)))))
include $(TOP)/inc/common.mk
$(eval $(init-first))

THIS_DIR := $(call get-relative-makefile-dir)

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

INCLUDES := \
	scenario/configuration-management/ansible/Makefile     \
	scenario/configuration-management/cfengine/Makefile    \
	scenario/configuration-management/chef/Makefile        \
	scenario/configuration-management/puppet/Makefile      \
	scenario/configuration-management/saltstack/Makefile   \
	scenario/build-automation/bass/Makefile                \
	scenario/build-automation/bazel/Makefile               \
	scenario/build-automation/earthly/Makefile             \
	scenario/build-automation/gradle/Makefile              \
	scenario/build-automation/maven/Makefile               \
	scenario/package-manager/nix/Makefile                  \
	scenario/infrastructure-as-code/terraform/Makefile     \
	\
	strategy/anitya/Makefile                               \
	strategy/debian-udd/Makefile                           \
	strategy/repology/Makefile                             \
	#

$(foreach inc,$(INCLUDES),$(eval $(call scoped-include,$(ROOT_DIR_RELATIVE)/$(inc))))
