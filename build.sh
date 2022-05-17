#!/bin/bash

VERSION=0.1.3

# Create the helm package
helm package ./vmware-cluster/

# move the helm package to the helm repo
mv ./vmware-cluster-$VERSION.tgz ./helm-charts/

# Make the index.yaml file
helm repo index ./helm-charts/



# Debug the chart 
helm install  vmware-cluster ./vmware-cluster/  --values /./values-custom.yaml --dry-run --debug


# Install the chart
helm install  example-cluster ./vmware-cluster/  --values ./values-custom.yaml