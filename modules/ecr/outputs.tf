output "repository_uris" {
  description = "The URIs of the ECR repositories"
  value       = { for repo_name, repo in aws_ecr_repository.this : repo_name => repo.repository_url }
}