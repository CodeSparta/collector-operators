#!/bin/bash -x
sudo podman run -it --rm \
    --entrypoint bash \
    --privileged --device /dev/fuse \
    --volume $(pwd):/root/koffer:z \
    --volume /tmp/bundle:/root/deploy/bundle:z \
  docker.io/codesparta/koffer
