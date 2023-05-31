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

variable "availability_zone" {
  type        = string
  description = "AZ to deploy EBS to (other resource must be created in the same AZ)"
  default     = "eu-north-1b"
}

resource "aws_ebs_volume" "prometheus_volume" {
  availability_zone = var.availability_zone
  size              = 100

  tags = {
    Name = "prometheus-volume"
  }
}

resource "aws_ebs_volume" "grafana_volume" {
  availability_zone = var.availability_zone
  size              = 60

  tags = {
    Name = "grafana-volume"
  }
}

output "prometheus_volume_id" {
  description = "Prometheus EBS ID"
  value = aws_ebs_volume.prometheus_volume.id
}

output "grafana_volume_id" {
  description = "Grafana EBS ID"
  value = aws_ebs_volume.grafana_volume.id
}
