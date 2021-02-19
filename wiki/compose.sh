#!/bin/sh

docker run --rm \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v $PWD:$PWD \
	--workdir $PWD \
	docker/compose "$@"
