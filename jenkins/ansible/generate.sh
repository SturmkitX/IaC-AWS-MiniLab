#!/bin/bash

ansible-playbook -i hosts install-master.yaml --key-file ../../ssh-keys/aws
