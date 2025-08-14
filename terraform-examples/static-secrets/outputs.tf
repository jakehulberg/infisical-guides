output "secret_count" {
  value = length(infisical_secret.database_config) + length(infisical_secret.service_secrets) + length(infisical_secret.env_config)
  description = "Total number of secrets created"
}

output "generated_secrets" {
  value = {
    session_secret_length = length(random_password.session_secret.result)
    encryption_key_length = length(random_password.encryption_key.result)
    instance_id          = random_id.instance_id.hex
  }
  description = "Information about generated secrets"
}

output "folder_structure" {
  value = {
    api_secrets       = "/api"
    database_secrets  = "/database"
    payment_secrets   = "/third-party/payment"
    email_secrets     = "/third-party/email"
    storage_secrets   = "/third-party/storage"
    infrastructure    = "/infrastructure"
  }
  description = "Folder structure used for organizing secrets"
}