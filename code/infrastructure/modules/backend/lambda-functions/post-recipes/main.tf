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

resource "aws_iam_role" "post_recipes_lambda_role" {
  name = "post-recipes-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_docuemnt.json
}

resource "aws_iam_role_policy_attachment" "post_recipes_role_attachemnt" {
  role = aws_iam_role.post_recipes_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"

}



resource "aws_iam_policy" "post_to_dynamodb_policy" {
  name = "LambdaDynamoDBPutAccess"
  description = "Allows post access to DynamoDB table."

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
        {
            Action = ["dynamodb:PutItem"],
            Effect = "Allow",
            Resource = var.dynamodb_table_arn
        }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "dynamodb_post" {
  role = aws_iam_role.post_recipes_lambda_role.name
  policy_arn = aws_iam_policy.post_to_dynamodb_policy.arn
}

data "archive_file" "function_file" {
  type = "zip"
  source_file = "${path.module}/function/post.py"
  output_path = "${path.module}/function/post.zip"
}

resource "aws_lambda_function" "post_lambda_function" {
  filename = data.archive_file.function_file.output_path
  function_name = "post-recipes"
  role = aws_iam_role.post_recipes_lambda_role.arn
  handler = "post.lambda_handler"
  source_code_hash = data.archive_file.function_file.output_base64sha256
  runtime = "python3.9"
  timeout = 60

  layers = [ "arn:aws:lambda:${var.region}:017000801446:layer:AWSLambdaPowertoolsPythonV2:68" ]

  tags = {
    environemnt = var.environemnt
  }

}