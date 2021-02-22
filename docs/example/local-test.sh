#!/bin/bash -x
#
# Setup:
# .
# ├── bundle
# ├── koffer.sh
# ├── koffer.yml
# └── pull-secret.json
#
# Place pull secret in $(pwd)/pull-secret.json
#  - https://cloud.redhat.com/openshift/install/metal/user-provisioned
#
# Install Dependencies:
#  - sudo dnf install -y podman fuse-overlayfs
#################################################################################

export runPath="$(pwd)"

write_config () {
cat <<EOF > ${runPath}/koffer.yml
koffer:
  silent: true
  plugins:
#   cloudctl:
#     version: master
#     service: github.com
#     organization: cloudctl
#   sparta:
#     version: master
#     service: github.com
#     organization: codesparta
#   collector-ocp:
#     version: master
#     service: github.com
#     organization: codesparta
    collector-operators:
      version: master
      organization: codesparta
      service: github.com
      env:
        - name: "VERSION"
          value: "candidate"
        - name: "MIRROR"
          value: "true"
        - name: "WALLE"
          value: "true"
        - name: "BUNDLE"
          value: "true"
        - name: "CATALOG_MIRROR"
          value: "localhost:5000"
        - name: "REDHAT_OPERATORS"
          value: "kiali-ossm,ocs-operator,quay-operator,jaeger-product,rhsso-operator,cluster-logging,servicemeshoperator,compliance-operator,elasticsearch-operator"
        - name: "CERTIFIED_OPERATORS"
          value: "null"
        - name: "COMMUNITY_OPERATORS"
          value: "null"
        - name: "MARKET_OPERATORS"
          value: "null"
EOF
}

run_koffer () {
mkdir -p ${runPath}/bundle && \
sudo podman run \
    -it --rm --privileged --device /dev/fuse \
    --volume ${runPath}/bundle:/root/bundle:z \
    --volume ${runPath}/koffer.yml:/root/.koffer/config.yml:z \
    --volume ${runPath}/pull-secret.json:/root/.docker/config.json:z \
  quay.io/cloudctl/koffer:extra bundle
}
run () {
  podman pull quay.io/cloudctl/koffer:extra
  write_config
  run_koffer
}
run
