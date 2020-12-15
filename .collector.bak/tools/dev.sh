#!/bin/bash
mkdir -p ${HOME}/bundle
sudo podman run -it --rm \
    --privileged --device /dev/fuse \
    --entrypoint bash --name koffer -h koffer\
    --volume ${HOME}/bundle:/root/bundle:z \
    --volume ${HOME}/.docker:/root/.docker:z \
    --volume $(pwd):/root/koffer:z \
  quay.io/cloudctl/koffer
