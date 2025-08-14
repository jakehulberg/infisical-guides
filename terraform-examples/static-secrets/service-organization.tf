# Organize secrets by service
locals {
  services = {
    payment = {
      folder = "/third-party/payment"
      secrets = {
        STRIPE_PUBLIC_KEY     = var.stripe_public_key
        STRIPE_SECRET_KEY     = var.stripe_secret_key
        STRIPE_WEBHOOK_SECRET = var.stripe_webhook_secret
      }
    }
    email = {
      folder = "/third-party/email"
      secrets = {
        SENDGRID_API_KEY = var.sendgrid_api_key
        FROM_EMAIL       = "noreply@example.com"
        REPLY_TO_EMAIL   = "support@example.com"
      }
    }
    storage = {
      folder = "/third-party/storage"
      secrets = {
        S3_BUCKET      = var.s3_bucket_name
        S3_REGION      = var.aws_region
        CLOUDFRONT_URL = var.cloudfront_url
      }
    }
  }
}

# Create service secrets
resource "infisical_secret" "service_secrets" {
  for_each = {
    for item in flatten([
      for service_name, service in local.services : [
        for key, value in service.secrets : {
          id      = "${service_name}-${key}"
          folder  = service.folder
          key     = key
          value   = value
          service = service_name
        }
      ]
    ]) : item.id => item
  }
  
  name         = each.value.key
  value        = each.value.value
  env_slug     = var.environment
  workspace_id = var.project_id
  folder_path  = each.value.folder
  
  comment = "${each.value.service} service configuration"
}