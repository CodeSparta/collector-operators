export registry=reg.local:5000
export namespace=catalog
export custom_catalog_db=$registry/$namespace/redhat-operator-index:v4.6
export arch=linux/amd64

# podman run -p50051:50051 \
# -it registry.redhat.io/redhat/redhat-operator-index:v4.6

# install opm https://docs.openshift.com/container-platform/4.6/cli_reference/opm-cli.html#opm-cli
oc image extract registry.redhat.io/openshift4/ose-operator-registry:v4.6 \
-a auth.json \
--path /usr/bin/opm:. \
--confirm

# Prune full catalog to only desired list of operators
opm index prune \
-f registry.redhat.io/redhat/redhat-operator-index:v4.6 \
-p kubevirt-hyperconverged,local-storage-operator \
-t $registry/$namespace/redhat-operator-index:v4.6 \
--skip-tls

# Push Image & Run Custom Catalog
# podman push $custom_catalog_db --tls-verify=false
# sudo podman run -p50052:50052 -itd $custom_catalog_db

# Broken: validate custom catalog
# grpcurl -H "Authorization: Basic YWRtxA46YWRZbW4=" -plaintext reg.local:50052 api.Registry/ListPackages 

#Mirroring the related images
REG_CREDS=/root/.docker/config.json

oc adm catalog mirror \
${custom_catalog_db} \
${registry} \
-a "${REG_CREDS}" \
--insecure \
--filter-by-os="${arch}" \
--manifests-only 

# ON CLUSTER
# from https://docs.openshift.com/container-platform/4.6/operators/admin/olm-restricted-networks.html
# disable operatorhub sources 
#oc patch OperatorHub cluster --type json \
#-p '[{"op": "add", "path": "/spec/disableAllDefaultSources", "value": true}]'
