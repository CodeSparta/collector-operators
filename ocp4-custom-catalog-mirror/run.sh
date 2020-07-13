#!/bin/bash -x
./mirror-operator-catalogue.py \
--catalog-version 1.0.0 \
--authfile /root/.docker/config.json \
--registry-olm localhost:5000 \
--registry-catalog localhost:5000 \
--operator-file ./offline-operator-list \
--icsp-scope=namespace
