# Retrieve admin credentials for database operations
ephemeral "infisical_secret" "db_admin_user" {
  count = var.enable_sql_dynamic_secrets ? 1 : 0
  
  name         = "DB_ADMIN_USER"
  workspace_id = var.project_id
  env_slug     = var.environment
  folder_path  = "/database/admin"
}

ephemeral "infisical_secret" "db_admin_pass" {
  count = var.enable_sql_dynamic_secrets ? 1 : 0
  
  name         = "DB_ADMIN_PASS"
  workspace_id = var.project_id
  env_slug     = var.environment
  folder_path  = "/database/admin"
}

# Dynamic PostgreSQL read-only user
resource "infisical_dynamic_secret_sql_database" "postgres_readonly" {
  count = var.enable_postgres_dynamic ? 1 : 0
  
  name             = "postgres-readonly-access"
  project_slug     = var.project_slug
  environment_slug = var.environment
  path             = "/database/dynamic"
  
  default_ttl = var.postgres_default_ttl
  max_ttl     = var.postgres_max_ttl
  
  configuration = {
    client   = "postgres"
    host     = var.postgres_host
    port     = var.postgres_port
    database = var.postgres_database
    username = ephemeral.infisical_secret.db_admin_user[0].value
    password = ephemeral.infisical_secret.db_admin_pass[0].value
    
    ca = var.postgres_ca_cert
    
    creation_statement = <<-EOT
      CREATE ROLE "{{username}}" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';
      GRANT CONNECT ON DATABASE ${var.postgres_database} TO "{{username}}";
      GRANT USAGE ON SCHEMA public TO "{{username}}";
      GRANT SELECT ON ALL TABLES IN SCHEMA public TO "{{username}}";
      GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO "{{username}}";
    EOT
    
    revocation_statement = <<-EOT
      REASSIGN OWNED BY "{{username}}" TO postgres;
      DROP OWNED BY "{{username}}";
      DROP ROLE IF EXISTS "{{username}}";
    EOT
    
    renew_statement = <<-EOT
      ALTER ROLE "{{username}}" VALID UNTIL '{{expiration}}';
    EOT
    
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
  }
  
  username_template = "readonly_{{randomUsername}}_{{timestamp}}"
}

# Dynamic MySQL user for application access
resource "infisical_dynamic_secret_sql_database" "mysql_app" {
  count = var.enable_mysql_dynamic ? 1 : 0
  
  name             = "mysql-app-user"
  project_slug     = var.project_slug
  environment_slug = var.environment
  path             = "/database/dynamic"
  
  default_ttl = var.mysql_default_ttl
  max_ttl     = var.mysql_max_ttl
  
  configuration = {
    client   = "mysql2"
    host     = var.mysql_host
    port     = var.mysql_port
    database = var.mysql_database
    username = ephemeral.infisical_secret.db_admin_user[0].value
    password = ephemeral.infisical_secret.db_admin_pass[0].value
    
    ca = var.mysql_ca_cert
    
    creation_statement = <<-EOT
      CREATE USER '{{username}}'@'%' IDENTIFIED BY '{{password}}';
      GRANT SELECT, INSERT, UPDATE, DELETE ON ${var.mysql_database}.* TO '{{username}}'@'%';
      FLUSH PRIVILEGES;
    EOT
    
    revocation_statement = <<-EOT
      DROP USER IF EXISTS '{{username}}'@'%';
      FLUSH PRIVILEGES;
    EOT
    
    password_requirements = {
      length = 24
      required = {
        digits    = 3
        lowercase = 3
        uppercase = 3
        symbols   = 2
      }
    }
  }
  
  username_template = "app_{{randomUsername}}"
}

# Dynamic MongoDB user
resource "infisical_dynamic_secret_mongodb" "app_user" {
  count = var.enable_mongodb_dynamic ? 1 : 0
  
  name             = "mongodb-app-user"
  project_slug     = var.project_slug
  environment_slug = var.environment
  path             = "/database/dynamic"
  
  default_ttl = var.mongodb_default_ttl
  max_ttl     = var.mongodb_max_ttl
  
  configuration = {
    host     = var.mongodb_host
    port     = var.mongodb_port
    database = var.mongodb_database
    username = var.mongodb_admin_user
    password = var.mongodb_admin_password
    
    roles = jsonencode([
      {
        role = "readWrite"
        db   = var.mongodb_database
      }
    ])
    
    scopes = jsonencode([
      {
        name = var.mongodb_database
        type = "database"
      }
    ])
  }
  
  username_template = "mongo_{{randomUsername}}"
}