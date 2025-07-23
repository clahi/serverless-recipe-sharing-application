output "like_lambda_function_name" {
  value = aws_lambda_function.like_lambda_function.function_name
  description = "The function name"
}

output "like_lambda_recipe_invoke_arn" {
  value = aws_lambda_function.like_lambda_function.invoke_arn
  description = "The invoke arn of the lambda function."
}