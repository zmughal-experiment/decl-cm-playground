# Use the Docker socket.
# See <https://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/>.
bass:
	docker build -t bass-test -f build-automation/bass/Dockerfile.debian .
	docker run --rm \
		-v /var/run/docker.sock:/var/run/docker.sock \
		bass-test
