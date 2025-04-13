variable "aws_profile" {
  description = "cmrs-aws"
  type        = string
}

variable "aws_region" {
  description = "ap-southeast-1"
  type        = string
}

variable "bucket_name" {
  default = "cmrs-frontend-hosting"
  type = string
}

variable "created_by" {
  default = "cmrs-iac" 
  type = string
}

variable "object_ownership" {
  default = "BucketOwnerPreferred"
  type = string
}