resource "aws_elb" "elb-01" {
    name = "kube-elb-01"

    listener {
      instance_port     = 30243
      instance_protocol = "http"
      lb_port           = 80
      lb_protocol       = "http"
    }

    listener {
      instance_port     = 30246
      instance_protocol = "https"
      lb_port           = 443
      lb_protocol       = "https"
    }

    instances       = [ aws_instance.kube-worker-01.id, aws_instance.kube-worker-02.id ]
    idle_timeout    = 300
    subnets         = [ aws_subnet.kube-subnet-01.id ]

    tags = {
      Name  =   "kube-elb-01"
    }
}