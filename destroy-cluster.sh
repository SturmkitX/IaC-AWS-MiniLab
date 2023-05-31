#!/bin/bash

pushd kube-cluster/terraform-kube
terraform destroy -auto-approve
popd

pushd terraform-common
terraform destroy -auto-approve
popd

if [[ $DELETE_PREREQ = 'yes' ]]
then
    pushd terraform-prerequisites
    terraform destroy -auto-approve
    popd
fi

echo ''
echo 'Everything should be destroyed now'
