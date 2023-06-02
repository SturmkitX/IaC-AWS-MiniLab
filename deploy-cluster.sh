#!/bin/bash

# A wrapper script to run all helper scripts
# In order to create cluster in one command

# Deploy prerequisites
pushd terraform-prerequisites
terraform init
terraform apply -auto-approve
popd

# Deploy common components
pushd terraform-common
terraform init
terraform apply -auto-approve
popd

# Deploy infrastructure
pushd kube-cluster/terraform-kube
terraform init
terraform apply -auto-approve
bash ./generate.sh
popd

# Configure cluster
pushd kube-cluster/ansible-kube
bash ./generate.sh
popd

# Update DNS
pushd kube-cluster/terraform-kube
bash ./configure-dns.sh
popd

echo ''
echo 'Everything should be configured now. Enjoy'
