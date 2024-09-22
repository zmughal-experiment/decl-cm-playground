# NOTE: GNU Makefile
#
# Requires:
# - expr
# - perl

# Must set TOP to the following before including:
#
#   TOP := $(patsubst %/,%,$(dir $(realpath $(lastword $(MAKEFILE_LIST)))))



# Minimum needed for $(.SHELLSTATUS)
MAKE_MIN_REQUIRED_VERSION := 4.2

# Include and init guard in one.
$(if $(__common_init_first_guard),$(error Should only include this file once),$(eval __common_init_first_guard :=))

# GNU Makefile
VERSION := $(shell $(MAKE) --version)
ifneq ($(firstword $(VERSION)),GNU)
$(error Use GNU Make)
endif

# Function to compare version numbers using Perl
# Usage: $(call version-at-least,VERSION_TO_CHECK,MINIMUM_VERSION)
# Returns 'true' if VERSION_TO_CHECK is at least MINIMUM_VERSION, empty otherwise
define version-at-least
$(shell perl -MList::Util=max -e '         \
    sub version_compare {                  \
        my @v  = map { [split /\./] } @_;  \
        my @v1 = @{ $$v[0] };              \
        my @v2 = @{ $$v[1] };              \
        my $$len = max(0+@v1, 0+@v2);      \
        for my $$i (0..$$len-1) {          \
            my $$cmp =                     \
                       ($$v1[$$i] || 0)    \
                   <=> ($$v2[$$i] || 0);   \
            return $$cmp if $$cmp;         \
        }                                  \
        return 0;                          \
    }                                      \
    exit 1 if version_compare(@ARGV) < 0;  \
    print "true";                          \
' -- $(1) $(2))
endef

# Check if GNU Make version is at least $(MAKE_MIN_REQUIRED_VERSION)
ifeq ($(call version-at-least,$(MAKE_VERSION),$(MAKE_MIN_REQUIRED_VERSION)),)
$(error This Makefile requires GNU Make $(MAKE_MIN_REQUIRED_VERSION) or later)
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

COMMON_INCLUDES_ = \
            $(TOP)/inc/str-transform.mk \
            #

# Uses expr(1).
define get-including-makefile
$(word $(shell expr $(words $(MAKEFILE_LIST)) - 1),$(MAKEFILE_LIST))
endef

# Initialize the first time
define init-first
$(if $(__common_init_first_guard),$(error Should only call init-first once),__common_init_first_guard := 1)
CURRENT_MAKEFILE := $(realpath $(call get-including-makefile))
ROOT_DIR := $(dir $(CURRENT_MAKEFILE))
include $(COMMON_INCLUDES_)
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

DOLLAR := $$
DOLLARDOLLAR := $$$$

# $(call escape-dollar,$(VAR_TO_ESCAPE))
define escape-dollar
$(subst $$,$$$$,$1)
endef

define _shell-frag-compute-abs2rel
perl -MFile::Spec::Functions=abs2rel                 \
	-e '                                         \
	die "Need 2 arguments to compute abs2rel.\n" \
		unless @ARGV == 2;                   \
	print abs2rel(@ARGV)'
endef

define _shell-frag-compute-rel2abs
perl -MFile::Spec::Functions=rel2abs                 \
	-e '                                         \
	die "Need 2 arguments to compute rel2abs.\n" \
		unless @ARGV == 2;                   \
	print rel2abs(@ARGV)'
endef

define shell-with-check
$(shell $(1))$\
$(if $(filter 0,$(.SHELLSTATUS)),,$(error Command failed: $(1)))
endef

# $(call get-absolute-path-with-base,$\
#       $(relative-or-absolute-path),$\
#       $(base-path))
define get-absolute-path-with-base
$(call shell-with-check,$(_shell-frag-compute-rel2abs) $(1) $(2))
endef

# $(call get-relative-path-with-base,$\
#       $(relative-or-absolute-path),$\
#       $(base-path))
define get-relative-path-with-base
$(call shell-with-check,$(_shell-frag-compute-abs2rel) $(1) $(2))
endef
