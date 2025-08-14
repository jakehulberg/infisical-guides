# Sync to GitHub repository secrets (CI/CD)
resource "infisical_secret_sync_github" "ci_secrets" {
  count = var.enable_github_sync ? 1 : 0
  
  workspace_id = var.project_id
  env_slug     = var.environment
  folder_path  = "/ci-cd"
  
  # REQUIRED: GitHub app connection
  app_connection_id = var.github_connection_id
  
  # Target repository
  github_owner = var.github_owner
  github_repo  = var.github_repository
  
  # Secret scope
  secret_scope = "repository"
  
  # Only sync CI/CD secrets
  secret_whitelist = [
    "DOCKER_REGISTRY_TOKEN",
    "NPM_TOKEN", 
    "DEPLOY_KEY"
  ]
}

