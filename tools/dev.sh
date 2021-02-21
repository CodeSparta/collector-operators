#!/bin/bash
run () {
project="collector-operators"
echo ">> Pulling quay.io/cloudctl/koffer"
podman pull quay.io/cloudctl/koffer:extra
rm -rf /tmp/koffer
mkdir -p /tmp/koffer ${HOME}/{.docker,bundle,operators}
echo ">>  Starting Koffer"
sudo podman run -it --rm --entrypoint bash \
    --name ${project} -h ${project}                              \
    --privileged --device /dev/fuse                              \
    --volume  $(pwd):/root/koffer:z                              \
    --volume  ${HOME}/bundle:/root/bundle:z                      \
    --volume  ${HOME}/.docker:/root/.docker:z                    \
    --volume  $(pwd)/tools/koffer.yml:/root/.koffer/config.yml:z \
  quay.io/cloudctl/koffer:extra
}

clear && run
