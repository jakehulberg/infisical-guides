# Environment-specific secrets
locals {
  environments = var.environments
  secret_names = ["API_URL", "LOG_LEVEL", "DATABASE_URL", "REDIS_URL"]
}

# Create environment-specific configuration secrets
locals {
  env_configs = {
    dev = {
      API_URL       = "https://api-dev.example.com"
      LOG_LEVEL     = "debug"
      DATABASE_URL  = "postgresql://user:pass@dev-db:5432/app"
      REDIS_URL     = "redis://dev-redis:6379"
    }
    staging = {
      API_URL       = "https://api-staging.example.com"
      LOG_LEVEL     = "info"
      DATABASE_URL  = "postgresql://user:pass@staging-db:5432/app"
      REDIS_URL     = "redis://staging-redis:6379"
    }
    prod = {
      API_URL       = "https://api.example.com"
      LOG_LEVEL     = "warn"
      DATABASE_URL  = var.prod_database_url
      REDIS_URL     = var.prod_redis_url
    }
  }
}

resource "infisical_secret" "env_config" {
  for_each = {
    for item in flatten([
      for env, config in local.env_configs : [
        for key, value in config : {
          id    = "${env}-${key}"
          env   = env
          key   = key
          value = value
        }
      ]
    ]) : item.id => item
  }
  
  name         = each.value.key
  value        = each.value.value
  env_slug     = each.value.env
  workspace_id = var.project_id
  folder_path  = "/api"
  
  comment = "Environment configuration for ${each.value.env}"
}