variable "vpc_id" {
  description = "VPC ID for the load balancer"
  type        = string
}

variable "subnets" {
  description = "Subnets for the load balancer"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to load balancer resources"
  type        = map(string)
}

resource "aws_lb" "main" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.subnets
  tags               = var.tags
}

resource "aws_lb_target_group" "tg" {
  name     = "app-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  tags     = var.tags
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

output "load_balancer_dns" {
  value = aws_lb.main.dns_name
}
