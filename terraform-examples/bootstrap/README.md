# Bootstrap - Basic Infisical Setup

Get Infisical up and running quickly with this 15-minute bootstrap guide.

## What This Does

- Creates a new Infisical project with multiple environments
- Sets up basic secrets (database URLs, API keys, JWT secrets)
- Demonstrates secret retrieval using ephemeral resources
- Shows integration with AWS Lambda, Kubernetes, and ECS (optional)

## Prerequisites

1. Infisical account and machine identity created
2. Terraform >= 1.10.0 installed
3. Required credentials configured

## Quick Start

1. **Clone and navigate:**
   ```bash
   cd terraform-examples/bootstrap
   ```

2. **Configure variables:**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your values
   ```

3. **Set up authentication:**
   ```bash
   export INFISICAL_CLIENT_ID="your-machine-identity-client-id"
   export INFISICAL_CLIENT_SECRET="your-machine-identity-client-secret"
   ```

4. **Deploy:**
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Configuration

### Required Variables

- `infisical_client_id` - Machine identity client ID
- `infisical_client_secret` - Machine identity client secret

### Optional Variables

- `project_name` - Name of your project (default: "my-app")
- `project_slug` - URL-friendly project identifier (default: "my-app")
- `environments` - List of environments (default: ["dev", "staging", "prod"])
- `stripe_prod_key` - Stripe production API key
- `stripe_test_key` - Stripe test API key
- `create_aws_resources` - Create AWS Lambda/ECS examples (default: false)
- `create_kubernetes_resources` - Create Kubernetes secret example (default: false)

## What Gets Created

### Infisical Resources
- Project with specified name and environments
- Database connection secrets for each environment
- Stripe API keys (prod/test based on environment)
- Common application secrets (JWT, session, encryption keys)

### Optional Cloud Resources
- AWS Lambda function with environment variables
- Kubernetes secret with application secrets
- ECS task definition with environment variables

## Usage Examples

### Retrieving Secrets
```hcl
# Ephemeral retrieval (recommended)
ephemeral "infisical_secret" "database_url" {
  name         = "DATABASE_URL"
  workspace_id = var.project_id
  env_slug     = "prod"
  folder_path  = "/database"
}

# Use in other resources
resource "aws_lambda_function" "example" {
  environment {
    variables = {
      DATABASE_URL = ephemeral.infisical_secret.database_url.value
    }
  }
}
```

### Folder Structure
```
/database/
  ├── DATABASE_URL (per environment)
/api/
  ├── STRIPE_KEY (per environment)
  ├── JWT_SECRET (per environment)
  ├── SESSION_SECRET (per environment)
  └── ENCRYPTION_KEY (per environment)
```

## Next Steps

1. **Foundation**: Set up organized project structure with [`../foundation`](../foundation)
2. **Static Secrets**: Learn advanced secret management with [`../static-secrets`](../static-secrets)
3. **App Connections**: Configure cloud integrations with [`../app-connections`](../app-connections)

## Security Notes

- Secrets are generated using random providers and stored securely in Infisical
- Ephemeral resources ensure secrets never touch Terraform state
- All sensitive variables are marked as sensitive
- Machine identity authentication is recommended over personal access tokens