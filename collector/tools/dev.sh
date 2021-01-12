#!/bin/bash
run () {
# For now, koffer operator collector must be run as root
if (( $EUID != 0  )); then
  echo ">> Please run as root"
  exit 1
else
# For now, koffer executes index image startup and custom image build on host
# ansible connection over ssh required from koffer onto host
  ready=$(ssh root@10.88.0.1 whoami ; echo $?)
  if [[ ! ${ready} == 0 ]]; then
        echo ">> Host ssh connection discovered successfully"
  else
        echo ">> Host ssh connection not found"
        echo ">> Configuring host for cni ssh connection"
        [[ -f ${HOME}/.ssh/id_rsa ]] \
        || ssh-keygen -f ${HOME}/.ssh/id_rsa -t rsa -N ''
        cat ${HOME}/.ssh/id_rsa.pub >> ${HOME}/.ssh/authorized_keys
        chmod 0644 ${HOME}/.ssh/authorized_keys
  fi
fi

#ansible_user="$(whoami)"
project="collector-operators"

echo ">> Pulling quay.io/cloudctl/koffer"
podman pull quay.io/cloudctl/koffer:latest

rm -rf /tmp/.ssh
cp -rf ~/.ssh /tmp/.ssh
mkdir -p ${HOME}/{.aws,.docker,bundle}

#clear
echo ">>  Starting Koffer"
podman run -it --rm --entrypoint bash \
    --workdir ${HOME}/koffer                   \
    --name ${project} -h ${project}            \
    --publish 10.88.0.1:5000:5000              \
    --volume  $(pwd):/root/koffer:z            \
    --volume  /tmp/.ssh:/root/.ssh:z           \
    --volume  ${HOME}/.aws:/root/.aws:z        \
    --volume  $(pwd)/docker:/root/.docker:z    \
    --volume  ${HOME}/.bashrc:/root/.bashrc:z  \
    --volume  ${HOME}/bundle:/root/bundle:z    \
  quay.io/cloudctl/koffer:latest
}

run
