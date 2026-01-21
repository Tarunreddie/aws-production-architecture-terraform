terraform {
  backend "s3" {
    bucket         = "YOUR_UNIQUE_TF_STATE_BUCKET_NAME"
    key            = "aws-production-autohealing/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
