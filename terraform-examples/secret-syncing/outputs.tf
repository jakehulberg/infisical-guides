output "aws_sync_ids" {
  value = {
    secrets_manager = var.enable_aws_secrets_manager_sync ? infisical_secret_sync_aws_secrets_manager.production[0].id : null
    parameter_store = var.enable_aws_parameter_store_sync ? infisical_secret_sync_aws_parameter_store.config[0].id : null
  }
  description = "AWS sync configuration IDs"
}

output "github_sync_id" {
  value       = var.enable_github_sync ? infisical_secret_sync_github.ci_secrets[0].id : null
  description = "GitHub sync configuration ID"
}

output "sync_summary" {
  value = {
    aws_syncs    = (var.enable_aws_secrets_manager_sync ? 1 : 0) + (var.enable_aws_parameter_store_sync ? 1 : 0)
    github_syncs = var.enable_github_sync ? 1 : 0
    total_syncs  = (var.enable_aws_secrets_manager_sync ? 1 : 0) + (var.enable_aws_parameter_store_sync ? 1 : 0) + (var.enable_github_sync ? 1 : 0)
  }
  description = "Summary of configured syncs"
}