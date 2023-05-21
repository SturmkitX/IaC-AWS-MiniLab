#!/bin/bash

MASTER_IP=$(terraform output -raw kube-master-01-ip)
WORKER01_IP=$(terraform output -raw kube-worker-01-ip)
WORKER02_IP=$(terraform output -raw kube-worker-02-ip)

cat hosts-template | sed "s/MASTERIP/$MASTER_IP/" | sed "s/WORKER1IP/$WORKER01_IP/" | sed "s/WORKER2IP/$WORKER02_IP/" > ../ansible-kube/hosts

