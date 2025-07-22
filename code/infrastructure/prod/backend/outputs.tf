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

output "invoke_arn" {
  value = module.http_api.invoke_arn
}