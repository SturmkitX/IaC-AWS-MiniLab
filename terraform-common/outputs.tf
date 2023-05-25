output "kube_vpc_id" {
  description = "Kubernetes VPC Id"
  value = aws_vpc.kube-vpc-01.id
}

output "kube_subnet_id" {
  description = "Kubernetes VPC Subnet Id"
  value = aws_subnet.kube-subnet-01.id
}

output "kube_key_name" {
  description = "SSH Access Key Pair"
  value = aws_key_pair.kube-ssh-keypair-01.key_name
}
