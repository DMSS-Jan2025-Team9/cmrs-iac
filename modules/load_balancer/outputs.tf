output "alb_arn" {
  value = aws_alb.application_load_balancer.arn
}

output "target_group_arns" {
  description = "Map of ECS service names to their Target Group ARNs"
  value = { for svc_name, tg in aws_lb_target_group.target_groups : svc_name => tg.arn }
}