# [Koffer](https://github.com/containercraft/Koffer) Collector | AirGap Operator Hub Artifacts
## Provides
This automation provides a unified and standardized tarball of artifacts for
cloudctl services pod airgap operator deployment tasks.
### [Supported Offline Operators List](https://access.redhat.com/articles/4740011)

## About
Koffer Collector Operator Hub uses the Koffer Engine runtime container to enable
streamlined low side capture of all required artifacts for deploying OpenShift 
Operator Hub. Primarily built to enable airgaped environments in a standard 
"registry < to > mirror" workflow model conventional to more typical connected 
local mirror techniques.

Features:
  - Low side injestion direct to "pre-hydrated" registry stateful path
  - High side sha256 verification of artifacts bundle before standup
  - High side artifacts served via generic docker registry container

## Instructions:
### 0. Make Artifact Bundle Directory
```
 mkdir -p ${HOME}/bundle
```
### 1. Run Koffer Engine
```
podman run -it --rm --pull always \
    --device /dev/fuse \
    --volume ${HOME}/bundle:/root/bundle:z \
  docker.io/cloudctl/koffer bundle \
    --plugin collector-operators
```
### 2. Move Koffer Bundle to restricted environment
### 3. Extract to CloudCtl Artifact path
```
 tar xv -f /tmp/koffer-bundle.collector-operators.tar -C /root
```
### 4. Apply operator catalog configs with contents of `mirror/config/operators`
