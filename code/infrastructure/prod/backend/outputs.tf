output "http_endpoint" {
  value       = module.http_api.http_enpoint
  description = "The URI of the API"
}

output "api_gateway_integration_uri" {
  value       = module.http_api.api_gateway_integration_uri
  description = "The integration URI for API Gateway"
}

output "execution_arn" {
  value = module.http_api.execution_arn
}

output "cognito_user_pools_Id" {
  value = module.congnito.cognito_user_pools_id
}

output "user_pool_client_id" {
  value = module.congnito.user_pool_client_id
}
