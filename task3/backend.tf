# resource "aws_s3_bucket" "state_file" {
#   bucket = "terraform-state-file-task3"

#   lifecycle {
#     prevent_destroy = true
#   }
# }

# resource "aws_s3_bucket_versioning" "s3_version" {
#   bucket = aws_s3_bucket.state_file.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# resource "aws_dynamodb_table" "lock_state" {
#   name         = "lock-state-terraform"
#   hash_key     = "LockID"
#   billing_mode = "PAY_PER_REQUEST"

#   attribute {
#     name = "LockID"
#     type = "S"
#   }
# }

# terraform {
#   backend "s3" {
#     bucket         = "terraform-state-file-task3"
#     key            = "terraform.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "lock-state-terraform"
#     encrypt        = true
#   }
# }