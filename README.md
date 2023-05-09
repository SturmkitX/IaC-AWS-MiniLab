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
- [ ] Disable swap, configure hostname, set system clock
- [ ] Deploy kubeadm
- [ ] Create Kubernetes nodes and register cluster


## Future improvements
- [ ] Add simple web app
- [ ] Add ALB resource for load balancing the web application
- [ ] Migrate to Terragrunt for eliminating duplicate code
