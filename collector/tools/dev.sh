#!/bin/bash
run () {
clear

#ansible_user="$(whoami)"
project="collector-operators"

echo ">> Pulling quay.io/cloudctl/koffer"
podman pull quay.io/cloudctl/koffer:extra

rm -rf /tmp/koffer
mkdir -p /tmp/koffer ${HOME}/{.docker,bundle,operators}
cp -rf ~/.docker /tmp/koffer/.docker

#clear
echo ">>  Starting Koffer"
podman run -it --rm --entrypoint bash \
    --name ${project} -h ${project}                \
    --privileged --device /dev/fuse                \
    --volume  $(pwd):/root/koffer:z                \
    --volume  ${HOME}/bundle:/root/bundle:z        \
    --volume  /tmp/koffer/.docker:/root/.docker:z  \
  quay.io/cloudctl/koffer:extra
}

run
