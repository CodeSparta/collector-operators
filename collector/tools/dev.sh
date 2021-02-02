#!/bin/bash
run () {
clear

#ansible_user="$(whoami)"
project="collector-operators"

echo ">> Pulling quay.io/cloudctl/koffer"
podman pull quay.io/cloudctl/koffer:extra

rm -rf /tmp/koffer
mkdir -p /tmp/koffer ${HOME}/{.docker,bundle,operators}
cp -rf ~/.docker /tmp/koffer/

#clear
echo ">>  Starting Koffer"
sudo podman run -it --rm --entrypoint bash \
    --name ${project} -h ${project}                \
    --privileged --device /dev/fuse                \
    --volume  $(pwd):/root/koffer:z                \
    --volume  /tmp/koffer/.docker:/root/.docker:z  \
    --volume  ${HOME}/bundle:/root/bundle:z        \
  quay.io/cloudctl/koffer:extra
}

run
