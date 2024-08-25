$(eval $(init-include))
THIS_DIR := $(call get-relative-makefile-dir)

ifneq (,$(wildcard $(THIS_DIR)/.env))
    include $(THIS_DIR)/.env
    export
endif

PROJECT_NAME := $(notdir $(THIS_DIR))

# Prefix for rules
P := $(PROJECT_NAME)

.PHONY: \
	$(P)_db-dump-download                \
	$(P)_docker-compose-up               \
	$(P)_docker-compose-down             \
	$(P)_docker-compose-exec-bash        \
	$(P)_docker-compose_db-dump-restore  \
	$(P)_docker-compose_clean-pgdata

define DEBIAN_UDD_MESSAGE

$(P)_docker-compose-up
$(P)_docker-compose-down
$(P)_docker-compose-exec-bash
$(P)_docker-compose_db-dump-restore
$(P)_docker-compose_clean-pgdata

endef

MESSAGE += $(DEBIAN_UDD_MESSAGE)

$(P)_db-dump-download:
	$(THIS_DIR)/bin/db-dump-download $(TOP_DIR)

PROJECT_MAIN_SERVICE := udd

## docker compose -f ...
DOCKER_COMPOSE_CONFIG_FILES := $(THIS_DIR)/docker-compose.yaml
DOCKER_COMPOSE_CONFIG_ARGS  := $(foreach F,$(DOCKER_COMPOSE_CONFIG_FILES),-f $F)

## docker compose --env-file ...
DOCKER_COMPOSE_ENV_FILES    := $(THIS_DIR)/.env
DOCKER_COMPOSE_ENV_ARGS     := $(foreach F,$(DOCKER_COMPOSE_ENV_FILES),--env-file $F)

DOCKER_COMPOSE_BASE_FILES   := $(DOCKER_COMPOSE_CONFIG_FILES) \
			       $(DOCKER_COMPOSE_ENV_FILES)
DOCKER_COMPOSE_BASE_ARGS    := -p $(PROJECT_NAME) \
			       $(DOCKER_COMPOSE_CONFIG_ARGS) \
			       $(DOCKER_COMPOSE_ENV_ARGS)


DEBIAN_UDD_DUMP_FILE_SYMLINK := $(TOP_DIR)/work/debian-udd/download/udd.dump
DEBIAN_UDD_DUMP_FILE_SYMLINK_SENTINEL := $(DEBIAN_UDD_DUMP_FILE_SYMLINK).sentinel
DEBIAN_UDD_DUMP_FILE := $(realpath $(DEBIAN_UDD_DUMP_FILE_SYMLINK))


$(DEBIAN_UDD_DUMP_FILE_SYMLINK_SENTINEL):
	$(MKDIR_P) $(@D)
	$(THIS_DIR)/bin/db-dump-download $(TOP_DIR)
	@touch $@

$(THIS_DIR)/.env: $(THIS_DIR)/.env.template
	@( [ -r $@ ] && echo "$@ already exists. Not updating (touch file to remove message)." ) \
		|| ( echo "Copying $< to $@" && $(CP) $< $@ )

DOCKER_PGDATA_DIR_DEFAULT := $(TOP)/work/debian-udd/postgres/data
DOCKER_PGDATA_TARGET := /var/lib/postgresql/data
# Set the actual absolute path to the PGDATA directory using
# `DEBIAN_UDD_DOCKER_POSTGRES_DATA_DIR` if set (via `.env`).
ifneq (,$(DEBIAN_UDD_DOCKER_POSTGRES_DATA_DIR))
DOCKER_PGDATA_DIR := $(call get-absolute-path-with-base,$\
	$(DEBIAN_UDD_DOCKER_POSTGRES_DATA_DIR),$\
	$(TOP))
else
DOCKER_PGDATA_DIR := $(DOCKER_PGDATA_DIR_DEFAULT)
endif
#$(info $(DOCKER_PGDATA_DIR) $$(DOCKER_PGDATA_DIR))
#$(info $(DOCKER_PGDATA_DIR_DEFAULT) $$(DOCKER_PGDATA_DIR_DEFAULT))

define shell_frag_set_DEBIAN_UDD_DUMP_FILE
DEBIAN_UDD_DUMP_FILE=`realpath $(DEBIAN_UDD_DUMP_FILE_SYMLINK)`
endef

define shell_frag_set_DEBIAN_UDD_DOCKER_POSTGRES_DATA_DIR
DEBIAN_UDD_DOCKER_POSTGRES_DATA_DIR=$(DOCKER_PGDATA_DIR)
endef

define shell_frag_set_THIS_DIR_ABSPATH
THIS_DIR_ABSPATH=`realpath $(THIS_DIR)`
endef

DOCKER_COMPOSE_BASE_DEPS    := \
	$(DOCKER_COMPOSE_BASE_FILES) $(DEBIAN_UDD_DUMP_FILE_SYMLINK_SENTINEL) \
	$(DOCKER_PGDATA_DIR) \
	bin-guard-docker bin-guard-realpath

define DOCKER_COMPOSE_BASE_CMD
env \
	$(shell_frag_set_DEBIAN_UDD_DUMP_FILE)                \
	$(shell_frag_set_DEBIAN_UDD_DOCKER_POSTGRES_DATA_DIR) \
	$(shell_frag_set_THIS_DIR_ABSPATH)                    \
docker compose $(DOCKER_COMPOSE_BASE_ARGS)
endef

$(DOCKER_PGDATA_DIR):
	$(MKDIR_P) $(@D)

$(P)_docker-compose-up: $(DOCKER_COMPOSE_BASE_DEPS)
	$(DOCKER_COMPOSE_BASE_CMD) \
		up -d $(PROJECT_MAIN_SERVICE)

$(P)_docker-compose-down: $(DOCKER_COMPOSE_BASE_DEPS)
	$(DOCKER_COMPOSE_BASE_CMD) \
		down

$(P)_docker-compose-exec-bash: $(DOCKER_COMPOSE_BASE_DEPS)
	$(DOCKER_COMPOSE_BASE_CMD) \
		exec $(PROJECT_MAIN_SERVICE) bash

$(P)_docker-compose_db-dump-restore: $(DOCKER_COMPOSE_BASE_DEPS)
	$(DOCKER_COMPOSE_BASE_CMD) \
		exec $(PROJECT_MAIN_SERVICE) /script/db-dump-restore

$(P)_docker-compose-config: $(DOCKER_COMPOSE_BASE_DEPS)
	$(DOCKER_COMPOSE_BASE_CMD) \
		config

$(P)_docker-compose_clean-pgdata: $(P)_docker-compose-down $(DOCKER_COMPOSE_BASE_DEPS)
	$(DOCKER_COMPOSE_BASE_CMD) \
		run \
		-v $(DOCKER_PGDATA_DIR):$(DOCKER_PGDATA_TARGET) \
		$(PROJECT_MAIN_SERVICE) \
		bash -vc ' \
			[ -d "$$PGDATA" ] && rm -Rfv "$$PGDATA"/*;   \
		'
	[ -d "$(DOCKER_PGDATA_DIR)" ] && rmdir -v "$(DOCKER_PGDATA_DIR)"
