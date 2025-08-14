# Dynamic Secrets

⚠️ **ADVANCED FEATURE** - Generate temporary credentials on-demand for databases, cloud providers, and Kubernetes. 

## ⚠️ Complexity Warning

**This is an advanced enterprise feature requiring significant setup:**
- Database admin credentials must be pre-stored in Infisical
- Target database users must be manually created beforehand  
- AWS IAM permissions for user creation required
- Network connectivity between Infisical and target services needed
- **Consider static secrets first** - they're simpler for most use cases

## What This Does

- Creates AWS IAM dynamic credentials with custom policies
- Generates temporary database users for PostgreSQL, MySQL, and MongoDB
- Provides Kubernetes service account tokens on-demand
- Configures TTL and permission boundaries for all dynamic credentials

## Prerequisites (Complex Setup Required)

1. ✅ **Infisical project** already created
2. ⚠️ **Database admin credentials** must be manually stored in Infisical at `/database/admin/` 
3. ⚠️ **AWS IAM permissions** - Your AWS credentials need `iam:CreateUser`, `iam:AttachUserPolicy`, `iam:DeleteUser` permissions
4. ⚠️ **Database admin access** for creating/dropping temporary users
5. ⚠️ **Network connectivity** - Infisical must reach your databases and AWS APIs

**If this seems complex, consider using [`../static-secrets`](../static-secrets) instead.**

## Quick Start

1. **Navigate to dynamic-secrets:**
   ```bash
   cd terraform-examples/dynamic-secrets
   ```

2. **Configure variables:**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your values
   ```

3. **Store admin credentials in Infisical:**
   ```bash
   # For database dynamic secrets, first store admin credentials
   infisical secrets set DB_ADMIN_USER=postgres --env=prod --path=/database/admin
   infisical secrets set DB_ADMIN_PASS=secure-password --env=prod --path=/database/admin
   ```

4. **Deploy:**
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Dynamic Secret Types

### 1. AWS IAM Dynamic Secrets

#### Basic Configuration
```hcl
resource "infisical_dynamic_secret_aws_iam" "app_user" {
  name             = "app-dynamic-user"
  project_slug     = var.project_slug
  environment_slug = "prod"
  path             = "/infrastructure/aws"
  
  default_ttl = "2h"
  max_ttl     = "4h"
  
  configuration = {
    method = "access_key"
    
    access_key_config = {
      access_key        = var.aws_access_key_id
      secret_access_key = var.aws_secret_access_key
    }
    
    region = "us-east-1"
    aws_path = "/infisical/dynamic/"
    
    policy_document = jsonencode({
      Version = "2012-10-17"
      Statement = [{
        Effect = "Allow"
        Action = ["s3:GetObject", "s3:PutObject"]
        Resource = "arn:aws:s3:::my-bucket/*"
      }]
    })
  }
  
  username_template = "infisical-{{randomUsername}}-{{timestamp}}"
}
```

#### Use Cases
- Temporary deployment credentials
- Time-limited S3 access
- Short-lived CI/CD permissions
- Developer debugging access

### 2. SQL Database Dynamic Secrets

#### PostgreSQL Read-Only Access
```hcl
resource "infisical_dynamic_secret_sql_database" "postgres_readonly" {
  name             = "postgres-readonly-access"
  project_slug     = var.project_slug
  environment_slug = "prod"
  path             = "/database/dynamic"
  
  default_ttl = "2h"
  max_ttl     = "4h"
  
  configuration = {
    client   = "postgres"
    host     = var.postgres_host
    port     = "5432"
    database = var.postgres_database
    username = var.admin_user  # Retrieved from Infisical
    password = var.admin_pass  # Retrieved from Infisical
    
    creation_statement = <<-EOT
      CREATE ROLE "{{username}}" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';
      GRANT SELECT ON ALL TABLES IN SCHEMA public TO "{{username}}";
    EOT
    
    revocation_statement = <<-EOT
      DROP ROLE IF EXISTS "{{username}}";
    EOT
  }
}
```

#### MySQL Application Access
```hcl
resource "infisical_dynamic_secret_sql_database" "mysql_app" {
  name             = "mysql-app-user"
  project_slug     = var.project_slug
  environment_slug = "prod"
  path             = "/database/dynamic"
  
  default_ttl = "2h"
  max_ttl     = "4h"
  
  configuration = {
    client   = "mysql2"
    host     = var.mysql_host
    port     = "3306"
    database = var.mysql_database
    
    creation_statement = <<-EOT
      CREATE USER '{{username}}'@'%' IDENTIFIED BY '{{password}}';
      GRANT SELECT, INSERT, UPDATE, DELETE ON myapp.* TO '{{username}}'@'%';
    EOT
    
    revocation_statement = <<-EOT
      DROP USER IF EXISTS '{{username}}'@'%';
    EOT
  }
}
```

### 3. MongoDB Dynamic Secrets

```hcl
resource "infisical_dynamic_secret_mongodb" "app_user" {
  name             = "mongodb-app-user"
  project_slug     = var.project_slug
  environment_slug = "prod"
  path             = "/database/dynamic"
  
  default_ttl = "2h"
  max_ttl     = "4h"
  
  configuration = {
    host     = var.mongodb_host
    port     = "27017"
    database = var.mongodb_database
    
    roles = jsonencode([{
      role = "readWrite"
      db   = var.mongodb_database
    }])
  }
}
```

### 4. Kubernetes Dynamic Secrets

```hcl
resource "infisical_dynamic_secret_kubernetes" "app_service_account" {
  name             = "k8s-app-service-account"
  project_slug     = var.project_slug
  environment_slug = "prod"
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
      namespace            = "default"
    }
  }
}
```

## Consuming Dynamic Secrets

### Using Infisical CLI
```bash
# Request AWS credentials
infisical secrets get --path=/infrastructure/aws --env=prod

