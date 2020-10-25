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




resource "aws_instance" "main" {
  ami                    = lookup(var.ami_ids, var.region)
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.main.id]
  subnet_id  = var.subnet_id
  associate_public_ip_address = true
  tags = {
    Name = var.instance_name
  }
  key_name="virtu"
}


resource "aws_eip" "EIP" {
  vpc = true
  instance                  = aws_instance.main.id
  depends_on                = [var.igw]
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.main.id
  allocation_id = aws_eip.EIP.id
}


