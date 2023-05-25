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
  cidr_block              = "172.16.50.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "kube-subnet-01"
  }
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
