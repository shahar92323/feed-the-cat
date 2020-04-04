# CloudWatch log groups for main Lambda function
resource "aws_cloudwatch_log_group" "log_group_lambda_main" {
  name              = "/aws/lambda/${var.app_name}-main"
  retention_in_days = 7
}

# CloudWatch for monitor Lambda function
resource "aws_cloudwatch_log_group" "log_group_lambda_monitor" {
  name              = "/aws/lambda/${var.app_name}-monitor"
  retention_in_days = 7
}

# Trigger Lambda monitor
resource "aws_cloudwatch_event_rule" "trigger_monitor_lambda" {
  name                = "${var.app_name}-event-rule"
  depends_on          = [aws_lambda_function.lambda_monitor]
  schedule_expression = "rate(5 minutes)"
}

resource "aws_cloudwatch_event_target" "event_target_monitor_lambda" {
  target_id = aws_lambda_function.lambda_monitor.function_name
  rule      = aws_cloudwatch_event_rule.trigger_monitor_lambda.name
  arn       = aws_lambda_function.lambda_monitor.arn
}

resource "aws_lambda_permission" "invoke_permission_monitor_lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_monitor.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.trigger_monitor_lambda.arn
}