$(eval $(init-include))
THIS_DIR := $(call get-relative-makefile-dir)

# Use the Docker socket.
# See <https://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/>.
define RULE :=
bass: bin-guard-docker ## Build Bass Docker
	docker build -t bass-test --build-arg THIS_DIR=$(THIS_DIR) -f $(THIS_DIR)/Dockerfile.debian .
	docker run --rm \
		-v /var/run/docker.sock:/var/run/docker.sock \
		bass-test
endef

$(eval $(RULE))
