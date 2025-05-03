# modules/rds/variables.tf
variable "subnet_ids" {
  description = "List of subnet IDs for the DB subnet group"
  type        = list(string)
}

variable "db_subnet_group_name" {
  description = "The subnet group name for the DB instance"
  type        = string
}

variable "db_name" {
  description = "The name of the database"
  type        = string
}

variable "db_identifier" {
  description = "The identifier of the DB instance"
  type        = string
}

variable "db_instance_class" {
  description = "The instance class for the DB instance"
  type        = string
}

variable "db_engine" {
  description = "The database engine"
  type        = string
}

variable "db_engine_version" {
  description = "The engine version of the database"
  type        = string
}

variable "db_username" {
  description = "The username for the DB instance"
  type        = string
}

variable "db_password" {
  description = "The password for the DB instance"
  type        = string
}

variable "db_port" {
  description = "The port for the DB instance"
  type        = number
}

variable "db_allocated_storage" {
  description = "The allocated storage in GB"
  type        = number
}

variable "security_group_id" {
  description = "The security group ID to associate with the DB instance"
  type        = string
}

variable "multi_az" {
  description = "Whether to deploy the DB instance in multiple availability zones"
  type        = bool
}
