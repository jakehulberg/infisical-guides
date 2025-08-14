# Single secret creation
resource "infisical_secret" "api_key" {
  name         = "API_KEY"
  value        = var.api_key_value
  env_slug     = "prod"
  workspace_id = var.project_id
  folder_path  = "/api"
  
  comment = "Main API authentication key"
}

# Create multiple secrets at once
resource "infisical_secret" "database_config" {
  for_each = {
    DB_HOST     = var.db_host
    DB_PORT     = var.db_port
    DB_NAME     = var.db_name
    DB_USER     = var.db_user
    DB_PASSWORD = var.db_password
  }
  
  name         = each.key
  value        = each.value
  env_slug     = "prod"
  workspace_id = var.project_id
  folder_path  = "/database"
  
  comment = "Database configuration"
}