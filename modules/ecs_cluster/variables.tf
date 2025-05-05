variable "cluster_name" {
  description = "The name of the ECS cluster"
  type        = string
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}

variable "vpc_ids_map" {
  description = "A map of VPC names to VPC IDs"
  type        = map(string)
}

variable "cluster_service_connect_defaults" {
  description = "Configures a default Service Connect namespace"
  type        = string
}