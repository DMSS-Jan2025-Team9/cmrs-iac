variable "ec2_instances" {
  description = "List of EC2 instances with configurations"
  type = list(object({
    instance_name     = string
    ami_id            = string
    instance_type     = string
    key_name          = string
    subnet_name       = string
    security_groups   = list(string)
    availability_zone = string
  }))
}

variable "subnet_ids_map" {
  description = "A map of subnet names to subnet IDs"
  type        = map(string)
}

variable "security_group_ids_map" {
  description = "A map of security group names to security group IDs"
  type        = map(string)
}