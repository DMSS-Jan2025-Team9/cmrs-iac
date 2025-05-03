output "service_name" {
  description = "The name of the ECS service"
  value       = aws_ecs_service.this.name
}

output "service_id" {
  description = "The ID of the ECS service"
  value       = aws_ecs_service.this.id
}

output "task_definition_arn" {
  description = "The ARN of the ECS task definition"
  value       = aws_ecs_task_definition.this.arn
}

output "task_execution_role" {
  description = "The IAM execution role ARN for ECS tasks"
  value       = var.execution_role_arn
}