# Store JSON configuration
resource "infisical_secret" "app_config" {
  name = "APP_CONFIG"
  value = jsonencode({
    features = {
      new_ui        = var.enable_new_ui
      beta_features = var.enable_beta_features
      api_version   = "v2"
    }
    rate_limits = {
      anonymous     = 100
      authenticated = 1000
      premium       = 10000
    }
    integrations = {
      analytics_enabled = var.analytics_enabled
      monitoring_level  = var.monitoring_level
    }
  })
  env_slug     = var.environment
  workspace_id = var.project_id
  folder_path  = "/api"
  
  comment = "Application feature configuration"
}

# Store certificates (base64 encoded)
resource "infisical_secret" "tls_cert" {
  count = var.tls_certificate_path != "" ? 1 : 0
  
  name         = "TLS_CERTIFICATE"
  value        = base64encode(file(var.tls_certificate_path))
  env_slug     = var.environment
  workspace_id = var.project_id
  folder_path  = "/infrastructure"
  
  comment = "TLS certificate for API gateway"
}

# Generate and store random values
resource "random_password" "session_secret" {
  length  = 64
  special = true
}

resource "random_password" "encryption_key" {
  length  = 32
  special = false
}

resource "random_id" "instance_id" {
  byte_length = 8
}

resource "infisical_secret" "generated_secrets" {
  for_each = {
    SESSION_SECRET  = random_password.session_secret.result
    ENCRYPTION_KEY  = random_password.encryption_key.result
    INSTANCE_ID     = random_id.instance_id.hex
  }
  
  name         = each.key
  value        = each.value
  env_slug     = var.environment
  workspace_id = var.project_id
  folder_path  = "/api"
  
  comment = "Generated secret for ${each.key}"
}