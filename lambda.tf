# Main Lambda function
data "archive_file" "lambda_main_code" {
  type        = "zip"
  source_file = "${path.module}/lambda_main/lambda_function.py"
  output_path = "${path.module}/lambda_main/lambda_function.py.zip"
}

resource "aws_lambda_function" "lambda_main" {
  filename         = data.archive_file.lambda_main_code.output_path
  function_name    = "${var.app_name}-main"
  role             = aws_iam_role.iam_role_lambda_main.arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.lambda_main_code.output_base64sha256
  timeout          = 120
  memory_size      = 256
  runtime          = "python2.7"
  depends_on       = [aws_cloudwatch_log_group.log_group_lambda_main, aws_iam_role.iam_role_lambda_main]
  environment {
    variables = {
      table_name = var.app_name
    }
  }
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_main.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.main.arn
}

# Monitor Lambda function
data "archive_file" "lambda_monitor_code" {
  type        = "zip"
  source_file = "${path.module}/lambda_monitor/lambda_function.py"
  output_path = "${path.module}/lambda_monitor/lambda_function.py.zip"
}

resource "aws_lambda_function" "lambda_monitor" {
  filename         = data.archive_file.lambda_monitor_code.output_path
  function_name    = "${var.app_name}-monitor"
  role             = aws_iam_role.iam_role_lambda_monitor.arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.lambda_monitor_code.output_base64sha256
  timeout          = 120
  memory_size      = 256
  runtime          = "python2.7"
  depends_on       = [aws_cloudwatch_log_group.log_group_lambda_monitor, aws_iam_role.iam_role_lambda_monitor]
  environment {
    variables = {
      table_name      = var.app_name
      email_sender    = var.email_sender
      email_recipient = var.email_recipient
    }
  }
}