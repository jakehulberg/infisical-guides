# Secret Syncing

Synchronize secrets to the most common external stores: AWS and GitHub. Focused on practical, widely-used integrations.

## What This Does

- **AWS Secrets Manager** - Sync sensitive secrets with encryption
- **AWS Parameter Store** - Sync configuration values cost-effectively  
- **GitHub Repositories** - Sync CI/CD secrets to GitHub Actions

*Simplified to focus on the most common use cases. For other providers (GCP, Azure), see the [Terraform provider docs](https://registry.terraform.io/providers/Infisical/infisical/latest/docs).*

## Prerequisites

1. **App connections configured** - Create AWS, GitHub, etc. connections in Infisical UI or via terraform
2. **Target cloud accounts** with proper permissions  
3. **Destination services** created (Key Vaults, repositories, etc.)

## Quick Start

1. **Navigate to secret-syncing:**
   ```bash
   cd terraform-examples/secret-syncing
   ```

2. **Configure variables:**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit with your connection IDs and target configurations
   ```

3. **Deploy:**
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Sync Destinations

### AWS Secrets Manager
- One-to-one or many-to-one secret mapping
- KMS encryption support
- Custom tagging
- Multi-region sync

### AWS Parameter Store  
- Hierarchical parameter organization
- Cost-effective for configuration
- Supports import from existing parameters


### GitHub
- Repository secrets
- Environment secrets  
- Organization secrets
- Secret whitelisting

## Next Steps

Set up **foundation** with machine identities for proper RBAC and access controls.