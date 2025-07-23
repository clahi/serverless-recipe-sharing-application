output "cognito_arn" {
  value = aws_cognito_user_pool.user_pool.arn
  description = "The arn of the user pool."
}

# output "cognito_endpoint" {
#   value = aws_cognito_user_pool.user_pool.endpoint
#   description = "The endpoint name of the user pool."
# }



output "cognito_issuer_url" {
  value = "https://cognito-idp.${var.region}.amazonaws.com/${aws_cognito_user_pool.user_pool.id}"
  description = "The issuer URL for JWT authorizer"
}

output "cognito_user_pools_id" {
  value = aws_cognito_user_pool.user_pool.id
  description = "The ID of the user pool."
}

output "user_pool_client_id" {
  value = aws_cognito_user_pool_client.user_pool_client.id
  description = "The id of the user pool cient."
}
