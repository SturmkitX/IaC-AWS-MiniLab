output "kube-master-01-ip" {
    description = "Kube Master Node 1 Public IP"
    value       = aws_instance.kube-master-01.public_ip
}

output "kube-master-01-dns" {
    description = "Kube Master Node 1 Public DNS"
    value       = aws_instance.kube-master-01.public_dns
}

output "kube-worker-01-ip" {
    description = "Kube Worker Node 1 Public IP"
    value       = aws_instance.kube-worker-01.public_ip
}

output "kube-worker-01-dns" {
    description = "Kube Worker Node 1 Public DNS"
    value       = aws_instance.kube-worker-01.public_dns
}

output "kube-worker-02-ip" {
    description = "Kube Worker Node 2 Public IP"
    value       = aws_instance.kube-worker-02.public_ip
}

output "kube-worker-02-dns" {
    description = "Kube Worker Node 2 Public DNS"
    value       = aws_instance.kube-worker-02.public_dns
}

output "kube-elb-01-dns" {
    description = "Kube ELB DNS Name"
    value       = aws_elb.elb-01.dns_name
}
