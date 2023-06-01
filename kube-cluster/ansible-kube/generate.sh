#!/bin/bash

pushd ../../terraform-prerequisites/

PROMETHEUS_VOLID=$(terraform output -raw prometheus_volume_id)
GRAFANA_VOLID=$(terraform output -raw grafana_volume_id)

popd

ansible-playbook -i hosts install-k8s.yaml --key-file ../../ssh-keys/aws
ansible-playbook -i hosts config-master.yaml --key-file ../../ssh-keys/aws
ansible-playbook -i hosts config-worker.yaml --key-file ../../ssh-keys/aws
ansible-playbook -i hosts install-misc.yaml --key-file ../../ssh-keys/aws --extra-vars "prometheus_volume_id=$PROMETHEUS_VOLID grafana_volume_id=$GRAFANA_VOLID aws_key_id=$AWS_ACCESS_KEY_ID aws_secret_key=$AWS_SECRET_ACCESS_KEY"

