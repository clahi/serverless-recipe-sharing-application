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

resource "aws_iam_role" "like_recipes_lambda_role" {
  name = "like-recipes-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_docuemnt.json
}

resource "aws_iam_role_policy_attachment" "like_recipes_role_attachemnt" {
  role = aws_iam_role.like_recipes_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"

}

resource "aws_iam_policy" "like_recipe_in_dynamodb_policy" {
  name = "LambdaDynamoDBUpdateAccess"
  description = "Allows post access to DynamoDB table."

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
        {
            Action = ["dynamodb:UpdateItem"],
            Effect = "Allow",
            Resource = var.dynamodb_table_arn
        }
    ]
    
  })
}

resource "aws_iam_role_policy_attachment" "like_policy_attachment" {
  role = aws_iam_role.like_recipes_lambda_role.name
  policy_arn = aws_iam_policy.like_recipe_in_dynamodb_policy.arn
}

data "archive_file" "function_file" {
  type = "zip"
  source_file = "${path.module}/function/like.py"
  output_path = "${path.module}/function/like.zip"
}

resource "aws_lambda_function" "like_lambda_function" {
  filename = data.archive_file.function_file.output_path
  function_name = "like-recipe"
  role = aws_iam_role.like_recipes_lambda_role.arn
  handler = "like.lambda_handler"
  source_code_hash = data.archive_file.function_file.output_base64sha256
  runtime = "python3.9"
  timeout = 60


  tags = {
    environemnt = var.environemnt
  }

}