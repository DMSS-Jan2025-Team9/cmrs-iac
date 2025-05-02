variable "vpc_ids_map" {
  description = "A map of VPC names to VPC IDs"
  type        = map(string)
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