#!/bin/bash

ansible-playbook -i hosts install-k8s.yaml --key-file ../../ssh-keys/aws
ansible-playbook -i hosts config-master.yaml --key-file ../../ssh-keys/aws
ansible-playbook -i hosts config-worker.yaml --key-file ../../ssh-keys/aws
ansible-playbook -i hosts install-misc.yaml --key-file ../../ssh-keys/aws

