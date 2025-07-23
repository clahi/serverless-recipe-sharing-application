variable "stage_name" {
  description = "The stage name to deploy to."
  type = string
}

variable "pool_client" {
  description = "The cognito pool client audience"
}

# variable "cognito_pool_user_endpoint" {
#   description = "The cognito user pool endpoint to be used by httpi authorizer."
#   type = string
# }

variable "cognito_issuer_url" {
  description = "The cognito issuer url to be used by httpi authorizer."
  type = string
}

variable "environemnt" {
  description = "The environment to deploy to."
  type = string
}

variable "auth_function_name" {
  description = "The authentication lambda function name"
  type = string
}

variable "auth_lambda_auth_invocation_arn" {
  description = "The authentication lambda invocation arn"
  type = string
}

variable "health_function_name" {
  description = "The health lambda function name"
  type = string
}

variable "health_lambda_invocation_arn" {
  description = "The health lambda invocation arn"
  type = string
}

variable "recipes_function_name" {
  description = "The recipes lambda function name"
  type = string
}

variable "recipes_lambda__invocation_arn" {
  description = "The recipes lambda invocation arn"
  type = string
}

# Post function
variable "post_recipe_function_name" {
  description = "The post recipes lambda function name"
  type = string
}

variable "post_recipes_lambda__invocation_arn" {
  description = "The post recipes lambda invocation arn"
  type = string
}

# Delete function
variable "delete_recipe_function_name" {
  description = "The delete recipe function name"
  type = string
}

variable "delete_recipes_lambda__invocation_arn" {
  description = "The delete recipe lambda function invok arn"
  type = string
}
