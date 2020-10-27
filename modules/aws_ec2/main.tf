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

#----------------------
resource "aws_launch_configuration" "as_conf" {
  name_prefix   = "terraform-lc-example-"
  image_id      = "ami-06fc179f04400d5ec"
  instance_type = "t2.micro"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "my_asg" {
  name                 = "terraform-asg-example"
  launch_configuration = aws_launch_configuration.as_conf.name
  vpc_zone_identifier  = [var.public_1, var.public_2]
  min_size             = 1
  max_size             = 2
  
  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  metrics_granularity = "1Minute"
  
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_policy" "web_policy_up" {
  name = "web_policy_up"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = aws_autoscaling_group.my_asg.id
}

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.my_asg.id
  elb                    = aws_elb.web_elb.id
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


