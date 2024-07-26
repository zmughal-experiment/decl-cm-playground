.PHONY: _env-guard _bin-guard

env-guard-%: _env-guard
	@ if [ "${${*}}" = "" ]; then \
		echo "Environment variable $* not set"; \
		exit 1; \
	fi

bin-guard-%: _bin-guard
	@ if ! which "${*}" >/dev/null; then \
		echo "Executable $* not found"; \
		exit 1; \
	fi
