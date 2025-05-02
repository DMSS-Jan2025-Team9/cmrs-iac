output "ecs_task_execution_role_arn" {
  description = "The ARN of the ECS task execution role"
  value       = aws_iam_role.ecs_task_execution_role.arn
}

output "ecs_service_role_arn" {
  description = "The ARN of the ECS service role"
  value       = aws_iam_role.ecs_service_role.arn
}