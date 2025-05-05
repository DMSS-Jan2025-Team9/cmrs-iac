variable "load_balancer_config" {
  type = object({
    alb_name                  = string
    subnets                   = list(string)
    security_groups           = list(string)
    vpc_name                  = string
    acm_arn           = optional(string)
  })
}

variable "vpc_ids_map" {
  description = "A map of VPC names to VPC IDs"
  type        = map(string)
}

variable "subnet_ids_map" {
  description = "A map of subnet names to subnet IDs"
  type        = map(string)
}

variable "security_group_ids_map" {
  description = "A map of security group names to security group IDs"
  type        = map(string)
}

variable "ecs_services" {
  type = list(object({
    name        = string
    port        = number
    path_prefix = string
  }))
}