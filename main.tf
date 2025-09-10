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

