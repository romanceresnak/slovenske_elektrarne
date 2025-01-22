resource "aws_api_gateway_rest_api" "qa_api" {
  name = "qa-api"
}

resource "aws_api_gateway_resource" "questions" {
  rest_api_id = aws_api_gateway_rest_api.qa_api.id
  parent_id   = aws_api_gateway_rest_api.qa_api.root_resource_id
  path_part   = "questions"
}

resource "aws_api_gateway_method" "get_question" {
  rest_api_id   = aws_api_gateway_rest_api.qa_api.id
  resource_id   = aws_api_gateway_resource.questions.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "qa_lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.qa_api.id
  resource_id             = aws_api_gateway_resource.questions.id
  http_method             = aws_api_gateway_method.get_question.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.qa_handler.invoke_arn
}

output "api_gateway_url" {
  value = aws_api_gateway_rest_api.qa_api.execution_arn
}
