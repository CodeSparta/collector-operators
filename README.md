# [Koffer](https://github.com/containercraft/Koffer) Collector | Operators
## About
Koffer Collector OLM Operators Plugin leverages the Koffer Engine runtime container
to enable streamlined low side enumeration and capture of all required artifacts
for deploying OpenShift Operator Hub and supported disconnected operators.
Primarily built to enable airgaped environments in a standard "registry < to > mirror"
workflow model conventional to more typical connected local mirror techniques.

### Features:
  - Low side injestion direct to "pre-hydrated" registry stateful path
  - High side sha256 verification of artifacts bundle before standup
  - High side artifacts served via generic docker registry container

### Capabilities:
  - Build custom operator catalog index images
  - Generate imageContentSourcePolicy yaml definitions
  - Generate raw list of operator set image dependencies (mirror.list)
  - Build offline carry bundle for quarantine / airgap travel
  - Mirror images direct to accessible docker v2 compliant registry
  - CloudCtl ready bundle of artifacts

## Getting Started:

### 1. Local run requirements
  - RHEL8, Fedora 33+, or CoreOS 3.6.8+
  - Packages:
    - podman 1.9+
    - fuse-overlayfs
  - A minimum of 32GB free storage
  - sudo privileges for nested container build support

### 2. Run Koffer Engine with [Remote Config](https://git.io/JtUHP)
```
mkdir ${HOME}/bundle; \
sudo podman run -it --rm --pull always \
    --privileged --device /dev/fuse \
    --volume ${HOME}/bundle:/root/bundle:z \
    --volume ${HOME}/.docker:/root/.docker:z \
  quay.io/cloudctl/koffer:v00.21.0208-extra bundle \
    --config https://git.io/JtUHP
```

### 2. Check Bundle
```
 du -sh ${HOME}/bundle/koffer-bundle.operators-*.tar;
```

###4. Unpack the bundle
  - Copy the bundle to the restricted side deployment node
  - NOTE: sha256sum checking may take a while for large bundles
```
 cd ${HOME}/bundle;
 sha256sum --check;
 sudo tar -xvf ${HOME}/bundle/koffer-bundle.openshift-*.tar -C /root;
```

###5. The operator content is now in place to serve via [CloudCtl - Trusted Platform Delivery Kit](https://github.com/CloudCtl/cloudctl)

## Roadmap
  - [x] Adopt OPM utility
  - [x] Adopt koffer.yml declarative artifact gather
  - [x] Support redhat, marketplace, certified, and community operator catalogs
  - [ ] Publish as part of Ansible Galaxy CodeSparta Collection
  - [ ] Rewrite python OPM wrapper as ansible module with deprication plan
  - [ ] Automate bundle upload & image availability via [ShipperD Operator](https://github.com/ShipperD/shipperd-operator)

## References
  - [CodeCtl.io](https://codectl.io)
  - [Supported Offline Operators List](https://access.redhat.com/articles/4740011)
