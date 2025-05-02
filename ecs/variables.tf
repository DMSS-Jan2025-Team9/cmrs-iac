variable "aws_profile" {
  description = "cmrs-aws"
  type        = string
}

variable "aws_region" {
  description = "ap-southeast-1"
  type        = string
}

variable "ecr_name" {
  default = "cmrs-ecr-repo"
  type = string
}
