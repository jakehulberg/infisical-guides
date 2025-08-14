# Static Secrets Management

Create and manage traditional secrets like API keys, passwords, and configuration values with organized patterns and best practices.

## What This Does

- Creates basic secrets with proper organization
- Implements environment-specific secret patterns
- Organizes secrets by service and purpose
- Handles complex secret types (JSON, certificates, generated values)
- Demonstrates secure secret retrieval using ephemeral resources

## Prerequisites

1. Infisical project already created (use `../bootstrap` or `../foundation`)
2. Terraform >= 1.10.0 installed
3. Machine identity configured

## Quick Start

1. **Navigate to static-secrets:**
   ```bash
   cd terraform-examples/static-secrets
   ```

2. **Configure variables:**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your values
   ```

3. **Deploy:**
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Secret Organization Patterns

### 1. Basic Secrets
Simple key-value pairs for common use cases:
```hcl
resource "infisical_secret" "api_key" {
  name         = "API_KEY"
  value        = var.api_key_value
  env_slug     = "prod"
  workspace_id = var.project_id
  folder_path  = "/api"
}
```

### 2. Bulk Secret Creation
Create multiple related secrets efficiently:
```hcl
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
  # ... other configuration
}
```

### 3. Environment-Specific Secrets
Create different values per environment:
```hcl
locals {
  env_configs = {
    dev = {
      API_URL   = "https://api-dev.example.com"
      LOG_LEVEL = "debug"
    }
    prod = {
      API_URL   = "https://api.example.com"
      LOG_LEVEL = "warn"
    }
  }
}
```

### 4. Service-Based Organization
Group secrets by service or integration:
```hcl
locals {
  services = {
    payment = {
      folder = "/third-party/payment"
      secrets = {
        STRIPE_PUBLIC_KEY = var.stripe_public_key
        STRIPE_SECRET_KEY = var.stripe_secret_key
      }
    }
    email = {
      folder = "/third-party/email"
      secrets = {
        SENDGRID_API_KEY = var.sendgrid_api_key
      }
    }
  }
}
```

## Advanced Secret Types

### JSON Configuration
Store complex configuration as JSON:
```hcl
resource "infisical_secret" "app_config" {
  name = "APP_CONFIG"
  value = jsonencode({
    features = {
      new_ui        = true
      api_version   = "v2"
    }
    rate_limits = {
      authenticated = 1000
      premium       = 10000
    }
  })
}
```

### Generated Secrets
Use Terraform providers to generate secure values:
```hcl
resource "random_password" "session_secret" {
  length  = 64
  special = true
}

resource "infisical_secret" "session" {
  name  = "SESSION_SECRET"
  value = random_password.session_secret.result
}
```

### File-Based Secrets
Store certificates or other file content:
```hcl
resource "infisical_secret" "tls_cert" {
  name  = "TLS_CERTIFICATE"
  value = base64encode(file("cert.pem"))
}
```

## Secure Secret Retrieval

### Using Ephemeral Resources (Recommended)
```hcl
ephemeral "infisical_secret" "api_key" {
  name         = "API_KEY"
  workspace_id = var.project_id
  env_slug     = "prod"
  folder_path  = "/api"
}

# Use in other resources
resource "aws_lambda_function" "api" {
  environment {
    variables = {
      API_KEY = ephemeral.infisical_secret.api_key.value
    }
  }
}
```

## Folder Structure Created

```
/api/
├── API_KEY
├── SESSION_SECRET
├── ENCRYPTION_KEY
├── INSTANCE_ID
└── APP_CONFIG

/database/
├── DB_HOST
├── DB_PORT
├── DB_NAME
├── DB_USER
└── DB_PASSWORD

/third-party/
├── payment/
│   ├── STRIPE_PUBLIC_KEY
│   ├── STRIPE_SECRET_KEY
│   └── STRIPE_WEBHOOK_SECRET
├── email/
│   ├── SENDGRID_API_KEY
│   ├── FROM_EMAIL
│   └── REPLY_TO_EMAIL
└── storage/
    ├── S3_BUCKET
    ├── S3_REGION
    └── CLOUDFRONT_URL

/infrastructure/
└── TLS_CERTIFICATE (if provided)
```

## Configuration Options

### Required Variables
- `project_id` - Infisical project ID
- `infisical_client_id` - Machine identity client ID
- `infisical_client_secret` - Machine identity client secret
- `project_name` - Project name for resource naming
- `db_password` - Database password
- `api_key_value` - Main API key

### Optional Variables
- `environment` - Target environment (default: "prod")
- `environments` - List of environments for multi-env secrets
- Database configuration (host, port, name, user)
- Third-party service keys (Stripe, SendGrid)
- AWS configuration (S3, CloudFront)
- Application feature flags
- TLS certificate path

## Integration Examples

### With AWS Lambda
```hcl
resource "aws_lambda_function" "api" {
  environment {
    variables = {
      DATABASE_URL = ephemeral.infisical_secret.db_url.value
      API_KEY      = ephemeral.infisical_secret.api_key.value
    }
  }
}
```

### With Kubernetes
```hcl
resource "kubernetes_secret" "app_secrets" {
  data = {
    DATABASE_PASSWORD = ephemeral.infisical_secret.db_password.value
    STRIPE_SECRET_KEY = ephemeral.infisical_secret.stripe_key.value
  }
}
```

### With ECS
```hcl
resource "aws_ecs_task_definition" "app" {
  container_definitions = jsonencode([{
    environment = [
      {
        name  = "API_KEY"
        value = ephemeral.infisical_secret.api_key.value
      }
    ]
  }])
}
```

## Best Practices Implemented

### Security
- ✅ Ephemeral resources prevent secrets in state
- ✅ All sensitive variables marked as sensitive
- ✅ Generated secrets use secure random providers
- ✅ Proper folder organization for access control

### Organization
- ✅ Logical folder structure by purpose
- ✅ Service-based grouping
- ✅ Environment-specific configurations
- ✅ Consistent naming conventions

### Maintainability
- ✅ Modular secret creation patterns
- ✅ Reusable configuration structures
- ✅ Clear variable documentation
- ✅ Comprehensive examples

## Next Steps

1. **App Connections**: Set up cloud integrations with [`../app-connections`](../app-connections)
2. **Dynamic Secrets**: Learn temporary credential generation with [`../dynamic-secrets`](../dynamic-secrets)
3. **Secret Rotation**: Implement automated rotation with [`../secret-rotation`](../secret-rotation)
4. **Access Controls**: Add RBAC and policies with [`../access-controls`](../access-controls)

## Troubleshooting

### Common Issues

1. **Permission Denied**: Ensure machine identity has proper project access
2. **Folder Not Found**: Create folder structure first or use foundation module
3. **Secret Already Exists**: Use `terraform import` for existing secrets
4. **State File Contains Secrets**: Verify ephemeral resources are used correctly