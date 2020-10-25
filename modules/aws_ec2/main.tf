#aws autoscaling attach-instances --instance-ids i-93633f9b --auto-scaling-group-name my-auto-scaling-group

resource "aws_security_group" "main" {
  description = "Managed by Terraform"
  vpc_id      = var.vpc_id
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


