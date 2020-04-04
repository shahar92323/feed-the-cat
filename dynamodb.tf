resource "aws_dynamodb_table" "main" {
  name           = var.app_name
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "PK"

  attribute {
    name = "PK"
    type = "S"
  }

  tags = {
    Name = var.app_name
  }
}

