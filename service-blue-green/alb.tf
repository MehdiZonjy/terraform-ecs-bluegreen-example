resource "aws_lb" "service" {
  name = var.service_name
  internal = false
  security_groups = [aws_security_group.lb_service.id]
  subnets = var.lb_subnet_ids
  tags = var.tags
}


resource "aws_lb_listener" "service" {
  load_balancer_arn = aws_lb.service.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.blue.arn
    type             = "forward"
  }
  lifecycle {
    ignore_changes = [

    ]
  }

}


resource "aws_lb_target_group" "blue" {
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id

  target_type = "ip"
  health_check {
    interval = 20
    timeout = 10
    path = "/health"
    matcher = "200"
  }
  tags =var.tags
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group" "green" {
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id

  target_type = "ip"
  health_check {
    interval = 20
    timeout = 10
    path = "/health"
    matcher = "200"
  }
  tags =var.tags
  lifecycle {
    create_before_destroy = true
  }
}



resource "aws_security_group" "lb_service" {
  vpc_id = var.vpc_id
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags =var.tags
}