# [Koffer](https://github.com/containercraft/Koffer) Collector Plugin | OpenShift Infrastructure Artifacts
This automation provides a unified and standardized tarball of OpenShift artifacts for
restricted or airgap infrastructure deployment.

Features:
  - CloudCtl compatible
  - Low side SHA256 artifact bundle metadata (for high side bit integrity validation)
  - Low side ingestion direct to "pre-hydrated" registry stateful path [mirror-to-mirror]
  - Idempotent, can be used to additively upload artifacts to pre-existing collection

Artifacts:
  - OpenShift [Release Images]
  - [Red Hat CoreOS] VMDK
  - [Binary] `oc`
  - [Binary] `openshift-install`
    
## Usage: Execute Collector Plugin with Koffer Engine
```
 mkdir -p ${HOME}/bundle && \
 podman run -it --rm --pull always \
     --volume ${HOME}/bundle:/root/bundle:z \
   docker.io/containercraft/koffer:latest bundle \
     --plugin collector-ocp
```
  - unpack bundle
```
tar -xvf ~/bundle/koffer-bundle.openshift-4.6.1.tar.xz -C /root
```
[Release Images]:https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/release.txt
[Red Hat CoreOS]:https://mirror.openshift.com/pub/openshift-v4/dependencies/rhcos/latest/latest
[Binary]:https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest
