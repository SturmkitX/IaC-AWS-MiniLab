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
  cidr_block            = "172.16.0.0/16"
  enable_dns_hostnames  = true

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

resource "aws_security_group" "kube-master-sg" {
  name    = "kube-master-sg-01"
  vpc_id  = aws_vpc.kube-vpc-01.id

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

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_network_interface" "kuber-master-01-nic" {
  subnet_id = aws_subnet.kube-subnet-01.id
  security_groups = [aws_security_group.kube-master-sg.id]
}

resource "aws_internet_gateway" "kube-vpc-gw-01" {
  vpc_id = aws_vpc.kube-vpc-01.id

  tags = {
    Name = "kube-vpc-gw-01"
  }
}

resource "aws_route_table" "kube-route-01" {
  vpc_id = aws_vpc.kube-vpc-01.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.kube-vpc-gw-01.id
  }

  tags = {
    Name = "kube-route-table-01"
  }
}

resource "aws_route_table_association" "kube-route-assoc-01" {
  subnet_id = aws_subnet.kube-subnet-01.id
  route_table_id = aws_route_table.kube-route-01.id
}

resource "aws_instance" "kube-master-01" {
  ami           = "ami-064087b8d355e9051"
  instance_type = "t3.medium"

  network_interface {
    network_interface_id  = aws_network_interface.kuber-master-01-nic.id
    device_index          = 0
  }

  key_name      = aws_key_pair.kube-ssh-keypair-01.key_name

  tags = {
    Name = "kube-master-01"
    Role = "Kubernetes Master Node"
  }

  depends_on = [ aws_internet_gateway.kube-vpc-gw-01 ]
}

