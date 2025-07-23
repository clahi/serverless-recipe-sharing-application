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

module "dynamoDB" {
  source = "../../modules/backend/data-store/dynamoDB"

}

module "http_api" {
  source             = "../../modules/backend/HTTP-API"
  stage_name         = "prod"
  pool_client        = module.congnito.user_poo_client_id
  cognito_issuer_url = module.congnito.cognito_issuer_url
  environemnt        = "prod"

  auth_function_name              = module.auth_lambda.function_name
  auth_lambda_auth_invocation_arn = module.auth_lambda.lambda_auth_invoke_arn

  health_function_name              = module.health_lambda.function_name
  health_lambda_auth_invocation_arn = module.health_lambda.lambda_health_invoke_arn
}

module "auth_lambda" {
  source      = "../../modules/backend/lambda-functions/auth"
  environemnt = "prod"
}

module "health_lambda" {
  source      = "../../modules/backend/lambda-functions/health"
  environemnt = "prod"
}