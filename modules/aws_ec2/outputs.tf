output "instance_id" {
  value = aws_instance.main.id
}
output "instance_ip_address" {
  value = aws_eip.EIP.public_ip
}
