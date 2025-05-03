variable "ecs_cluster_name" {
  type        = string
  description = "The name of the ECS cluster"
}

variable "service_name" {
  type        = string
  description = "Name of the ECS service to scale"
}

variable "min_capacity" {
  type        = number
  description = "Minimum number of ECS tasks"
}

variable "max_capacity" {
  type        = number
  description = "Maximum number of ECS tasks"
}

variable "cpu_target_value" {
  type        = number
  description = "Target CPU utilization percentage"
}