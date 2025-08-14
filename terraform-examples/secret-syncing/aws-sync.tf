# Sync to AWS Secrets Manager (Most Common)
resource "infisical_secret_sync_aws_secrets_manager" "production" {
  count = var.enable_aws_secrets_manager_sync ? 1 : 0
  
  name          = "aws-secrets-manager-sync"
  description   = "Sync secrets to AWS Secrets Manager"
  project_id    = var.project_id
  environment   = var.environment
  secret_path   = var.aws_sync_secret_path
  connection_id = var.aws_connection_id
  
  sync_options = {
    initial_sync_behavior = "overwrite-destination"
    aws_kms_key_id       = var.aws_kms_key_id
    
    tags = [
      {
        key   = "ManagedBy"
        value = "Infisical"
      },
      {
        key   = "Environment"
        value = var.environment
      }
    ]
  }
  
  destination_config = {
    aws_region       = var.aws_region
    mapping_behavior = "one-to-one"  # Each secret gets its own AWS secret
  }
  
  auto_sync_enabled = true
}

# Sync to AWS Parameter Store (For Configuration)
resource "infisical_secret_sync_aws_parameter_store" "config" {
  count = var.enable_aws_parameter_store_sync ? 1 : 0
  
  name          = "aws-parameter-store-sync"
  description   = "Sync configuration to AWS Parameter Store"
  project_id    = var.project_id
  environment   = var.environment
  secret_path   = "/config"  # Non-sensitive configuration
  connection_id = var.aws_connection_id
  
  sync_options = {
    initial_sync_behavior   = "overwrite-destination"
    disable_secret_deletion = true  # Don't delete existing parameters
    
    tags = [
      {
        key   = "ManagedBy"
        value = "Infisical"
      }
    ]
  }
  
  destination_config = {
    aws_region = var.aws_region
    path       = "/infisical/${var.environment}/"
  }
  
  auto_sync_enabled = true
}