# Request database credentials
infisical secrets get --path=/database/dynamic --env=prod

# Request Kubernetes token
infisical secrets get --path=/kubernetes/dynamic --env=prod
```

### Using Infisical SDK (Node.js)
```javascript
const { InfisicalClient } = require("@infisical/sdk");

const client = new InfisicalClient({
  clientId: process.env.INFISICAL_CLIENT_ID,
  clientSecret: process.env.INFISICAL_CLIENT_SECRET,
});

// Request dynamic AWS credentials
const awsCreds = await client.createDynamicSecretLease({
  projectSlug: "my-project",
  environmentSlug: "prod",
  path: "/infrastructure/aws",
  dynamicSecretName: "app-dynamic-user",
  ttl: "1h"
});

// Use the credentials
const s3Client = new AWS.S3({
  accessKeyId: awsCreds.accessKeyId,
  secretAccessKey: awsCreds.secretAccessKey
});
```

### Using Infisical SDK (Python)
```python
from infisical import InfisicalClient

client = InfisicalClient(
    client_id=os.environ["INFISICAL_CLIENT_ID"],
    client_secret=os.environ["INFISICAL_CLIENT_SECRET"]
)

# Request dynamic database credentials
db_creds = client.create_dynamic_secret_lease(
    project_slug="my-project",
    environment_slug="prod",
    path="/database/dynamic",
    dynamic_secret_name="postgres-readonly-access",
    ttl="1h"
)

# Use with database connection
conn = psycopg2.connect(
    host="postgres.example.com",
    database="myapp",
    user=db_creds["username"],
    password=db_creds["password"]
)
```

## Configuration Options

### TTL Settings
- `default_ttl` - Default lifetime for credentials (e.g., "2h", "30m")
- `max_ttl` - Maximum allowed lifetime (cannot be extended beyond this)

### Password Requirements (Databases)
```hcl
password_requirements = {
  length = 32
  required = {
    digits    = 4
    lowercase = 4
    symbols   = 4
    uppercase = 4
  }
  allowed_symbols = "!@#$%^&*()_+-=[]{}|;:,.<>?"
}
```

### Username Templates
- `{{randomUsername}}` - Random string
- `{{timestamp}}` - Unix timestamp
- Custom prefixes/suffixes for identification

## Best Practices

### Security
- ✅ Use shortest practical TTL values
- ✅ Implement least-privilege policies
- ✅ Store admin credentials securely in Infisical
- ✅ Use permission boundaries for AWS IAM
- ✅ Enable SSL/TLS for all database connections

### Operations
- ✅ Monitor credential creation and usage
- ✅ Set up alerts for credential expiration
- ✅ Test revocation statements thoroughly
- ✅ Document required permissions clearly

### Database Permissions
```sql
-- PostgreSQL minimum admin permissions
GRANT CREATE ON DATABASE myapp TO admin_user;
GRANT USAGE ON SCHEMA public TO admin_user;

-- MySQL minimum admin permissions
GRANT CREATE USER ON *.* TO 'admin_user'@'%';
GRANT ALL PRIVILEGES ON myapp.* TO 'admin_user'@'%' WITH GRANT OPTION;
```

## Troubleshooting

### Common Issues

1. **AWS IAM Creation Failed**
   - Verify AWS credentials have IAM permissions
   - Check policy JSON syntax
   - Ensure AWS path is valid

2. **Database User Creation Failed**
   - Test admin credentials manually
   - Verify network connectivity
   - Check creation statement SQL syntax
   - Ensure admin user has CREATE USER permissions

3. **Credentials Not Expiring**
   - Verify revocation statements are correct
   - Check database timezone settings
   - Ensure cleanup job is running

4. **TTL Exceeded**
   - Credentials cannot be extended beyond max_ttl
   - Request new credentials instead of renewing

## Important Notes

⚠️ **Dynamic secrets are NOT retrieved through Terraform** - They are configured here but consumed at runtime through the Infisical SDK/CLI

⚠️ **Admin credentials** must be stored in Infisical before creating database dynamic secrets

⚠️ **IAM permissions** - The AWS credentials used must have permissions to create users and attach policies

⚠️ **Network access** - Ensure Infisical can reach your databases and Kubernetes clusters

## Next Steps

1. **Secret Rotation**: Automate credential lifecycle with [`../secret-rotation`](../secret-rotation)
2. **Access Controls**: Implement RBAC for dynamic secrets with [`../access-controls`](../access-controls)
3. **Production Setup**: See complete examples in [`../production`](../production)