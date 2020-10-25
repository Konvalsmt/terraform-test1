
provider "aws" {
  profile = var.profile
  region  = var.region
}

module "aws_vpc" {
  source = "./modules/aws_vpc"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

}
  
module "aws_ec2" {
  vpc_id="${module.aws_vpc.my_vpc_id}" 
  public_1="${module.aws_vpc.public_us_east_1a_id}"
  public_2="${module.aws_vpc.public_us_east_1b_id}"
  subnet_id="${module.aws_vpc.public_us_east_1a_id}"
  igw="${module.aws_vpc.int_igw}"
  region="${var.region}" 
  source = "./modules/aws_ec2"
  instance_name = "my-ec2-inst"
  ami_ids= {
    us-east-1 = "ami-569d0529"
    us-east-2 = "ami-03b4f7f2a94c30c3d"
    eu-west-1 = "ami-06b154dd818778011"
  }
  type_inst ="t2.micro"
}
