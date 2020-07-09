# Koffer Collector | RedHat OpenShift Operator Lifecycle Hub
## Provides
This automation provides a unified and standardized tarball of artifacts for
airgap infrastructure deployment tasks.

## About
Koffer Collector Operator Hub uses the Koffer Engine runtime container to enable
streamlined low side capture of all required artifacts for deploying OpenShift 
Operator Hub. Primarily built to enable airgaped environments in a standard 
"registry < to > mirror" workflow model conventional to more typical connected 
local mirror techniques.

Features:
  - High side sha256 verification of artifacts bundle before standup
  - High side artifacts served via generic docker registry container
  - Low side injestion direct to "pre-hydrated" registry stateful path

## Instructions:
### 1. Clone into koffer directory
```
 mkdir -p /tmp/artifacts
 git clone https://repo1.dsop.io/dsop/redhat/platformone/ocp4x/ansible/operatorhub.git /tmp/operatorhub
```
### 2. Run Koffer Engine
```
 sudo podman run \
     --rm -it -h koffer --name koffer         \
     --pull=always --entrypoint entrypoint    \
     --volume /tmp/artifacts:/root/deploy:z   \
     --volume /tmp/operatorhub:/root/koffer:z \
     --volume /root/.docker/config.json:/root/.docker/config.json:z \
   docker.io/containercraft/koffer:nightlies
```
### 3. Move Koffer Bundle to target host /tmp directory
# [Developer Docs & Utils](./dev)
# Demo
![bundle](./web/bundle.svg)
