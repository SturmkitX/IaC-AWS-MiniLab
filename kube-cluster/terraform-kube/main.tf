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

data "terraform_remote_state" "vpc" {
  backend = "local"

  config = {
    path = "../../terraform-common/terraform.tfstate"
  }
}

resource "aws_security_group" "kube-master-sg" {
  name    = "kube-master-sg-01"
  vpc_id  = data.terraform_remote_state.vpc.outputs.kube_vpc_id

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Ping"
    protocol         = "icmp"
    from_port        = -1
    to_port          = -1
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Kubernetes API Server"
    from_port        = 6443
    to_port          = 6443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "etcd server client API"
    from_port        = 2379
    to_port          = 2380
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Kubelet API"
    from_port        = 10250
    to_port          = 10250
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Kube-scheduler"
    from_port        = 10259
    to_port          = 10259
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Kube-controller-manager"
    from_port        = 10257
    to_port          = 10257
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "calico networking (BGP)"
    from_port        = 179
    to_port          = 179
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "calico networking with VXLAN"
    from_port        = 4789
    to_port          = 4789
    protocol         = "udp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  # ingress {
  #   description      = "calico networking with Typha"
  #   from_port        = 5473
  #   to_port          = 5473
  #   protocol         = "tcp"
  #   cidr_blocks      = ["0.0.0.0/0"]
  # }

  # ingress {
  #   description      = "calico networking IP-in-IP"
  #   protocol         = 4
  #   from_port        = -1
  #   to_port          = -1
  #   cidr_blocks      = ["0.0.0.0/0"]
  # }

  # ingress {
  #   description      = "flannel overlay udp"
  #   protocol         = "udp"
  #   from_port        = 8285
  #   to_port          = 8285
  #   cidr_blocks      = ["0.0.0.0/0"]
  # }

  # ingress {
  #   description      = "flannel overlay vxlan"
  #   protocol         = "udp"
  #   from_port        = 8472
  #   to_port          = 8472
  #   cidr_blocks      = ["0.0.0.0/0"]
  # }

  # ingress {
  #   description      = "metallb L2 UDP"
  #   protocol         = "udp"
  #   from_port        = 7946
  #   to_port          = 7946
  #   cidr_blocks      = ["0.0.0.0/0"]
  # }

  # ingress {
  #   description      = "metallb L2 TCP"
  #   protocol         = "tcp"
  #   from_port        = 7946
  #   to_port          = 7946
  #   cidr_blocks      = ["0.0.0.0/0"]
  # }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_network_interface" "kuber-master-01-nic" {
  subnet_id = data.terraform_remote_state.vpc.outputs.kube_subnet_id
  security_groups = [aws_security_group.kube-master-sg.id]
}

resource "aws_instance" "kube-master-01" {
  ami           = "ami-064087b8d355e9051"
  instance_type = "t3.medium"

  network_interface {
    network_interface_id  = aws_network_interface.kuber-master-01-nic.id
    device_index          = 0
  }

  root_block_device {
    delete_on_termination = true
    volume_type = "gp2"
    volume_size = 60
  }

  key_name      = data.terraform_remote_state.vpc.outputs.kube_key_name

  tags = {
    Name = "kube-master-01"
    Role = "Kubernetes Master Node"
  }

  # depends_on = [ aws_internet_gateway.kube-vpc-gw-01 ]
}

