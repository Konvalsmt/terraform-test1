variable "azs" {
     type=list(string)
     default=["us-east-1"]
}
variable "public_subnets" {
        type=list(string)
     default=["10.10.1.0/24"]
}
variable "cidr" {
    type =string
}
variable "name" {
    type =string
}
variable "private_subnets" {
        type=list(string)
      default=["10.10.2.0/24"]
}
# end of variables.tf
