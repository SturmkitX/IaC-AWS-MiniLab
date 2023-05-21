#!/bin/bash

# A wrapper script to run all helper scripts
# In order to create cluster in one command

# Deploy infrastructure
pushd terraform-kube
terraform apply -auto-approve
bash ./generate.sh
popd

# Configure cluster
pushd ansible-kube
bash ./generate.sh
popd

# Update DNS
pushd terraform-kube
bash ./configure-dns.sh
popd

echo 'Everything should be configured now. Enjoy'
