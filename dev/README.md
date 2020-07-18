## Developer Guide
------------
#### 0. (OPTIONAL) Build Locally
```
  sudo -i
  curl -L https://repo1.dsop.io/dsop/redhat/platformone/ocp4x/ansible/bundle/-/raw/latest/dev/bin/build-local.sh | bash -x
```
#### 1. Clone codebase under development
```
 git clone https://github.com/containercraft/koffer-openshift.git /tmp/koffer;
 cd /tmp/koffer && git checkout latest;
```
#### 2. Prepare Developer Environment
  a. Create persistence directories
```
mkdir -p /tmp/{mirror,images,docker}
```
  b. Stash pull secret
>  - Copy Quay.io Pull Secret
>  - https://cloud.redhat.com/openshift/install/metal/user-provisioned
>  - Save in config.json
>

```
vim /tmp/docker/config.json
```
#### 3. Run Container
  - Option A. Run with persistent image storage for faster run times
```
sudo podman run \
    --entrypoint entrypoint                        \
    --rm -it -h koffer --name koffer               \
    --volume /tmp/koffer:/root/koffer:z            \
    --volume /tmp/mirror:/root/deploy/mirror:z     \
    --volume /tmp/images:/root/deploy/images:z     \
  docker.io/containercraft/koffer:latest
```

  - Option B. Exec into container for manual development
```
sudo podman run \
    --entrypoint bash                              \
    --rm -it -h koffer --name koffer               \
    --volume /tmp/koffer:/root/koffer:z            \
    --volume /tmp/mirror:/root/deploy/mirror:z     \
    --volume /tmp/images:/root/deploy/images:z     \
  docker.io/containercraft/koffer:latest
```
  - Then manually exec the `/usr/bin/entrypoint` actions
```
 git pull;
 git checkout latest;
 ./usr/bin/run_registry.sh
 ./tree.yml
 ./secrets.yml
 ./git.yml
 ./images.yml
 ./bundle.yml
 du -sh /root/deploy/koffer/koffer-bundle.*.tar
```
#### 4. Place bundle on CloudCtl Bastion host /tmp directory
```
rsync --progress -avzh $(ls /tmp/koffer/koffer-bundle.*.tar) \
  -e "ssh -i ~/.ssh/id_rsa" core@${bastion_address}:/tmp/
```
#### 5. Aquire root & unpack tarball
```
sudo -i
```
```
tar -xv -C /root -f /tmp/koffer-bundle.*.tar
```
#### 5. Run CloudCtl stand up script
```  6
 . ~/start-cloudctl.sh
```
#### 7. Exec into CloudCtl
```
 podman exec -it cloudctl-one connect
```
## Remove / Purge
#### Cleanup Koffer Artifacts
```
sudo podman rmi --force koffer:latest
sudo rm -rf /tmp/koffer/bundle/koffer-bundle.*.tar
sudo rm -rf /root/{deploy,cloudctl.yml,start-cloudctl.sh,ArtifactsBundle.tar.xz.sha256,ArtifactsBundle.tar.xz}
sudo rm -rf /tmp/{koffer,mirror,images}
```
#### Cleanup CloudCtl Artifacts
```
sudo podman pod rm --force cloudctl
for container in $(sudo podman ps -a | grep -v CONTAINER | awk '/busybox|one|registry|nginx/{print $1}'); do sudo podman rm --force ${container}; done
for container in $(sudo podman images | grep -v CONTAINER | awk '/koffer|pause|busybox|one|registry|nginx/{print $3}'); do sudo podman rmi --force ${container}; done
```
[this script]:https://github.com/containercraft/Koffer/blob/latest/dev/bin/build-local.sh
