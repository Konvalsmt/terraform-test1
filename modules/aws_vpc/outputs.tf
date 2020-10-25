output "my_vpc_id" {
  value = "${aws_vpc.my_vpc.id}"  
}
output "public_us_east_1b_id" {
  value ="${aws_subnet.public1.id}"  
}
output "public_us_east_1a_id" {
  value = "${aws_subnet.public2.id}"
}

output "int_igw" {
value = "${aws_internet_gateway.my_vpc_igw}"
  }
