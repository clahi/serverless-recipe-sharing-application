output "delete_lambda_function_name" {
  value = aws_lambda_function.delete_lambda_function.function_name
  description = "The function name"
}

output "delete_lambda_recipes_invoke_arn" {
  value = aws_lambda_function.delete_lambda_function.invoke_arn
  description = "The invoke arn of the lambda function."
}