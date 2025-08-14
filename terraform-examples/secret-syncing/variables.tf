variable "project_id" {
  description = "Infisical project ID"
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

# AWS Sync Variables
variable "enable_aws_secrets_manager_sync" {
  description = "Enable AWS Secrets Manager sync"
  type        = bool
  default     = false
}

variable "enable_aws_parameter_store_sync" {
  description = "Enable AWS Parameter Store sync"
  type        = bool
  default     = false
}

variable "aws_connection_id" {
  description = "AWS app connection ID (create in Infisical UI or terraform)"
  type        = string
  default     = ""
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "aws_sync_secret_path" {
  description = "Infisical secret path to sync to AWS"
  type        = string
  default     = "/aws"
}

variable "aws_kms_key_id" {
  description = "AWS KMS key ID for encryption (optional)"
  type        = string
  default     = ""
}

# GitHub Sync Variables
variable "enable_github_sync" {
  description = "Enable GitHub secrets sync"
  type        = bool
  default     = false
}

variable "github_connection_id" {
  description = "GitHub app connection ID (create in Infisical UI or terraform)"
  type        = string
  default     = ""
}

variable "github_owner" {
  description = "GitHub repository owner"
  type        = string
  default     = ""
}

variable "github_repository" {
  description = "GitHub repository name"
  type        = string
  default     = ""
}