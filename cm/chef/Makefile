chef:
	docker build -t chef-test -f cm/chef/Dockerfile.debian .
	docker run --rm -e CHEF_LICENSE=accept chef-test
