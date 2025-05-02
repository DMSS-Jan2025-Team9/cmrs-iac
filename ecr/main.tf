provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

resource "aws_ecr_repository" "my_ecr_repo" {
  name                 = var.ecr_name
  image_tag_mutability = "IMMUTABLE"  
  image_scanning_configuration {
    scan_on_push = true
  }
}