output "execution_arn" {
  value = aws_apigatewayv2_api.http_api.execution_arn
  description = "The source arn for the api."
}

output "http_enpoint" {
  value = aws_apigatewayv2_api.http_api.api_endpoint
  description = "URI of the API"
}

output "api_gateway_integration_uri" {
  value = aws_apigatewayv2_integration.auth_api_lambda_integration.integration_uri
  description = "The integration URI for API Gateway"
}