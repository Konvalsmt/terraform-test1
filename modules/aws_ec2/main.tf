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
  tags = {
    Name = var.instance_name
  }
  key_name="virtu"
}

resource "aws_eip" "main" {
  instance = aws_instance.main.id
}



resource "aws_elb" "web_elb" {
  name = "web-elb"
  security_groups = [
    aws_security_group.main.id
  ]
  subnets = [
    var.public_1,
    var.public_2
  ]

  cross_zone_load_balancing   = true

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:80/"
  }

  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "80"
    instance_protocol = "http"
  }

}


