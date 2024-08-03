resource "aws_s3_bucket" "bookshelf_bucket1" {
  bucket = var.website_bucket_name_private
  
  
  versioning {
    enabled = true
  }

  tags = {
    Name        = "product-bucket"
    Environment = "Devl"
  }
}
# resource "aws_s3_bucket_acl" "aws_acl_configure_private" {
#     bucket = aws_s3_bucket.bookshelf_bucket1.id
#     acl = "private"
# }
resource "aws_s3_bucket_cors_configuration" "bookshelf_bucket" {
  bucket = aws_s3_bucket.bookshelf_bucket1.id

  cors_rule {
  allowed_headers = ["*"]
  allowed_methods = ["GET","PUT", "POST"]
  allowed_origins = ["*"]
  expose_headers  = ["x-amz-server-side-encryption","x-amz-request-id","x-amz-id-2"]
  max_age_seconds = 3000
  }

}