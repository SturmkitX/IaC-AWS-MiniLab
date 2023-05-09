terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-north-1"
}

resource "aws_vpc" "kube-vpc-01" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "kube-vpc-01"
  }
}

resource "aws_subnet" "kube-subnet-01" {
  vpc_id                  = aws_vpc.kube-vpc-01.id
  cidr_block              = "172.16.50.0/28"
  map_public_ip_on_launch = true

  tags = {
    Name = "kube-subnet-01"
  }
}


resource "aws_instance" "kube-master-01" {
  ami           = "ami-064087b8d355e9051"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.kube-subnet-01.id
  key_name      = aws_key_pair.kube-ssh-keypair-01.key_name

  tags = {
    Name = "kube-master-01"
    Role = "Kubernetes Master Node"
  }
}

