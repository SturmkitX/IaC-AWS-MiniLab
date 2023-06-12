resource "aws_elb" "elb-01" {
  name = "kube-elb-01"

  listener {
    instance_port     = 30694
    instance_protocol = "tcp"
    lb_port           = 80
    lb_protocol       = "tcp"
  }

  listener {
    instance_port     = 31612
    instance_protocol = "tcp"
    lb_port           = 443
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:30694"
    interval            = 30
  }

  instances                   = [ aws_instance.kube-worker-01.id, aws_instance.kube-worker-02.id ]
  idle_timeout                = 300
  subnets                     = [ data.terraform_remote_state.vpc.outputs.kube_subnet_id ]
  security_groups             = [ aws_security_group.kube-elb-01-sg.id ]
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name  =   "kube-elb-01"
  }
}

resource "aws_security_group" "kube-elb-01-sg" {
  name    = "kube-elb-01-sg"
  vpc_id  = data.terraform_remote_state.vpc.outputs.kube_vpc_id

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

output "kube-elb-01-dns" {
  description = "Kube ELB DNS Name"
  value       = aws_elb.elb-01.dns_name
}