provider "aws" {
  region = "ap-southeast-1"
}

module "backend_state" {
  source         = "../../modules/backend_state"
  bucket_name    = "cmrs-terraform-state"
  dynamodb_table = "app-state"
}