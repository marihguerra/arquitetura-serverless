terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.9.0"
    }
  }
}

provider "aws"{
  region = "us-east-2"
}

resource "aws_s3_bucket" "my-bucket" {
  bucket = "bucketpanqueca3"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
    ManagedBy = "Terraform"
  }
}


resource "aws_s3_bucket_ownership_controls" "my-bucket" {
  bucket = aws_s3_bucket.my-bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "my-bucket" {
  bucket = aws_s3_bucket.my-bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "my-bucket" {
  depends_on = [
    aws_s3_bucket_ownership_controls.my-bucket,
    aws_s3_bucket_public_access_block.my-bucket,
  ]

  bucket = aws_s3_bucket.my-bucket.id
  acl    = "public-read"
}