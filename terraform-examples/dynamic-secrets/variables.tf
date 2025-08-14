variable "project_id" {
  description = "Infisical project ID"
  type        = string
}

variable "project_slug" {
  description = "Infisical project slug"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "infisical_host" {
  description = "Infisical host URL"
  type        = string
  default     = "https://app.infisical.com"
}

variable "infisical_client_id" {
  description = "Infisical machine identity client ID"
  type        = string
  sensitive   = true
}

variable "infisical_client_secret" {
  description = "Infisical machine identity client secret"
  type        = string
  sensitive   = true
}

# AWS Dynamic Secret Variables
variable "aws_access_key_id" {
  description = "AWS access key ID for creating dynamic credentials"
  type        = string
  sensitive   = true
}

variable "aws_secret_access_key" {
  description = "AWS secret access key for creating dynamic credentials"
  type        = string
  sensitive   = true
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "aws_default_ttl" {
  description = "Default TTL for AWS dynamic secrets"
  type        = string
  default     = "2h"
}

variable "aws_max_ttl" {
  description = "Maximum TTL for AWS dynamic secrets"
  type        = string
  default     = "4h"
}

variable "aws_policy_arns" {
  description = "Comma-separated list of AWS policy ARNs to attach"
  type        = string
  default     = ""
}

variable "aws_allowed_actions" {
  description = "List of AWS actions to allow in custom policy"
  type        = list(string)
  default     = ["s3:GetObject", "s3:ListBucket"]
}

variable "aws_allowed_resources" {
  description = "AWS resources to allow access to"
  type        = string
  default     = "*"
}

variable "s3_bucket_name" {
  description = "S3 bucket name for dynamic access"
  type        = string
  default     = ""
}

variable "permission_boundary_arn" {
  description = "Permission boundary ARN for deployment credentials"
  type        = string
  default     = ""
}

# PostgreSQL Dynamic Secret Variables
variable "enable_sql_dynamic_secrets" {
  description = "Enable SQL dynamic secrets (requires admin credentials in Infisical)"
  type        = bool
  default     = false
}

variable "enable_postgres_dynamic" {
  description = "Enable PostgreSQL dynamic secrets"
  type        = bool
  default     = false
}

variable "postgres_host" {
  description = "PostgreSQL host"
  type        = string
  default     = ""
}

variable "postgres_port" {
  description = "PostgreSQL port"
  type        = string
  default     = "5432"
}

variable "postgres_database" {
  description = "PostgreSQL database name"
  type        = string
  default     = ""
}

variable "postgres_ca_cert" {
  description = "PostgreSQL CA certificate"
  type        = string
  default     = ""
}

variable "postgres_default_ttl" {
  description = "Default TTL for PostgreSQL dynamic credentials"
  type        = string
  default     = "2h"
}

variable "postgres_max_ttl" {
  description = "Maximum TTL for PostgreSQL dynamic credentials"
  type        = string
  default     = "4h"
}

# MySQL Dynamic Secret Variables
variable "enable_mysql_dynamic" {
  description = "Enable MySQL dynamic secrets"
  type        = bool
  default     = false
}

variable "mysql_host" {
  description = "MySQL host"
  type        = string
  default     = ""
}

variable "mysql_port" {
  description = "MySQL port"
  type        = string
  default     = "3306"
}

variable "mysql_database" {
  description = "MySQL database name"
  type        = string
  default     = ""
}

variable "mysql_ca_cert" {
  description = "MySQL CA certificate"
  type        = string
  default     = ""
}

variable "mysql_default_ttl" {
  description = "Default TTL for MySQL dynamic credentials"
  type        = string
  default     = "2h"
}

variable "mysql_max_ttl" {
  description = "Maximum TTL for MySQL dynamic credentials"
  type        = string
  default     = "4h"
}

# MongoDB Dynamic Secret Variables
variable "enable_mongodb_dynamic" {
  description = "Enable MongoDB dynamic secrets"
  type        = bool
  default     = false
}

variable "mongodb_host" {
  description = "MongoDB host"
  type        = string
  default     = ""
}

variable "mongodb_port" {
  description = "MongoDB port"
  type        = string
  default     = "27017"
}

variable "mongodb_database" {
  description = "MongoDB database name"
  type        = string
  default     = ""
}

variable "mongodb_admin_user" {
  description = "MongoDB admin username"
  type        = string
  sensitive   = true
  default     = ""
}

variable "mongodb_admin_password" {
  description = "MongoDB admin password"
  type        = string
  sensitive   = true
  default     = ""
}

variable "mongodb_default_ttl" {
  description = "Default TTL for MongoDB dynamic credentials"
  type        = string
  default     = "2h"
}

variable "mongodb_max_ttl" {
  description = "Maximum TTL for MongoDB dynamic credentials"
  type        = string
  default     = "4h"
}

# Kubernetes Dynamic Secret Variables
variable "enable_kubernetes_dynamic" {
  description = "Enable Kubernetes dynamic secrets"
  type        = bool
  default     = false
}

variable "kubernetes_host" {
  description = "Kubernetes API server URL"
  type        = string
  default     = ""
}

variable "kubernetes_admin_token" {
  description = "Kubernetes admin token"
  type        = string
  sensitive   = true
  default     = ""
}

variable "kubernetes_ca_cert" {
  description = "Kubernetes CA certificate"
  type        = string
  default     = ""
}

variable "kubernetes_namespace" {
  description = "Kubernetes namespace for service accounts"
  type        = string
  default     = "default"
}