# Foundation - Project Structure & Organization

Set up a well-organized Infisical project structure for scalability and maintainability.

## What This Does

- Creates a structured Infisical project with custom environments
- Sets up standardized folder hierarchy across all environments
- Implements tagging system for secret classification
- Provides foundation for team collaboration and access control

## Prerequisites

1. Infisical account and machine identity created
2. Terraform >= 1.10.0 installed
3. Basic understanding of Infisical concepts

## Quick Start

1. **Navigate to foundation:**
   ```bash
   cd terraform-examples/foundation
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

## Project Structure Created

### Environments
- **Development** (dev) - For active development
- **Testing** (test) - For automated testing
- **Staging** (staging) - For pre-production testing
- **Production** (prod) - For live applications

### Folder Hierarchy (per environment)
```
/api/                 # Application API secrets
/database/            # Database credentials and configs
/third-party/         # External service integrations
/infrastructure/      # Cloud provider and infrastructure secrets
/ci-cd/              # Continuous integration/deployment secrets
```

### Tagging System
- **Critical** (Red) - Highly sensitive secrets requiring special handling
- **Sensitive** (Orange) - Important secrets with restricted access
- **Public** (Green) - Configuration values that can be widely shared
- **Deprecated** (Gray) - Secrets marked for removal
- **Rotate Monthly** (Blue) - Secrets requiring regular rotation

## Usage as a Module

```hcl
module "infisical_foundation" {
  source = "./foundation"
  
  project_name = "my-infrastructure"
  project_slug = "my-infrastructure"
  
  environments = ["dev", "staging", "prod"]
  
  # Authentication
  infisical_client_id     = var.infisical_client_id
  infisical_client_secret = var.infisical_client_secret
  
  # Optional: Critical secrets
  critical_secrets = {
    "DATABASE_MASTER_PASSWORD" = var.database_master_password
    "API_MASTER_KEY"          = var.api_master_key
  }
}
```

## Best Practices Implemented

### Folder Organization
- Consistent structure across all environments
- Logical grouping by purpose (API, database, third-party, etc.)
- README markers for folder documentation

### Tagging Strategy
- Color-coded classification system
- Easy identification of secret sensitivity levels
- Support for rotation scheduling

### Environment Management
- Custom environment names with clear purposes
- Scalable structure for adding new environments
- Proper naming conventions

## Configuration Options

### Required Variables
- `project_name` - Human-readable project name
- `project_slug` - URL-friendly project identifier
- `infisical_client_id` - Machine identity client ID
- `infisical_client_secret` - Machine identity client secret

### Optional Variables
- `environments` - List of environments (default: ["dev", "staging", "prod"])
- `infisical_host` - Infisical instance URL (default: cloud)
- `critical_secrets` - Map of critical secrets requiring special handling

## Next Steps

1. **Static Secrets**: Add secrets using organized patterns with [`../static-secrets`](../static-secrets)
2. **App Connections**: Set up cloud provider integrations with [`../app-connections`](../app-connections)
3. **Access Controls**: Implement RBAC with [`../access-controls`](../access-controls)

## Integration Examples

### Using with Other Modules
```hcl
# Foundation setup
module "foundation" {
  source = "./foundation"
  # ... configuration
}

# Static secrets referencing foundation
module "static_secrets" {
  source = "./static-secrets"
  
  project_id   = module.foundation.project_id
  project_slug = module.foundation.project_slug
  tag_ids      = module.foundation.tag_ids
}
```

### Team Workflow
1. **Platform Team**: Sets up foundation structure
2. **Development Teams**: Add secrets following established patterns
3. **Security Team**: Monitors using tags and audit logs
4. **Operations Team**: Manages rotations and integrations

## Security Considerations

- Folder structure provides clear boundaries for access control
- Tags enable automated security policies
- Environment separation prevents accidental cross-environment access
- README markers help with documentation and compliance