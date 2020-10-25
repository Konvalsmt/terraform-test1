variable "region" {
     type=string
     default = "us-east-1"
}

variable "igw" {
}

variable "public_1" {
     type=string
     default = ""
}

variable "public_2" {
     type=string
     default = ""
}

variable "instance_name"  {
     type=string
     default = "my-ec2-inst"
}

variable "vpc_id"  {
     type=string
     default = ""
}
variable "ami_ids"  {
     type=map
     default = {
    us-east-1 = "ami-0947d2ba12ee1ff75"
    us-east-2 = "ami-03657b56516ab7912"
    eu-west-1 = "ami-0bb3fad3c0286ebd5"
  }
}

variable "type_inst" {
     type=string
     default = "t2.micro"
}
