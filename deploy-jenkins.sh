#!/bin/bash

# Deploy common components
pushd terraform-common
terraform init
terraform apply -auto-approve
popd

# Deploy infrastructure
pushd jenkins/terraform
terraform init
terraform apply -auto-approve
bash ./generate.sh
popd

# Install jenkins software
pushd jenkins/ansible
bash ./generate.sh
popd

# Update DNS
pushd jenkins/terraform
bash ./configure-dns.sh
popd

echo ''
echo 'Everything should be configured now. Enjoy'
