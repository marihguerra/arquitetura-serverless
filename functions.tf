# Lambda tests: {"id": "123", "data": "teste"} OR {"body": "{\"productName\":\"Test Product\",\"quantity\":3}"}
# AND {"body": "{\"productName\":\"Test Product 2\",\"quantity\":2}"}

resource "aws_lambda_function" "lambda1" {
  function_name = "submit_lambda"
  handler       = "submit_lambda.lambda_handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_exec.arn
  filename      = "submit_lambda.zip"

  environment {
    variables = {
      QUEUE_URL = aws_sqs_queue.my_queue.id
    }
  }
}

resource "aws_lambda_function" "lambda2" {
  function_name = "process_lambda"
  handler       = "process_lambda.lambda_handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_exec.arn
  filename      = "process_lambda.zip"
}

resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Effect = "Allow"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_sqs_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_db_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}