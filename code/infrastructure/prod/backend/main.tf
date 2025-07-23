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

  # Auth lambda function
  auth_function_name              = module.auth_lambda.function_name
  auth_lambda_auth_invocation_arn = module.auth_lambda.lambda_auth_invoke_arn

  # Health checking lambda
  health_function_name         = module.health_lambda.function_name
  health_lambda_invocation_arn = module.health_lambda.lambda_health_invoke_arn

  # Get recipes lambda function
  recipes_function_name          = module.recipes_lambda.function_name
  recipes_lambda__invocation_arn = module.recipes_lambda.lambda_recipes_invoke_arn

  # Post recipes lambda function
  post_recipe_function_name = module.post_recipes_lambda.post_lambda_function_name
  post_recipes_lambda__invocation_arn = module.post_recipes_lambda.lambda_post_recipes_invoke_arn

  # Lambda function for deleting recipe
  delete_recipe_function_name = module.delete_recipe_lambda.delete_lambda_function_name
  delete_recipes_lambda__invocation_arn = module.delete_recipe_lambda.delete_lambda_recipes_invoke_arn

  # Lambda function for liking a recipe
  like_recipe_function_name = module.like_recipe_lambda.like_lambda_function_name
  like_recipes_lambda__invocation_arn = module.like_recipe_lambda.like_lambda_recipe_invoke_arn
}

# A lambda function to authenticate 
module "auth_lambda" {
  source      = "../../modules/backend/lambda-functions/auth"
  environemnt = "prod"
}

# A lambda function to check the health of our api
module "health_lambda" {
  source      = "../../modules/backend/lambda-functions/health"
  environemnt = "prod"

}

# A lambda function get recipes from the dynamodb
module "get_recipes_lambda" {
  source      = "../../modules/backend/lambda-functions/get-recipes"
  environemnt = "prod"

  dynamodb_table_arn = module.dynamoDB.dynamo_arn
}

# A lambda function to post recipes to the dynamodb
module "post_recipes_lambda" {
  source = "../../modules/backend/lambda-functions/post-recipes"
  environemnt = "prod"
  dynamodb_table_arn = module.dynamoDB.dynamo_arn
}

# A lambda function to delete a recipe
module "delete_recipe_lambda" {
  source = "../../modules/backend/lambda-functions/delete-recipe"
  environemnt = "prod"
  dynamodb_table_arn = module.dynamoDB.dynamo_arn
}

# A lambda function to like a recipe
module "like_recipe_lambda" {
  source = "../../modules/backend/lambda-functions/like-recipe"
  environemnt = "prod"
  dynamodb_table_arn = module.dynamoDB.dynamo_arn
}