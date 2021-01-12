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
project="koffer-collector"

echo ">> Pulling quay.io/cloudctl/koffer"
podman pull quay.io/cloudctl/koffer:latest

cp -rf ~/.ssh /tmp/koffer/.ssh
mkdir -p /tmp/koffer/{bundle,operators}

echo ">>  Starting Koffer"
podman run -it --rm --entrypoint bash \
    --name ${project} -h ${project}            \
    --publish 10.88.0.1:5000:5000              \
    --volume  /tmp/koffer/.ssh:/root/.ssh:z    \
    --volume  /tmp/koffer/bundle:/root/bundle:z \
    --volume  /tmp/koffer/operators:/root/platform/operators:z \
  quay.io/cloudctl/koffer:latest

rm -rf /tmp/koffer/.ssh
}

run

