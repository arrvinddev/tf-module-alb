resource "aws_security_group" "sg" {
  name        = "${var.name}-alb-${var.env}-sg"
  description = "${var.name}-alb-${var.env}-sg"
  vpc_id      = var.vpc_id

  ingress {

  description = "HTTP"
  from_port         = 80
  protocol       = "tcp"
  to_port           = 80
  cidr_blocks = var.allow_alb_cidr

  }

  

  egress {

  
  from_port         = 0
  protocol       = "-1"
  to_port           = 0
  cidr_blocks = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]


  }

  tags =  merge(var.tags, {Name= "${var.name}-alb-${var.env}-sg"})
}


resource "aws_lb" "main" {
  name = "${var.name}-alb-${var.env}"
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg.id]
  subnets            = var.subnets

  

  

  tags =  merge(var.tags, {Name= "${var.name}-alb-${var.env}"})
}



resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"
  # ssl_policy        = "ELBSecurityPolicy-2016-08"
  # certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Unauthorized"
      status_code  = "403"
    }
  }
}

