# NOTE: GNU Makefile
include inc/common.mk
$(eval $(init-first))

THIS_DIR := $(call get-relative-makefile-dir)

TARGETS := \
       ansible \
       cfengine \
       chef \
       puppet \
       bass \
       earthly \
       nix \
       #

.PHONY: all $(TARGETS)

all: $(TARGETS)

nop:
	@true

INCLUDES := \
	$(THIS_DIR)/scenario/configuration-management/ansible/Makefile  \
	$(THIS_DIR)/scenario/configuration-management/cfengine/Makefile \
	$(THIS_DIR)/scenario/configuration-management/chef/Makefile     \
	$(THIS_DIR)/scenario/configuration-management/puppet/Makefile   \
	$(THIS_DIR)/scenario/build-automation/bass/Makefile             \
	$(THIS_DIR)/scenario/build-automation/earthly/Makefile          \
	$(THIS_DIR)/scenario/package-manager/nix/Makefile               \
	#

$(foreach inc,$(INCLUDES),$(eval $(call scoped-include,$(inc))))
