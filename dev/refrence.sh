function oc_adm_catalog_mirror {
	echo "START:: oc adm catalog mirror"
	$OC adm catalog mirror localhost:5000/olm/redhat-operators:v1 localhost:5000 -a $LOCAL_SECRET_JSON --insecure
}

function oc_adm_catalog_build {
	echo "START:: oc adm catalog build"
	$OC adm catalog build \
              --from=registry.redhat.io/openshift4/ose-operator-registry:v4.3 \
              --to=${LOCAL_REGISTRY}/olm/redhat-operators:v1 \
              --appregistry-org redhat-operators \
              --filter-by-os="linux/amd64" \
              -a ${LOCAL_SECRET_JSON} \
              --insecure
}

