#aws autoscaling attach-instances --instance-ids i-93633f9b --auto-scaling-group-name my-auto-scaling-group
resource "aws_security_group" "main" {
  name        = "allow_http"
  description = "Allow HTTP inbound connections"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
    ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow HTTP Security Group"
  }
}

resource "aws_launch_configuration" "web" {
  name_prefix = "web-"

  image_id = lookup(var.ami_ids, var.region)
  instance_type = "t2.micro"
  key_name="virtu"

  security_groups =[aws_security_group.main.id]
  associate_public_ip_address = true
  

  lifecycle {
    create_before_destroy = true
  }
}



resource "aws_internet_gateway" "gw" {
  vpc_id = var.vpc_id
}
resource "aws_eip" "EIP" {
  vpc = true
  instance                  = aws_launch_configuration.web.id
  depends_on                = [aws_internet_gateway.gw]
}



