variable "project_name" {
  description = "Name of the Infisical project"
  type        = string
  default     = "my-app"
}

variable "project_slug" {
  description = "URL-friendly identifier for the project"
  type        = string
  default     = "my-app"
}

variable "environments" {
  description = "List of environments to create"
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

variable "stripe_prod_key" {
  description = "Stripe production API key"
  type        = string
  sensitive   = true
  default     = ""
}

variable "stripe_test_key" {
  description = "Stripe test API key"
  type        = string
  sensitive   = true
  default     = ""
}

variable "create_aws_resources" {
  description = "Whether to create AWS resources (Lambda, ECS)"
  type        = bool
  default     = false
}

variable "create_kubernetes_resources" {
  description = "Whether to create Kubernetes resources"
  type        = bool
  default     = false
}