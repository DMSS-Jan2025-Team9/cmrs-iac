resource "aws_alb" "application_load_balancer" {
  name               = var.load_balancer_config.alb_name
  internal           = false
  load_balancer_type = "application"
  subnets            = [for subnet_name in var.load_balancer_config.subnets : var.subnet_ids_map[subnet_name]] 
  security_groups    = [for sgrp in var.load_balancer_config.security_groups : var.security_group_ids_map[sgrp]] 
}

resource "aws_lb_target_group" "target_groups" {
  for_each = {
    for svc in var.ecs_services : svc.name => svc
  }

  name        = "tg-${each.key}"
  port        = each.value.port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = lookup(var.vpc_ids_map, var.load_balancer_config.vpc_name)   # Look up VPC ID using VPC name

  health_check {
    path                = each.value.health_check_path
    protocol            = "HTTP"
    matcher             = "200"
    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 60
    interval            = 300
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_alb.application_load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      protocol = "HTTPS"
      port     = "443"
      status_code = "HTTP_301"
    }
  }
}

# Define HTTPS listener on port 443 with an SSL/TLS certificate from ACM
resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_alb.application_load_balancer.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.load_balancer_config.acm_certificate_arn  # Must be provided

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<html><body><h1>Service Unavailable</h1><p>Please try again later.</p></body></html>"
      status_code  = "503"
    }
  }
}

resource "aws_lb_listener_rule" "service_routes" {
  for_each = {
    for svc in var.ecs_services : svc.name => svc
  }

  listener_arn = aws_lb_listener.https_listener.arn
  priority     = 100 + index(var.ecs_services[*].name, each.key)

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_groups[each.key].arn
  }

  condition {
    path_pattern {
      values = [each.value.path_prefix]
    }
  }
}
