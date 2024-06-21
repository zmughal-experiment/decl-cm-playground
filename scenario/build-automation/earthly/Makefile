$(eval $(init-include))
THIS_DIR := $(call get-relative-makefile-dir)

# Use the Docker socket.
# See <https://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/>.
define RULE :=
earthly:
	docker build -t earthly-test -f $(THIS_DIR)/Dockerfile.debian .
	docker run --rm \
		-v /var/run/docker.sock:/var/run/docker.sock \
		earthly-test --ci +build
	docker run --rm \
		-v /var/run/docker.sock:/var/run/docker.sock \
		earthly-test --ci +test
endef

$(eval $(RULE))
