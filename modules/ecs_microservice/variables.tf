variable "service_name" {
  description = "The name of the ECS service"
  type        = string
}

# Container image (e.g., ecr-repository-url:tag)
variable "container_image" {
  description = "The Docker image URI for the ECS task"
  type        = string
}

# Container port (port on which the container listens)
variable "container_port" {
  description = "The port on which the container listens"
  type        = number
}

# CPU and memory allocations for the ECS task
variable "cpu" {
  description = "The number of CPU units to allocate to the task"
  type        = number
}

variable "memory" {
  description = "The amount of memory (in MiB) to allocate to the task"
  type        = number
}

# Desired task instances for ECS service (for scaling)
variable "desired_count" {
  description = "The number of desired tasks to run for the ECS service"
  type        = number
}

# List of subnets for the ECS service
variable "subnets" {
  description = "List of subnets to deploy the ECS service"
  type        = list(string)
}

# List of security group IDs for the ECS service
variable "security_group_ids" {
  description = "A list of security group IDs to associate with the ECS service"
  type        = list(string)
}

# IAM Role ARN to execute ECS tasks (execution role)
variable "execution_role_arn" {
  description = "The ARN of the IAM role for ECS task execution"
  type        = string
}

# ECS Cluster ID to associate the service with
variable "ecs_cluster_id" {
  description = "The ID of the ECS cluster to run the service in"
  type        = string
}

# Log Group Name for CloudWatch Logs (e.g., /ecs/service-name)
variable "log_group_name" {
  description = "The CloudWatch log group for ECS task logging"
  type        = string
}

# AWS Region (can also be used for setting up the log stream)
variable "aws_region" {
  description = "The AWS region to deploy the ECS service"
  type        = string
}

# health check configuration of the microservice
variable "healthCheck" {
  description = "health check configuration of the microservice"
  type        = object({                  
      interval      = number
      timeout       = number
      retries       = number
      startPeriod   = number
  })
}

variable "target_group_arn" {
  description = "Target group arns by port number"
  type = string
}

variable "enable_service_connect" {
  type    = bool
  default = false
}

variable "service_connect_namespace" {
  type    = string
  default = "default"
}