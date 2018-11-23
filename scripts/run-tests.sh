#!/bin/bash

set -o xtrace

DOCKER_IMAGE=${DOCKER_IMAGE:-"hello-world"}

docker build -t "$DOCKER_IMAGE" .
~/.docker/official-images/test/run.sh "$DOCKER_IMAGE"
