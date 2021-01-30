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
mkdir -p ${HOME}/operators && \
sudo podman run -it --rm --pull always \
     --privileged --device /dev/fuse \
     --volume /root/.docker:/root/.docker:z \
     --volume ${HOME}/operators:/tmp/koffer/operators:z \
     --env OPERATORS='elasticsearch-operator,cluster-logging,metering-ocp,serverless-operator,openshift-pipelines-operator-rh,nfd,ocs-operator,advanced-cluster-management,local-storage-operator,kubevirt-hyperconverged' \
   docker.io/cloudctl/koffer:extra bundle \
     --config https://git.io/JtUHP
```
### 2. Review list of images & imageContentSourcePolicy.yaml
```
ls operators/*/
```
