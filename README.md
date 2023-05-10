# About

This repository is intended to host all the files necessary for deploying AWS resources and configuring them in order to contain a Kubernetes cluster (1 master & 2 worker nodes)

## Basics

The following need to be covered:

### Infrastructure deployment (Terraform)
- [X] Deploy custom VPC and subnet (include public IP and DNS entry)
- [X] Route tables and Internet Gateways
- [X] Security Groups (for control plane & worker nodes)
- [X] Deploy master, worker nodes and SSH public key for access (t3.medium should be minimum)

### Configuration provisioning (Ansible)
- [X] Disable swap, configure hostname, set system clock
- [X] Deploy kubeadm
- [X] Create Kubernetes nodes and register cluster


## Future improvements
- [X] Add simple web app and test NodePort connection (it works)
- [ ] Add ansible task to copy kube-config file from master node
- [ ] Create an ECR to store a custom image to show the running host
- [ ] Add ALB resource for load balancing the web application
- [ ] Create script to execute ansible playbooks (maybe later extend to Jenkins build)
- [ ] Migrate to Terragrunt for eliminating duplicate code
