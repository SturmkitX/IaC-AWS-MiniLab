# About
This repository is intended to host all the files necessary for deploying AWS resources and configuring them in order to contain a Kubernetes cluster (1 master & 2 worker nodes)

## How to run
Just run the ``` deploy-cluster.sh ``` command and it should work. You need the following Environment variables set:
```
export AWS_ACCESS_KEY_ID=<AWS_ACCESS_KEY_ID>
export AWS_SECRET_ACCESS_KEY=<AWS_SECRET_ACCESS_KEY>
export CLOUDFLARE_TOKEN=<CLOUDFLARE_DNS_EDIT_TOKEN>
```

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

### Advanced networking & monitoring
- [X] Add demo nginx application
- [X] Add Prometheus & Grafana deployments
- [X] Add Ingress controller (using nginx-ingress-controller)
- [X] Add ALB resource for load balancing the web application (currently using a classic EC2 load balancer - ELB)
- [X] Add record for ALB in domain DNS server (managed externally)


## Future improvements
- [X] Create script to execute ansible playbooks
- [X] Add script to execute all steps necessary to create a working cluster with Ingress (see deploy-cluster.sh)
- [ ] Add ansible task to copy kube-config file from master node & edit for external use
- [ ] Add persistent storage for pods
- [ ] Add support for LoadBalancer resources (see the [MetalLB project](https://metallb.universe.tf/), then go to Installation page; in this case, nginx-ingress-controller can be switched to the cloud variant, but it should not interfere with the baremetal implementation which uses NodePort)
- [ ] Create an ECR to store a custom image to show the running host
- [ ] Migrate to Terragrunt for eliminating duplicate code
