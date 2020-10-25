resource "aws_vpc" "my_vpc" {
  cidr_block       = var.cidr
  enable_dns_hostnames = true

  tags = {
    Name = "My VPC"
  }
}

resource "aws_subnet" "public1" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.public_subnets[0]
  availability_zone = var.azs[0]

  tags = {
    Name = "Public Subnet1"
  }
}

resource "aws_subnet" "public2" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.public_subnets[1]
  availability_zone = var.azs[1]

  tags = {
    Name = "Public Subnet2"
  }
}

resource "aws_subnet" "private1" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.private_subnets[0]
  availability_zone = var.azs[0]

  tags = {
    Name = "Private Subnet1"
  }
}

resource "aws_subnet" "private2" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.private_subnets[1]
  availability_zone = var.azs[1]

  tags = {
    Name = "Private Subnet2"
  }
}


resource "aws_internet_gateway" "my_vpc_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "My VPC - Internet Gateway"
  }
}

resource "aws_route_table" "my_vpc_public" {
    vpc_id = aws_vpc.my_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my_vpc_igw.id
    }

    tags = {
        Name = "Public Subnets Route Table for My VPC"
    }
}

resource "aws_route_table" "my_vpc_private" {
    vpc_id = aws_vpc.my_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my_vpc_igw.id
    }

    tags = {
        Name = "Public Subnets Route Table for My VPC"
    }
}

resource "aws_route_table_association" "my_vpc_us_east_1a_public" {
    subnet_id = aws_subnet.public1.id
    route_table_id = aws_route_table.my_vpc_public.id
}

resource "aws_route_table_association" "my_vpc_us_east_1b_public" {
    subnet_id = aws_subnet.public2.id
    route_table_id = aws_route_table.my_vpc_public.id
}

# Creating an Elastic IP for the NAT Gateway!
resource "aws_eip" "EIP" {
  depends_on = [
    aws_route_table_association.my_vpc_us_east_1a_public
  ]
  vpc = true
}

# Creating a NAT Gateway!
resource "aws_nat_gateway" "NAT_GATEWAY" {
  depends_on = [
    aws_eip.EIP
  ]

  # Allocating the Elastic IP to the NAT Gateway!
  allocation_id = aws_eip.EIP.id
  
  # Associating it in the Public Subnet!
  subnet_id = aws_subnet.public1.id
  tags = {
    Name = "Nat-Gateway_Project"
  }
}
