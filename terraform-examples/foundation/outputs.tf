output "project_id" {
  value       = infisical_project.main.id
  description = "The ID of the created project"
}

output "project_slug" {
  value       = infisical_project.main.slug
  description = "The slug of the created project"
}

output "environments" {
  value       = var.environments
  description = "List of configured environments"
}

output "tag_ids" {
  value = {
    for key, tag in infisical_secret_tag.tags : key => tag.id
  }
  description = "Map of tag names to their IDs"
}

# Machine Identity Outputs
output "ci_cd_credentials" {
  value = var.create_machine_identities ? {
    client_id     = infisical_identity_universal_auth.ci_cd[0].client_id
    client_secret = infisical_identity_universal_auth_client_secret.ci_cd[0].client_secret
  } : null
  sensitive   = true
  description = "CI/CD machine identity credentials"
}

output "service_identities" {
  value = var.create_machine_identities ? {
    for key, identity in infisical_identity.services : key => {
      identity_id = identity.id
      client_id   = infisical_identity_universal_auth.services[key].client_id
    }
  } : {}
  description = "Service machine identity details"
}