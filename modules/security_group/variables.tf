variable "vpc_ids_map" {
  description = "A map of VPC names to VPC IDs"
  type        = map(string)
}

variable "security_group_parameters" {
  description = "Security group parameters"
  type = map(object({
    name                   = string
    description            = string
    revoke_rules_on_delete = string
    vpc_name               = string  # Ensure vpc_name exists
    tags                   = optional(map(string), {})
    ingress = optional(list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      self        = bool
      cidr_blocks = list(string)
      description = string
    })), [])
    egress = optional(list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
      description = string
    })), [])
  }))
  default = {}
}
