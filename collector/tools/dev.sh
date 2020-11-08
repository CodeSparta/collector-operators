#!/bin/bash -x
sudo podman run -it --rm \
    --entrypoint bash \
    --privileged --device /dev/fuse \
    --volume $(pwd):/root/koffer:z \
    --volume ${HOME}/bundle:/root/bundle:z \
    --volume ${HOME}/.docker:/root/.docker:z \
  docker.io/cloudctl/koffer
