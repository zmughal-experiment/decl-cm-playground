.PHONY: _env-guard _bin-guard

# See more at
# <https://stackoverflow.com/questions/10858261/how-to-abort-makefile-if-variable-not-set>
env-guard-%: _env-guard
	@ if [ -z "${${*}}" ]; then \
		echo "Environment variable $* not set"; \
		exit 1; \
	fi

bin-guard-%: _bin-guard
	@ if ! which "${*}" >/dev/null; then \
		echo "Executable $* not found"; \
		exit 1; \
	fi
