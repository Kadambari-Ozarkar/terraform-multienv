resource "aws_s3_bucket" "main" {
  bucket = "${var.environment}-app-storage-demo"

  tags = {
    Environment = var.environment
  }
}