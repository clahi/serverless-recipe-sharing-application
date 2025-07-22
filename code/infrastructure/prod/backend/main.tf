terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.5"
    }
  }
  required_version = ">= 1.7"
}

provider "aws" {
  region = "us-east-1"
}

module "congnito" {
  source   = "../../modules/backend/cognito"
  username = "Abdala"
  email    = "clahimoha1000@gmail.com"
}

# module "auth_lambda" {
#   source      = "../../modules/backend/lambda/auth"
#   environemnt = "prod"
# #   api_arn     = module.http_api.httpi_arn
#   api_execution_arn = module.http_api.execution_arn
# }

module "http_api" {
  source             = "../../modules/backend/HTTP-API"
  stage_name         = "prod"
  pool_client        = module.congnito.user_poo_client_id
  cognito_issuer_url = module.congnito.cognito_issuer_url
  environemnt        = "prod"
}

module "dynamoDB" {
  source = "../../modules/backend/data-store/dynamoDB"

}