output "aws_dynamic_secrets" {
  value = {
    app_user_name   = infisical_dynamic_secret_aws_iam.app_user.name
    s3_access_name  = infisical_dynamic_secret_aws_iam.s3_access.name
    deployment_name = infisical_dynamic_secret_aws_iam.deployment.name
  }
  description = "Names of AWS dynamic secret configurations"
}

output "database_dynamic_secrets" {
  value = {
    postgres_readonly = var.enable_postgres_dynamic ? infisical_dynamic_secret_sql_database.postgres_readonly[0].name : null
    mysql_app        = var.enable_mysql_dynamic ? infisical_dynamic_secret_sql_database.mysql_app[0].name : null
    mongodb_app      = var.enable_mongodb_dynamic ? infisical_dynamic_secret_mongodb.app_user[0].name : null
  }
  description = "Names of database dynamic secret configurations"
}

output "kubernetes_dynamic_secret" {
  value = var.enable_kubernetes_dynamic ? infisical_dynamic_secret_kubernetes.app_service_account[0].name : null
  description = "Name of Kubernetes dynamic secret configuration"
}

output "usage_instructions" {
  value = {
    aws = "Use Infisical SDK/CLI to request AWS credentials: infisical secrets get --path=/infrastructure/aws --env=${var.environment}"
    database = "Use Infisical SDK/CLI to request database credentials: infisical secrets get --path=/database/dynamic --env=${var.environment}"
    kubernetes = "Use Infisical SDK/CLI to request Kubernetes tokens: infisical secrets get --path=/kubernetes/dynamic --env=${var.environment}"
  }
  description = "Instructions for consuming dynamic secrets"
}