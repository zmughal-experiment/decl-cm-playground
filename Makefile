# NOTE: GNU Makefile
include inc/common.mk
$(eval $(init-first))

THIS_DIR := $(call get-relative-makefile-dir)

CMs := \
       ansible \
       cfengine \
       chef \
       puppet \
       #


.PHONY: all $(CMs)

all: $(CMs)

nop:
	@true

INCLUDES := \
	$(THIS_DIR)/scenario/configuration-management/ansible/Makefile  \
	$(THIS_DIR)/scenario/configuration-management/cfengine/Makefile \
	$(THIS_DIR)/scenario/configuration-management/chef/Makefile     \
	$(THIS_DIR)/scenario/configuration-management/puppet/Makefile   #

$(foreach inc,$(INCLUDES),$(eval $(call scoped-include,$(inc))))
