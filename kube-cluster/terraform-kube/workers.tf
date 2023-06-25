resource "aws_security_group" "kube-worker-sg" {
  name    = "kube-worker-sg-01"
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
    description      = "Kubelet API"
    from_port        = 10250
    to_port          = 10250
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Kube Nodeport Services"
    from_port        = 30000
    to_port          = 32767
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

resource "aws_network_interface" "kuber-worker-01-nic" {
  subnet_id = data.terraform_remote_state.vpc.outputs.kube_subnet_id
  security_groups = [aws_security_group.kube-worker-sg.id]
}

resource "aws_network_interface" "kuber-worker-02-nic" {
  subnet_id = data.terraform_remote_state.vpc.outputs.kube_subnet_id
  security_groups = [aws_security_group.kube-worker-sg.id]
}

resource "aws_instance" "kube-worker-01" {
  ami           = "ami-064087b8d355e9051"
  instance_type = "t3.medium"

  network_interface {
    network_interface_id  = aws_network_interface.kuber-worker-01-nic.id
    device_index          = 0
  }

  root_block_device {
    delete_on_termination = true
    volume_type = "gp2"
    volume_size = 60
  }

  key_name      = data.terraform_remote_state.vpc.outputs.kube_key_name

  tags = {
    Name = "kube-worker-01"
    Role = "Kubernetes Worker Node"
  }

  # depends_on = [ aws_internet_gateway.kube-vpc-gw-01 ]
}

resource "aws_instance" "kube-worker-02" {
  ami           = "ami-064087b8d355e9051"
  instance_type = "t3.medium"

  network_interface {
    network_interface_id  = aws_network_interface.kuber-worker-02-nic.id
    device_index          = 0
  }

  root_block_device {
    delete_on_termination = true
    volume_type = "gp2"
    volume_size = 60
  }

  key_name      = data.terraform_remote_state.vpc.outputs.kube_key_name

  tags = {
    Name = "kube-worker-02"
    Role = "Kubernetes Worker Node"
  }

  # depends_on = [ aws_internet_gateway.kube-vpc-gw-01 ]
}

