resource "aws_instance" "kube-worker-01" {
  ami           = "ami-064087b8d355e9051"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.kube-subnet-01.id
  key_name      = aws_key_pair.kube-ssh-keypair-01.key_name

  tags = {
    Name = "kube-worker-01"
    Role = "Kubernetes Worker Node"
  }
}

resource "aws_instance" "kube-worker-02" {
  ami           = "ami-064087b8d355e9051"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.kube-subnet-01.id
  key_name      = aws_key_pair.kube-ssh-keypair-01.key_name

  tags = {
    Name = "kube-worker-02"
    Role = "Kubernetes Worker Node"
  }
}

