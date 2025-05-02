variable "vpc_ids_map" {
  description = "A map of VPC names to VPC IDs"
  type        = map(string)
}

variable "igw_parameters" {
  description = "IGW parameters"
  type = map(object({
    vpc_name = string
    tags     = optional(map(string), {})
  }))
  default = {}
}