# Dynamic AWS IAM user with custom policy
resource "infisical_dynamic_secret_aws_iam" "app_user" {
  name             = "app-dynamic-user" 
  project_slug     = var.project_slug
  environment_slug = var.environment
  path             = "/infrastructure/aws"
  
  default_ttl = var.aws_default_ttl
  max_ttl     = var.aws_max_ttl
  
  configuration = {
    method = "access_key"
    
    access_key_config = {
      access_key        = var.aws_access_key_id
      secret_access_key = var.aws_secret_access_key
    }
    
    region = var.aws_region
    
    aws_path = "/infisical/dynamic/"
    
    policy_arns = var.aws_policy_arns
    
    policy_document = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = var.aws_allowed_actions
          Resource = var.aws_allowed_resources
        }
      ]
    })
  }
  
  username_template = "infisical-{{randomUsername}}-{{timestamp}}"
}

# Dynamic AWS IAM for S3 access
resource "infisical_dynamic_secret_aws_iam" "s3_access" {
  name             = "s3-dynamic-access"
  project_slug     = var.project_slug
  environment_slug = var.environment
  path             = "/infrastructure/aws"
  
  default_ttl = "2h"
  max_ttl     = "4h"
  
  configuration = {
    method = "access_key"
    
    access_key_config = {
      access_key        = var.aws_access_key_id
      secret_access_key = var.aws_secret_access_key
    }
    
    region = var.aws_region
    
    aws_path = "/infisical/dynamic/"
    
    policy_document = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "s3:GetObject",
            "s3:PutObject",
            "s3:DeleteObject"
          ]
          Resource = "arn:aws:s3:::${var.s3_bucket_name}/*"
        },
        {
          Effect = "Allow"
          Action = [
            "s3:ListBucket"
          ]
          Resource = "arn:aws:s3:::${var.s3_bucket_name}"
        }
      ]
    })
  }
  
  username_template = "s3-{{randomUsername}}-{{timestamp}}"
}

# Dynamic AWS IAM for deployment operations
resource "infisical_dynamic_secret_aws_iam" "deployment" {
  name             = "deployment-credentials"
  project_slug     = var.project_slug
  environment_slug = var.environment
  path             = "/ci-cd"
  
  default_ttl = "1h"
  max_ttl     = "2h"
  
  configuration = {
    method = "access_key"
    
    access_key_config = {
      access_key        = var.aws_access_key_id
      secret_access_key = var.aws_secret_access_key
    }
    
    region = var.aws_region
    
    aws_path = "/deployment/"
    permission_boundary_policy_arn = var.permission_boundary_arn
    
    policy_arns = join(",", [
      "arn:aws:iam::aws:policy/AmazonECSTaskExecutionRolePolicy",
      "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
    ])
    
    policy_document = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "ecs:UpdateService",
            "ecs:DescribeServices",
            "cloudformation:DescribeStacks",
            "cloudformation:UpdateStack"
          ]
          Resource = "*"
        }
      ]
    })
  }
  
  username_template = "deploy-{{randomUsername}}-{{timestamp}}"
}