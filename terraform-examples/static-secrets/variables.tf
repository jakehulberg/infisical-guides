variable "project_id" {
  description = "Infisical project ID"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "environments" {
  description = "List of environments"
  type        = list(string)
  default     = ["dev", "staging", "prod"]
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

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

# Database variables
variable "db_host" {
  description = "Database host"
  type        = string
  default     = "localhost"
}

variable "db_port" {
  description = "Database port"
  type        = string
  default     = "5432"
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "app"
}

variable "db_user" {
  description = "Database user"
  type        = string
  default     = "app_user"
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

# API variables
variable "api_key_value" {
  description = "Main API key value"
  type        = string
  sensitive   = true
}

# Production environment URLs
variable "prod_database_url" {
  description = "Production database URL"
  type        = string
  sensitive   = true
  default     = ""
}

variable "prod_redis_url" {
  description = "Production Redis URL"
  type        = string
  sensitive   = true
  default     = ""
}

# Third-party service variables
variable "stripe_public_key" {
  description = "Stripe public key"
  type        = string
  default     = ""
}

variable "stripe_secret_key" {
  description = "Stripe secret key"
  type        = string
  sensitive   = true
  default     = ""
}

variable "stripe_webhook_secret" {
  description = "Stripe webhook secret"
  type        = string
  sensitive   = true
  default     = ""
}

variable "sendgrid_api_key" {
  description = "SendGrid API key"
  type        = string
  sensitive   = true
  default     = ""
}

# AWS variables
variable "s3_bucket_name" {
  description = "S3 bucket name"
  type        = string
  default     = ""
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "cloudfront_url" {
  description = "CloudFront distribution URL"
  type        = string
  default     = ""
}

# Application configuration
variable "enable_new_ui" {
  description = "Enable new UI features"
  type        = bool
  default     = false
}

variable "enable_beta_features" {
  description = "Enable beta features"
  type        = bool
  default     = false
}

variable "analytics_enabled" {
  description = "Enable analytics"
  type        = bool
  default     = true
}

variable "monitoring_level" {
  description = "Monitoring level (basic, detailed, comprehensive)"
  type        = string
  default     = "basic"
}

# TLS certificate
variable "tls_certificate_path" {
  description = "Path to TLS certificate file"
  type        = string
  default     = ""
}

# Resource creation flags
variable "create_aws_resources" {
  description = "Whether to create AWS resources"
  type        = bool
  default     = false
}

variable "create_kubernetes_resources" {
  description = "Whether to create Kubernetes resources"
  type        = bool
  default     = false
}