resource "aws_s3_bucket" "exo_bucket" {

  count = var.bucket_number
  bucket = "exo-terraform-493-${count.index}"

  tags = {
    Name = "Bucket name"
  }
}