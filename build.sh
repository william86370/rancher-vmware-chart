#!/bin/bash

VERSION=0.1.0

# Create the helm package
helm package ./vmware-cluster/

# move the helm package to the helm repo
mv ./vmware-cluster-$VERSION.tgz ./helm-charts/

# Make the index.yaml file
helm repo index ./helm-charts/