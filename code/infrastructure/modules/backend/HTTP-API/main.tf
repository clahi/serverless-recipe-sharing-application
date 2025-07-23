# IAM role for API Gateway to write logs
resource "aws_iam_role" "api_gw_cloudwatch_role" {
  name = "api-gw-cloudwatch-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "apigateway.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "api_gw_logs" {
  role = aws_iam_role.api_gw_cloudwatch_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}


resource "aws_apigatewayv2_api" "http_api" {
  name = "http-api"
  protocol_type = "HTTP"
  description = "Recipe Sharing Applicatoin - Serverless API"
  cors_configuration {
    allow_origins = [ "*" ]
    allow_methods = [ "GET", "POST", "PUT", "DELETE" ]
    allow_headers = [ "*" ]
  }

  
}

resource "aws_apigatewayv2_stage" "http_api_stage" {
  api_id = aws_apigatewayv2_api.http_api.id
  name = var.stage_name
  auto_deploy = true

   # Enable detailed logging
  default_route_settings {
    throttling_burst_limit = 100
    throttling_rate_limit  = 50
    detailed_metrics_enabled = true
    logging_level           = "INFO"
    data_trace_enabled      = true
  }

  # Access logging configuration
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw_logs.arn
    format = jsonencode({
      requestId        = "$context.requestId"
      ip               = "$context.identity.sourceIp"
      requestTime      = "$context.requestTime"
      httpMethod       = "$context.httpMethod"
      routeKey         = "$context.routeKey"
      status           = "$context.status"
      protocol         = "$context.protocol"
      responseLength   = "$context.responseLength"
      integrationError = "$context.integration.error"
    })
  }

  
}

# CloudWatch Log Group for API Gateway
resource "aws_cloudwatch_log_group" "api_gw_logs" {
  name              = "/aws/apigateway/${aws_apigatewayv2_api.http_api.name}"
  retention_in_days = 7
}

resource "aws_apigatewayv2_authorizer" "authorizer" {
  api_id                            = aws_apigatewayv2_api.http_api.id
  name                              = "CognitoAuthorizer"
  authorizer_type                   = "JWT"
  identity_sources                  = ["$request.header.Authorization"]
  # authorizer_payload_format_version = "2.0"

  jwt_configuration {
    audience = [var.pool_client]
    issuer = var.cognito_issuer_url
  }
}

resource "aws_apigatewayv2_route" "auth_route" {
  api_id = aws_apigatewayv2_api.http_api.id

  route_key = "GET /auth"

  target = "integrations/${aws_apigatewayv2_integration.auth_api_lambda_integration.id}"

   depends_on = [aws_apigatewayv2_integration.auth_api_lambda_integration]
}

resource "aws_apigatewayv2_integration" "auth_api_lambda_integration" {
  api_id = aws_apigatewayv2_api.http_api.id
  integration_type = "AWS_PROXY"
  integration_uri = var.auth_lambda_auth_invocation_arn
  payload_format_version = "2.0"

  # depends_on = [ aws_apigatewayv2_api.http_api, aws_lambda_function.testauth ]
  
}

resource "aws_lambda_permission" "lambda_permission_auth" {
  statement_id = "AllowExecutionFromRestApi"
  action = "lambda:InvokeFunction"
  function_name = var.auth_function_name
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"

  depends_on = [
    aws_apigatewayv2_route.auth_route,
    aws_apigatewayv2_stage.http_api_stage
  ]
}

# Route /health

resource "aws_apigatewayv2_route" "health_route" {
  api_id = aws_apigatewayv2_api.http_api.id

  route_key = "ANY /health"

  target = "integrations/${aws_apigatewayv2_integration.health_api_lambda_integration.id}"

   depends_on = [aws_apigatewayv2_integration.health_api_lambda_integration]
}

resource "aws_apigatewayv2_integration" "health_api_lambda_integration" {
  api_id = aws_apigatewayv2_api.http_api.id
  integration_type = "AWS_PROXY"

  integration_uri = var.health_lambda_auth_invocation_arn
  payload_format_version = "2.0"

  
}

resource "aws_lambda_permission" "lambda_permission_health" {
  statement_id = "AllowExecutionFromHttpApi"
  action = "lambda:InvokeFunction"
  function_name = var.health_function_name
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"

  depends_on = [
    aws_apigatewayv2_route.health_route,
    aws_apigatewayv2_stage.http_api_stage
  ]
}