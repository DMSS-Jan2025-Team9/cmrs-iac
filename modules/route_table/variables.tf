variable "vpc_ids_map" {
  description = "A map of VPC names to VPC IDs"
  type        = map(string)
}

variable "subnet_ids_map" {
  description = "A map of subnet names to subnet IDs"
  type        = map(string)
}

variable "igw_ids_map" {
  description = "A map of internet gateway names to internet gateway IDs"
  type        = map(string)
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