terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 4.5"
    }
  }
  required_version = ">= 1.7"
}

provider "aws" {
  region = "us-east-1"
}

module "congnito" {
  source = "../../modules/backend/cognito"
  username = "Abdala"
  email = "clahimoha1000@gmail.com"
}

module "auth_lambda" {
  source = "../../modules/backend/lambda/auth"
  environemnt = "prod"
  api_arn = module.http_api.httpi_arn

}

module "http_api" {
  source = "../../modules/backend/HTTP-API"
  stage_name = "prod"
  pool_client = module.congnito.user_poo_client_id
  cognito_pool_user_endpoint = module.congnito.cognito_endpoint
  lambda_auth_invoke_arn = module.auth_lambda.lambda_auth_invoke_arn
}

module "dynamoDB" {
  source = "../../modules/backend/data-store/dynamoDB"
  
}