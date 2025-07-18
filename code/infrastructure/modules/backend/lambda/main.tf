data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = [ "sts:AssumeRole" ]
  }
}

resource "aws_iam_role" "lambda_auth_role" {
  name = "lambda_execution_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_lambda_function" "testauth" {
  filename = var.lambda_auth_tester_source_file_path
  function_name = "testauth"
  role = aws_iam_role.lambda_auth_role.arn
  handler = "index.handler"
  source_code_hash = var.lambda_auth_tester_source_code_hash
  runtime = "python3.9"

  tags = {
    environemnt = var.environemnt
  }
}

resource "aws_lambda_permission" "lambda_permission_auth" {
  statement_id = "AllowExecutionFromHttpApi"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.testauth.function_name
  principal = "apigateway.amazonaws.com"
  source_arn = var.api_arn + "/*/*"
}