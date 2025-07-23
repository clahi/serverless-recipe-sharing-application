data "aws_iam_policy_document" "lambda_assume_docuemnt" {
  statement {
    effect = "Allow"
    actions = [ "sts:AssumeRole" ]
    principals {
      type = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "delete_recipes_lambda_role" {
  name = "delete-recipes-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_docuemnt.json
}

resource "aws_iam_role_policy_attachment" "delete_recipes_role_attachemnt" {
  role = aws_iam_role.delete_recipes_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"

}

resource "aws_iam_policy" "delete_from_dynamodb_policy" {
  name = "LambdaDynamoDBDeletAccess"
  description = "Allows delete access to DynamoDB table."

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
        {
            Action = ["dynamodb:DeleteItem"],
            Effect = "Allow",
            Resource = var.dynamodb_table_arn
        }
    ],
    
  })
}

resource "aws_iam_role_policy_attachment" "dynamodb_delete" {
  role = aws_iam_role.delete_recipes_lambda_role.name
  policy_arn = aws_iam_policy.delete_from_dynamodb_policy.arn
}

data "archive_file" "function_file" {
  type = "zip"
  source_file = "${path.module}/function/delete.py"
  output_path = "${path.module}/function/delete.zip"
}

resource "aws_lambda_function" "delete_lambda_function" {
  filename = data.archive_file.function_file.output_path
  function_name = "delete-recipes"
  role = aws_iam_role.delete_recipes_lambda_role.arn
  handler = "delete.lambda_handler"
  source_code_hash = data.archive_file.function_file.output_base64sha256
  runtime = "python3.9"
  timeout = 60

  # layers = [ "arn:aws:lambda:${var.region}:017000801446:layer:AWSLambdaPowertoolsPythonV2:68" ]

  tags = {
    environemnt = var.environemnt
  }

}