resource "aws_instance" "kube-worker-01" {
  ami           = "ami-064087b8d355e9051"
  instance_type = "t3.micro"

  tags = {
    Name = "kube-worker-01"
    Role = "Kubernetes Worker Node"
  }
}

resource "aws_instance" "kube-worker-02" {
  ami           = "ami-064087b8d355e9051"
  instance_type = "t3.micro"

  tags = {
    Name = "kube-worker-02"
    Role = "Kubernetes Worker Node"
  }
}

