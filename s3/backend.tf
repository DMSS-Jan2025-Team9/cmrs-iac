terraform {
  backend "s3" {
    bucket         = "cmrs-terraform-state"
    key            = "s3/terraform.tfstate"
    region         = "ap-southeast-1"  # specify your AWS region
    encrypt        = true
  }
}