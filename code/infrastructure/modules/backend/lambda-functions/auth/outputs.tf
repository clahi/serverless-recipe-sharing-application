output "lambda_auth_invoke_arn" {
  value = aws_lambda_function.testauth.invoke_arn
  description = "The source arn of the lambda function."
}

output "function_name" {
  value = aws_lambda_function.testauth.function_name
  description = "The function name to be used by lambda permission."
}