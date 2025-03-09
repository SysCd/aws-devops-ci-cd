terraform {
  backend "s3" {
    bucket         = "terraform-state-207567758913"  # Must create this S3 bucket first
    region         = "eu-west-2"
    encrypt        = true
    dynamodb_table = "terraform-lock"  # Must create this DynamoDB table first
  }
}