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
    path = "../../terraform-common"
  }
}

resource "aws_security_group" "jenkins-master-sg" {
  name    = "jenkins-master-sg"
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
    description      = "Jenkins Default HTTP Port"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_network_interface" "jenkins-master-nic" {
  subnet_id = data.terraform_remote_state.vpc.outputs.kube_subnet_id
  security_groups = [aws_security_group.jenkins-master-sg.id]
}

resource "aws_instance" "kube-master-01" {
  ami           = "ami-064087b8d355e9051"
  instance_type = "t3.micro"

  network_interface {
    network_interface_id  = aws_network_interface.jenkins-master-nic.id
    device_index          = 0
  }

  root_block_device {
    delete_on_termination = true
    volume_type = "gp2"
    volume_size = 20
  }

  key_name      = data.terraform_remote_state.vpc.outputs.kube_key_name

  tags = {
    Name = "jenkins-master-01"
    Role = "Jenkins Master Node"
  }

#   depends_on = [ aws_internet_gateway.kube-vpc-gw-01 ]
}
