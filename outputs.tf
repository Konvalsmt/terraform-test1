  
output "my_vpc_id" {
  value = "${module.aws_vpc.my_vpc_id}"  
}
output "public_us_east_1b_id" {
  value ="${module.aws_vpc.public_us_east_1b_id}"  
}
output "public_us_east_1a_id" {
  value = "${module.aws_vpc.public_us_east_1b_id}"
}
output "instance_ip_address" {
  value = "${module.aws_ec2.instance_ip_address}"
}
