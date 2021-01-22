#!/bin/bash
run () {
#ansible_user="$(whoami)"
project="collector-operators"

echo ">> Pulling quay.io/cloudctl/koffer"
podman pull quay.io/cloudctl/koffer:extra

rm -rf /tmp/koffer
mkdir -p /tmp/koffer
mkdir -p ${HOME}/{bundle,operators}
cp -rf ~/.ssh /tmp/koffer/.ssh
cp -rf ~/.docker /tmp/koffer/.docker
mkdir -p /tmp/koffer/{.ssh,.docker,.aws}

#clear
echo ">>  Starting Koffer"
podman run -it --rm \
    --privileged --device /dev/fuse                \
    --name ${project} -h ${project}                \
    --volume  $(pwd):/root/koffer:z                \
    --volume  ${HOME}/bundle:/root/bundle:z        \
    --volume  /tmp/koffer/.docker:/root/.docker:z  \
    --entrypoint ./collector/site.yml              \
  quay.io/cloudctl/koffer:extra
}

run
