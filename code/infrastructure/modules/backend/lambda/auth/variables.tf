variable "lambda_auth_tester_source_file_path" {
  description = "The lambda function file responsible for authentication"
}

variable "lambda_auth_tester_source_code_hash" {
  description = "The source code hash."
}

variable "environemnt" {
  description = "The environment to deploy to."
  type = string
}

variable "api_arn" {
  description = "The api gateway arn which will invoke the lambda function"
  
}