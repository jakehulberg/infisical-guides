output "project_id" {
  value       = infisical_project.main.id
  description = "The ID of the created project"
}

output "project_slug" {
  value       = infisical_project.main.slug
  description = "The slug of the created project"
}

output "environments" {
  value       = local.environments
  description = "List of configured environments"
}