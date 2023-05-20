resource "aws_elb" "elb-01" {
    name = "kube-elb-01"

    listener {
      instance_port     = 30243
      instance_protocol = "tcp"
      lb_port           = 80
      lb_protocol       = "tcp"
    }

    listener {
      instance_port     = 30246
      instance_protocol = "tcp"
      lb_port           = 443
      lb_protocol       = "tcp"
    }

    instances       = [ aws_instance.kube-worker-01.id, aws_instance.kube-worker-02.id ]
    idle_timeout    = 300
    subnets         = [ aws_subnet.kube-subnet-01.id ]
    security_groups = [ aws_security_group.kube-elb-01-sg.id ]

    tags = {
      Name  =   "kube-elb-01"
    }
}

resource "aws_security_group" "kube-elb-01-sg" {
  name    = "kube-elb-01-sg"
  vpc_id  = aws_vpc.kube-vpc-01.id

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "HTTPS"
    protocol         = "tcp"
    from_port        = 443
    to_port          = 443
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}