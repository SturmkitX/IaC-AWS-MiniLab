#!/bin/bash

MASTER_IP=$(terraform output -raw jenkins-master-ip)

cat hosts-template | sed "s/MASTERIP/$MASTER_IP/" > ../ansible/hosts
