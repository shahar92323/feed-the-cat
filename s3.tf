resource "aws_s3_bucket" "main" {
  bucket = var.app_name
  acl    = "private"

  tags = {
    Name = var.app_name
  }

  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket                  = aws_s3_bucket.main.id
  ignore_public_acls      = true
  restrict_public_buckets = true
  block_public_acls       = true
  block_public_policy     = true
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.main.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.lambda_main.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_bucket]
}

