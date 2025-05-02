variable "repositories" {
  description = "A map of repository configurations."
  type = map(object({
    repository_name      = string
    image_tag_mutability = string
    tags                 = map(string)
    lifecycle_policy     = optional(string)
  }))
}