# Requires:
# - expr
# - perl

# Include and init guard in one.
$(if $(__common_init_first_guard),$(error Should only include this file once),$(eval __common_init_first_guard :=))

# GNU Makefile
VERSION := $(shell $(MAKE) --version)
ifneq ($(firstword $(VERSION)),GNU)
$(error Use GNU Make)
endif

MAKEFLAGS += --warn-undefined-variables
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help
.DELETE_ON_ERROR:
.SUFFIXES:

MKDIR_P := mkdir -p
CP      := cp
ECHO    := echo

# Uses expr(1).
define get-including-makefile
$(word $(shell expr $(words $(MAKEFILE_LIST)) - 1),$(MAKEFILE_LIST))
endef

# Initialize the first time
define init-first
$(if $(__common_init_first_guard),$(error Should only call init-first once),__common_init_first_guard := 1)
CURRENT_MAKEFILE := $(realpath $(call get-including-makefile))
ROOT_DIR := $(dir $(CURRENT_MAKEFILE))
endef

# Initialize for subsequent times
define init-include
CURRENT_MAKEFILE := $(realpath $(lastword $(MAKEFILE_LIST)))
endef

# Save the current CURRENT_MAKEFILE context
define push-context
CURRENT_MAKEFILE_STACK := $(CURRENT_MAKEFILE) $(CURRENT_MAKEFILE_STACK)
endef

# Restore the previous CURRENT_MAKEFILE context
define pop-context
CURRENT_MAKEFILE := $(firstword $(CURRENT_MAKEFILE_STACK))
CURRENT_MAKEFILE_STACK := $(wordlist 2,$(words $(CURRENT_MAKEFILE_STACK)),$(CURRENT_MAKEFILE_STACK))
endef

# Include a Makefile with the current context saved and restored
define scoped-include
$(eval $(push-context))
include $1
$(pop-context)
endef

define compute-relative-makefile-dir =
$(shell
	perl -MFile::Spec::Functions=abs2rel \
		-e 'print abs2rel(shift, shift)' \
		$(dir $(realpath $(CURRENT_MAKEFILE))) \
		$(ROOT_DIR))
endef

define get-relative-makefile-dir =
$(if $(MAKEFILE_$(CURRENT_MAKEFILE)_RELATIVE_DIR),,$\
	$(eval MAKEFILE_$(CURRENT_MAKEFILE)_RELATIVE_DIR := $(call compute-relative-makefile-dir))$\
)$\
$(MAKEFILE_$(CURRENT_MAKEFILE)_RELATIVE_DIR)
endef

# $(call escape-dollar,$(VAR_TO_ESCAPE))
define escape-dollar
$(subst $$,$$$$,$1)
endef
