variable "rabbitmq_config" {
  description = "RabbitMQ broker configuration"
  type = object({
    broker_name        = string
    engine_version     = string
    host_instance_type = string
    deployment_mode    = string
    subnets         = list(string)
    publicly_accessible = bool
    security_groups = list(string)
    username           = string
    password           = string
    configuration_data = string
    maintenance_window = object({
      day     = string
      time    = string
      timezone = string
    })
  })
  sensitive = true
}


variable "subnet_ids_map" {
  description = "A map of subnet names to subnet IDs"
  type        = map(string)
}

variable "security_group_ids_map" {
  description = "A map of security group names to security group IDs"
  type        = map(string)
}