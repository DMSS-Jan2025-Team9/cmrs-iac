output "scaling_policy_arn" {
  value = aws_appautoscaling_policy.cpu_policy.arn
}