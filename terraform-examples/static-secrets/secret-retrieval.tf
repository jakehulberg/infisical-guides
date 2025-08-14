# Best practice: Use ephemeral resources for secret retrieval
ephemeral "infisical_secret" "api_key" {
  name         = "API_KEY"
  workspace_id = var.project_id
  env_slug     = var.environment
  folder_path  = "/api"
}

ephemeral "infisical_secret" "db_password" {
  name         = "DB_PASSWORD"
  workspace_id = var.project_id
  env_slug     = var.environment
  folder_path  = "/database"
}

ephemeral "infisical_secret" "stripe_secret" {
  name         = "STRIPE_SECRET_KEY"
  workspace_id = var.project_id
  env_slug     = var.environment
  folder_path  = "/third-party/payment"
}

# Use secrets in other resources
resource "aws_db_instance" "main" {
  count = var.create_aws_resources ? 1 : 0
  
  identifier = "${var.project_name}-db"
  
  username = ephemeral.infisical_secret.db_user.value
  password = ephemeral.infisical_secret.db_password.value
  
  allocated_storage = 20
  engine           = "postgres"
  engine_version   = "13.7"
  instance_class   = "db.t3.micro"
  
  skip_final_snapshot = true
}

# Use with Kubernetes deployment
resource "kubernetes_deployment" "app" {
  count = var.create_kubernetes_resources ? 1 : 0
  
  metadata {
    name = var.project_name
  }
  
  spec {
    replicas = 2
    
    selector {
      match_labels = {
        app = var.project_name
      }
    }
    
    template {
      metadata {
        labels = {
          app = var.project_name
        }
      }
      
      spec {
        container {
          name  = "app"
          image = "${var.project_name}:latest"
          
          env {
            name  = "API_KEY"
            value = ephemeral.infisical_secret.api_key.value
          }
          
          env {
            name  = "DATABASE_PASSWORD"
            value = ephemeral.infisical_secret.db_password.value
          }
          
          env {
            name  = "STRIPE_SECRET_KEY"
            value = ephemeral.infisical_secret.stripe_secret.value
          }
        }
      }
    }
  }
}