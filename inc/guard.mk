.PHONY: _env-guard _bin-guard


# See more at
# <https://stackoverflow.com/questions/10858261/how-to-abort-makefile-if-variable-not-set>
#
# @$(call _macro_env-guard-check-empty-or-unset,environment-variable,[true|false])
#
# @$(call _macro_env-guard-check-empty-or-unset,$*,true)
#
# By default, these will fail if variable is
#
# - empty or unset
#
#   @$(call _macro_env-guard-check-empty-or-unset,$*)
#
# - set but just empty
#
#   @$(call _macro_env-guard-check-empty,$*)
#
# - unset
#   @$(call _macro_env-guard-check-unset,$*)
define _macro_env-guard-check-empty-or-unset
	if [ -z "$${$1:-}" ]; then \
		echo "Environment variable $1 is empty or unset"; \
		$(if $(value 2),$2,false); \
	fi
endef
define _macro_env-guard-check-unset
	if [ -z "$${$1+defined}" ]; then \
		echo "Environment variable $1 is unset"; \
		$(if $(value 2),$2,false); \
	fi
endef
define _macro_env-guard-check-empty
	if [ ! -z "$${$1+defined}" ] && [ -z "$${$1}" ]; then \
		echo "Environment variable $1 is empty"; \
		$(if $(value 2),$2,false); \
	fi
endef

env-guard-empty-%: _env-guard
	@$(call _macro_env-guard-check-empty,$*)

env-guard-unset-%: _env-guard
	@$(call _macro_env-guard-check-unset,$*)

env-guard-%: _env-guard
	@$(call _macro_env-guard-check-empty-or-unset,$*)

bin-guard-%: _bin-guard
	@ if ! which "${*}" >/dev/null; then \
		echo "Executable $* not found"; \
		false; \
	fi
