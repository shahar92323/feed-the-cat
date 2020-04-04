# IAM for main Lambda function
resource "aws_iam_role" "iam_role_lambda_main" {
  name = "${var.app_name}-main"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "iam_policy_lambda_main" {
  name = "${var.app_name}-main"
  role = aws_iam_role.iam_role_lambda_main.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "rekognition:CreateCollection",
                "rekognition:DetectLabels"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                 "${aws_cloudwatch_log_group.log_group_lambda_main.arn}/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:Get*"
            ],
            "Resource": "${aws_s3_bucket.main.arn}/*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "dynamodb:PutItem"
            ],
            "Resource": "${aws_dynamodb_table.main.arn}"
        }
    ]
}
EOF
}

# IAM for monitor Lambda function
resource "aws_iam_role" "iam_role_lambda_monitor" {
  name = "${var.app_name}-monitor"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "iam_policy_lambda_monitor" {
  name = "${var.app_name}-monitor"
  role = aws_iam_role.iam_role_lambda_monitor.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                 "${aws_cloudwatch_log_group.log_group_lambda_monitor.arn}/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "dynamodb:PutItem",
                "dynamodb:UpdateItem",
                "dynamodb:GetItem"
            ],
            "Resource": "${aws_dynamodb_table.main.arn}"
        },
        {
            "Effect": "Allow",
            "Action": [
              "ses:SendEmail"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}