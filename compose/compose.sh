#!/bin/sh

docker run --rm \
	--volume /var/run/docker.sock:/var/run/docker.sock \
	--volume $PWD:$PWD \
	--workdir $PWD \
	docker compose "$@"
