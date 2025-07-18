variable "stage_name" {
  description = "The stage name to deploy to."
  type = string
}

variable "pool_client" {
  description = "The cognito pool client audience"
}

variable "cognito_pool_user_endpoint" {
  description = "The cognito user pool endpoint to be used by httpi authorizer."
  type = string
}

variable "lambda_auth_invoke_arn" {
  description = "The invoke arn from the auth lambda function"
}