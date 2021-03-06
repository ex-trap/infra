#!/bin/sh

IMAGE="docker/compose:alpine-1.29.2"

docker run --rm \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v $PWD:$PWD \
	--workdir $PWD \
	$IMAGE "$@"
