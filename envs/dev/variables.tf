variable "vpc_parameters" {
  description = "VPC parameters"
  type = map(object({
    cidr_block           = string
    enable_dns_support   = optional(bool, true)
    enable_dns_hostnames = optional(bool, true)
    tags                 = optional(map(string), {})
  }))
  default = {}
}

variable "subnet_parameters" {
  description = "Subnet parameters"
  type = map(object({
    cidr_block = string
    vpc_name   = string
    availability_zone = string
    map_public_ip_on_launch = bool
    tags       = optional(map(string), {})
  }))
  default = {}
}

variable "igw_parameters" {
  description = "IGW parameters"
  type = map(object({
    vpc_name = string
    tags     = optional(map(string), {})
  }))
  default = {}
}


variable "rt_parameters" {
  description = "RT parameters"
  type = map(object({
    vpc_name = string
    tags     = optional(map(string), {})
    routes = optional(list(object({
      cidr_block = string
      use_igw    = optional(bool, true)
      gateway_name = string
    })), [])
  }))
  default = {}
}
variable "rt_association_parameters" {
  description = "RT association parameters"
  type = map(object({
    subnet_name = string
    rt_name     = string
  }))
  default = {}
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
