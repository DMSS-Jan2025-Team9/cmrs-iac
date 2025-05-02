variable "service_name"       { type = string }
variable "container_image"    { type = string }
variable "container_port"     { type = number }
variable "cpu"                { type = number }
variable "memory"             { type = number }
variable "desired_count"      { type = number }

variable "subnets"            { type = list(string) }

variable "security_group_ids" {
  description = "A list of security group IDs for the ECS service"
  type        = list(string)
}
variable "execution_role_arn" { type = string }
variable "ecs_cluster_id"     { type = string }