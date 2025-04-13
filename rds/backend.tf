terraform {
    backend "s3" {
        bucket         = "cmrs-terraform-state"
        key            = "rds/terraform.tfstate"
        region         = "ap-southeast-1"  # specify your AWS region
        encrypt        = true
  }
}