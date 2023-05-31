#!/bin/bash

pushd ../../terraform-prerequisites/

PROMETHEUS_VOLID=$(terraform output -raw kube-worker-01-ip)
GRAFANA_VOLID=$(terraform output -raw kube-worker-02-ip)

popd

ansible-playbook -i hosts install-k8s.yaml --key-file ../../ssh-keys/aws
ansible-playbook -i hosts config-master.yaml --key-file ../../ssh-keys/aws
ansible-playbook -i hosts config-worker.yaml --key-file ../../ssh-keys/aws
ansible-playbook -i hosts install-misc.yaml --key-file ../../ssh-keys/aws --extra-vars "prometheus_volume_id=$PROMETHEUS_VOLID grafana_volume_id=$GRAFANA_VOLID"

