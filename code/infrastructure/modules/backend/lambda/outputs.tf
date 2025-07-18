output "lambda_auth_invoke_arn" {
  value = aws_lambda_function.testauth.invoke_arn
  description = "The source arn of the lambda function."
}