#!/bin/bash -x
sudo podman run -it --rm \
    --entrypoint bash \
    --volume $(pwd):/root/koffer:z \
    --volume /tmp/platform/secrets/docker/quay.json:/root/.docker/config.json:ro \
  docker.io/containercraft/koffer:nightlies

