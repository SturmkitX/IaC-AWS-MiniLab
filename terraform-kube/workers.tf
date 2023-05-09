resource "aws_security_group" "kube-worker-sg" {
  name    = "kube-worker-sg-01"
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
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_network_interface" "kuber-worker-01-nic" {
  subnet_id = aws_subnet.kube-subnet-01.id
  security_groups = [aws_security_group.kube-worker-sg.id]
}

resource "aws_network_interface" "kuber-worker-02-nic" {
  subnet_id = aws_subnet.kube-subnet-01.id
  security_groups = [aws_security_group.kube-worker-sg.id]
}

resource "aws_instance" "kube-worker-01" {
  ami           = "ami-064087b8d355e9051"
  instance_type = "t3.micro"

  network_interface {
    network_interface_id  = aws_network_interface.kuber-worker-01-nic.id
    device_index          = 0
  }

  key_name      = aws_key_pair.kube-ssh-keypair-01.key_name

  tags = {
    Name = "kube-worker-01"
    Role = "Kubernetes Worker Node"
  }
}

resource "aws_instance" "kube-worker-02" {
  ami           = "ami-064087b8d355e9051"
  instance_type = "t3.micro"

  network_interface {
    network_interface_id  = aws_network_interface.kuber-worker-02-nic.id
    device_index          = 0
  }

  key_name      = aws_key_pair.kube-ssh-keypair-01.key_name

  tags = {
    Name = "kube-worker-02"
    Role = "Kubernetes Worker Node"
  }
}

