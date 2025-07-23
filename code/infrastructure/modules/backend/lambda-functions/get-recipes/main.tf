data "aws_iam_policy_document" "lambda_excution_read_role" {
  statement {
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = [ "sts:AssumeRole" ]
  }
}

resource "aws_iam_role" "lambda_excution_read_role" {
  name = "lambda_excution_read_role"
  assume_role_policy = data.aws_iam_policy_document.lambda_excution_read_role.json
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role = aws_iam_role.lambda_excution_read_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy" "dynamodb_read_policy" {
  name = "LambdaDynamoDBReadAccess"
  description = "Allows read access to DynamoDB table."

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "dynamodb:GetItem",
          "dynamodb:Scan",
          "dynamodb:Query"
        ],
        Effect = "Allow",
        Resource = var.dynamodb_table_arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "dynamodb_read" {
  role = aws_iam_role.lambda_excution_read_role.name
  policy_arn = aws_iam_policy.dynamodb_read_policy.arn
}

data "archive_file" "function_file" {
  type = "zip"
  source_file = "${path.module}/function/recipes.py"
  output_path = "${path.module}/function/recipes.zip"
}

resource "aws_lambda_function" "recipes_function" {
  filename = data.archive_file.function_file.output_path
  function_name = "recipes"
  role = aws_iam_role.lambda_excution_read_role.arn
  handler = "recipes.lambda_handler"
  source_code_hash = data.archive_file.function_file.output_base64sha256
  runtime = "python3.9"

  tags = {
    environemnt = var.environemnt
  }
}
