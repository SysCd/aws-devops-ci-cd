terraform {
  backend "s3" {
    bucket         = "my-new-terraform-state-bucket-101010"  # Your S3 bucket name
    key            = "state/terraform.tfstate"    # File path inside S3
    region         = "eu-west-2"                  # AWS London region
    encrypt        = true                         # Encrypt the state file
    dynamodb_table = "terraform-locks"            # DynamoDB table for state locking
  }
}
