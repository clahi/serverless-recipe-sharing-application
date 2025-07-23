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
  description = "The authentication lambda function name"
  type = string
}

variable "health_lambda_auth_invocation_arn" {
  description = "The authentication lambda invocation arn"
  type = string
}