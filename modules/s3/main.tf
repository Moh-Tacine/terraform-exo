resource "aws_s3_bucket" "exo_bucket" {
  bucket = var.bucket_unique_name

  tags = {
    Name = "Bucket name"
  }
}