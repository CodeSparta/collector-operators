#!/bin/bash -x
./mirror.py \
--catalog-version 1.0.0 \
--authfile /root/.docker/config.json \
--registry-olm localhost:5000 \
--registry-catalog localhost:5000 \
--operator-file ./operators.list \
--output /root/deploy/mirror/config/operators \
--icsp-scope=namespace
