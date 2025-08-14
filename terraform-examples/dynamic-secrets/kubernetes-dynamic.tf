# Dynamic Kubernetes service account
resource "infisical_dynamic_secret_kubernetes" "app_service_account" {
  count = var.enable_kubernetes_dynamic ? 1 : 0
  
  name             = "k8s-app-service-account"
  project_slug     = var.project_slug
  environment_slug = var.environment
  path             = "/kubernetes/dynamic"
  
  default_ttl = "1h"
  max_ttl     = "4h"
  
  configuration = {
    auth_method = "api"
    
    api_config = {
      cluster_url   = var.kubernetes_host
      cluster_token = var.kubernetes_admin_token
      enable_ssl    = true
      ca            = var.kubernetes_ca_cert
    }
    
    credential_type = "static"
    
    static_config = {
      service_account_name = "infisical-service-account"
      namespace            = var.kubernetes_namespace
    }
    
    audiences = []
  }
  
  username_template = "{{randomUsername}}"
}