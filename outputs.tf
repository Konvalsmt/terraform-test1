  
output "my_vpc_id" {
  value = "${module.aws_vpc.my_vpc.id}"  
}
output "public_us_east_1b_id" {
  value ="${module.aws_vpc.aws_subnet.public1.id}"  
}
output "public_us_east_1a_id" {
  value = "${module.aws_subnet.public2.id}"
}
