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
mkdir ${HOME}/bundle; \
sudo podman run -it --rm \
    --privileged --device /dev/fuse \
    --volume ${HOME}/bundle:/root/bundle:z \
    --volume ${HOME}/.docker:/root/.docker:z \
  quay.io/cloudctl/koffer:extra bundle \
    --config https://git.io/JtUHP
```
### 2. Review Bundle(s)
```
 du -sh ${HOME}/*
```

## Instructions For custom operator import:
### 0. Prereqs
  - RHEL8, Fedora 33+, or CoreOS 3.6.8+
  - Packages:
    - podman
    - fuse-overlayfs

### 1. Create a custom list of operators
```
echo "
# Koffer Config
# https://github.com/RedHatOfficial/Koffer
koffer:

  # Disable user prompt for registry authentication secret
  silent: true
  plugins:

    # https://github.com/codeSparta/collector-operators
    collector-operators:
      env:
        - name: "WALLE"
          value: "true"
        - name: "BUNDLE"
          value: "true"
        - name: "OPERATORS"
          value: "my,list,goes,here"
      organization: codesparta
      service: github.com
      version: master
" > /tmp/koffer.yml
```

### 2. Run the Bundle create on the same host the previous steps were executed on

```
mkdir ${HOME}/bundle; \
sudo podman run -it --rm \
    --privileged --device /dev/fuse \
    --volume ${HOME}/bundle:/root/bundle:z \
    --volume ${HOME}/.docker:/root/.docker:z \
    --volume /tmp/koffer.yml:/root/.koffer/config.yml:z
  quay.io/cloudctl/koffer:extra bundle
```
### 3. Review Bundle(s)
```
 du -sh ${HOME}/*
```

###4. Unpack the bundle

- Copy the bundle to the offline registry node and run the tar command
```
tar -xvf ~/bundle/koffer-bundle.openshift-4.6.1.tar.xz -C /root
```
