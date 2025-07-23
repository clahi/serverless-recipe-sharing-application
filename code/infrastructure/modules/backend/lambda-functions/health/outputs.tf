output "lambda_health_invoke_arn" {
  value = aws_lambda_function.health_function.invoke_arn
  description = "The source arn of the lambda function."
}

output "function_name" {
  value = aws_lambda_function.health_function.function_name
  description = "The function name to be used by lambda permission."
}