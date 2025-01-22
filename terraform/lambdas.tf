resource "aws_iam_role" "lambda_role" {
  name = "lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_lambda_function" "textract_processor" {
  filename         = "../lambdas/textract_processor/lambda_function.zip"
  function_name    = "textract-processor"
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.9"
  source_code_hash = filebase64sha256("../lambdas/textract_processor/lambda_function.zip")
}

resource "aws_lambda_function" "qa_handler" {
  filename         = "../lambdas/qa_handler/lambda_function.zip"
  function_name    = "qa-handler"
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.9"
  source_code_hash = filebase64sha256("../lambdas/qa_handler/lambda_function.zip")
}
