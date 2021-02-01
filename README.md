# [Koffer](https://github.com/containercraft/Koffer) Collector | Operator Artifacts
This automation provides a unified and standardized method of enumerating
operator dependencies and either mirroring direct to an accisible docker v2
compliant registry service, or producing a tarball of all artifacts that is
cloudctl compliant for use across an airgap.
### [Supported Offline Operators List](https://access.redhat.com/articles/4740011)

## About
Koffer Collector Operator Hub uses the Koffer Engine runtime container to enable
streamlined low side enumeration and capture of all required artifacts for deploying
OpenShift Operator Hub. Primarily built to enable airgaped environments in a standard 
"registry < to > mirror" workflow model conventional to more typical connected 
local mirror techniques.

Features:
  - Low side injestion direct to "pre-hydrated" registry stateful path
  - High side sha256 verification of artifacts bundle before standup
  - High side artifacts served via generic docker registry container

Capabilities:
  - Custom operator catalog index image
  - imageContentSourcePolicy yaml definition
  - mapping.txt
  - mirror.list
  - CloudCtl ready bundle of artifacts
  - Mirror images direct to accessible docker v2 compliant registry

## Instructions:
### 0. Prereqs
  - RHEL8, Fedora 33+, or CoreOS 3.6.8+
  - Packages:
    - podman
    - fuse-overlayfs

### 1. Run Koffer Engine
```
sudo podman run -it --rm --pull always \
    --volume ${HOME}/bundle:/root/bundle:z \
    --volume ${HOME}/.docker:/root/.docker:z \
    --privileged --device /dev/fuse \
  quay.io/cloudctl/koffer:extra bundle \
    --config https://raw.githubusercontent.com/CodeSparta/collector-operators/master/collector/koffer.yml
```
### 2. Review list of images & imageContentSourcePolicy.yaml
```
ls operators/*/
```
