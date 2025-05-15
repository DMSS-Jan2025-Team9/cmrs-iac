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

variable "cloudfront_cdn_aliases" {
  type = list(string)
}

variable "cloudfront_cert_arn" {
  type = string
}

variable "cloudfront_min_protocol" {
  type = string
}

variable "cloudfront_ssl_supports" {
  type = string
}

variable "cache_policy_id" {
  type = string
}

variable "origin_request_policy_id" {
  type = string
}

variable "response_headers_policy_id" {
  type = string
}
