resource "aws_ecr_repository" "this" {
  for_each = var.repositories  # Iterate over the repositories map

  name                 = each.value.repository_name
  image_tag_mutability = each.value.image_tag_mutability  # Set immutability
  
  lifecycle {
    prevent_destroy = true  # Prevent the repository from being accidentally destroyed
  }

  tags = merge(each.value.tags, {
    Name = each.key  # This will use the key of the map as the resource name tag
  })
}

resource "aws_ecr_lifecycle_policy" "this" {
  for_each = { # Iterate over the repositories map
    for k, v in var.repositories :
    k => v if v.lifecycle_policy != null
  }

  repository = aws_ecr_repository.this[each.key].name # Reference the created ECR repository
  policy     = each.value.lifecycle_policy  # Apply lifecycle policy from the input variable
}