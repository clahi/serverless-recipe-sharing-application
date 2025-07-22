output "http_endpoint" {
  value = module.http_api.http_enpoint
  description = "The URI of the API"
}

output "api_gateway_integration_uri" {
  value = module.http_api.api_gateway_integration_uri
  description = "The integration URI for API Gateway"
}