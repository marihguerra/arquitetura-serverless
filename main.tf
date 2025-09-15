terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.9.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_sqs_queue" "my_queue" {
  name = "orders_queue"
}

resource "aws_dynamodb_table" "my_table" {
  name           = "orders-table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

resource "aws_lambda_event_source_mapping" "sqs_to_lambda2" {
  event_source_arn = aws_sqs_queue.orders_queue.arn
  function_name    = aws_lambda_function.lambda2.arn
  batch_size       = 10
}

resource "aws_cloudwatch_metric_alarm" "dynamodb_insert_alarm" {
  alarm_name          = "DynamoDBInsertAlarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "SuccessfulRequestLatency"
  namespace           = "AWS/DynamoDB"
  period              = 60
  statistic           = "Sum"
  threshold           = 1

  dimensions = {
    TableName = aws_dynamodb_table.orders_table.name
  }

  alarm_description = "Alarme para novas inserções na tabela DynamoDB"
}