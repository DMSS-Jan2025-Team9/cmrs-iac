variable "name" {
  description = "Name of the CloudWatch log group"
  type        = string
}

variable "retention_in_days" {
  description = "Number of days to retain logs"
  type        = number
  default     = 14
}

variable "tags" {
  description = "Tags for the log group"
  type        = map(string)
  default     = {}
}