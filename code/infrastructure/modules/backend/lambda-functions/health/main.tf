data "aws_iam_policy_document" "health_function_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = [ "sts:AssumeRole" ]
  }
}

resource "aws_iam_role" "lambda_health_role" {
  name = "lambda_execution_role"
  assume_role_policy = data.aws_iam_policy_document.health_function_assume_role.json
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role = aws_iam_role.lambda_health_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "archive_file" "function_file" {
  type = "zip"
  source_file = "${path.module}/function/health.py"
  output_path = "${path.module}/function/health.zip"
}

resource "aws_lambda_function" "health_function" {
  filename = data.archive_file.function_file.output_path
  function_name = "health"
  role = aws_iam_role.lambda_health_role.arn
  handler = "health.lambda_handler"
  source_code_hash = data.archive_file.function_file.output_base64sha256
  runtime = "python3.9"

  tags = {
    environemnt = var.environemnt
  }
}
