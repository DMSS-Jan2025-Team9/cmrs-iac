terraform {
    backend "s3" {
        bucket         = "cmrs-terraform-state"
        key            = "envs/dev/terraform.tfstate"
        region         = "ap-southeast-1"  # specify your AWS region
        encrypt        = true
        dynamodb_table = "app-state"
  }
}