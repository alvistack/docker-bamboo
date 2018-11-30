#!/bin/bash

set -o xtrace

IMAGE=${IMAGE:-"hello-world"}

docker build -t "$IMAGE" .
~/.docker/official-images/test/run.sh "$IMAGE"
