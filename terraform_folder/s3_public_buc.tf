# resource "aws_s3_bucket" "website_host" {
#   bucket = var.website_bucket_name_public

#   versioning {
#     enabled = true
#   }

#     tags = {
#     Name        = "Website"
#     Environment = "production"
#   }

#     website {
#     index_document = var.web_hosting_file_s3
#   }


#   cors_rule {
#     allowed_headers = ["*"]
#     allowed_methods = ["PUT", "POST", "HEAD", "GET"]
#     allowed_origins = ["*"]
#     expose_headers  = ["ETag"]
#     max_age_seconds = 3000
#   }

# }

# resource "aws_s3_bucket_acl" "aws_acl_configure" {
#     bucket = aws_s3_bucket.website_host.id
#     acl = "public-read"
# }

# resource "aws_s3_bucket_policy" "hosting_bucket_policy" {
#     bucket = aws_s3_bucket.website_host.id

#     policy = <<EOF
#     {
#     "Version": "2008-10-17",
#     "Statement": [
#         {
#         "Sid": "PublicReadForGetBucketObjects",
#         "Effect": "Allow",
#         "Principal": {
#             "AWS": "*"
#         },
#         "Action": ["s3:GetObject","s3:PutObject","s3:DeleteObject","s3:GetBucketPolicy"],
        
#         "Resource": "arn:aws:s3:::${var.website_bucket_name_public}/*"

      
#         }
#     ]
#     }
# EOF
# }

# resource "aws_s3_bucket_ownership_controls" "website_host" {
#   bucket = aws_s3_bucket.website_host.id
#   rule {
#     object_ownership = "BucketOwnerPreferred"
#   }
# }

# resource "aws_s3_bucket_public_access_block" "website_host" {
#   bucket = aws_s3_bucket.website_host.id

#   block_public_acls       = false
#   block_public_policy     = false
#   ignore_public_acls      = false
#   restrict_public_buckets = false
# }


# resource "aws_s3_object" "index" {
#   bucket       = aws_s3_bucket.website_host.id
#   key          = "${var.web_hosting_folder_s3}/${var.web_hosting_file_s3}"
#   source       = "../website/front-end/index.html"
#   etag         = filemd5("../website/front-end/index.html")
#   content_type = "text/html"

#   depends_on = [aws_s3_bucket.website_host]
# }

# resource "aws_s3_object" "upload_file" {
#   bucket       = aws_s3_bucket.website_host.id
#   key          = "${var.web_hosting_folder_s3}/upload.html"
#   source       = "../website/front-end/upload.html"
#   etag         = filemd5("../website/front-end/upload.html")
#   content_type = "text/html"

#   depends_on = [aws_s3_bucket.website_host]
# }

# resource "aws_s3_object" "js" {
#   bucket = aws_s3_bucket.website_host.id
#   key    = "${var.web_hosting_folder_s3}/script.js"
#   source = "../website/front-end/script.js"
#   etag   = filemd5("../website/front-end/script.js")
#   content_type = "text/javascript"
#  }


# resource "aws_s3_object" "fontcss" {
#   bucket = aws_s3_bucket.website_host.id
#   key    = "${var.web_hosting_folder_s3}/style.css"
#   source = "../website/front-end/style.css"
#   etag   = filemd5("../website/front-end/style.css")
#   content_type = "text/css"
# }

# resource "aws_s3_object" "config_js" {
#   bucket = aws_s3_bucket.website_host.id
#   key   = "${var.web_hosting_folder_s3}/config.js"
#   source = local_file.config.filename
#   content_type = "text/javascript"
#   etag   = filemd5(local_file.config.filename)

#   depends_on = [local_file.config]
# }

resource "aws_s3_bucket" "website_host" {
  bucket = var.website_bucket_name_public

  versioning {
    enabled = true
  }

  tags = {
    Name        = "Website"
    Environment = "production"
  }

  website {
    index_document = var.web_hosting_file_s3
  }

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST", "HEAD", "GET"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_acl" "aws_acl_configure" {
  bucket = aws_s3_bucket.website_host.id
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "hosting_bucket_policy" {
  bucket = aws_s3_bucket.website_host.id

  policy = jsonencode({
    Version = "2008-10-17",
    Statement = [
      {
        Sid       = "PublicReadForGetBucketObjects",
        Effect    = "Allow",
        Principal = "*",
        Action    = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        Resource  = [
          "arn:aws:s3:::${var.website_bucket_name_public}/*"
        ]
      }
    ]
  })
}

resource "aws_s3_bucket_ownership_controls" "website_host" {
  bucket = aws_s3_bucket.website_host.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "website_host" {
  bucket = aws_s3_bucket.website_host.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.website_host.id
  key          = "${var.web_hosting_folder_s3}/${var.web_hosting_file_s3}"
  source       = "../website/front-end/index.html"
  etag         = filemd5("../website/front-end/index.html")
  content_type = "text/html"

  depends_on = [aws_s3_bucket.website_host]
}

resource "aws_s3_object" "upload_file" {
  bucket       = aws_s3_bucket.website_host.id
  key          = "${var.web_hosting_folder_s3}/upload.html"
  source       = "../website/front-end/upload.html"
  etag         = filemd5("../website/front-end/upload.html")
  content_type = "text/html"

  depends_on = [aws_s3_bucket.website_host]
}

resource "aws_s3_object" "js" {
  bucket       = aws_s3_bucket.website_host.id
  key          = "${var.web_hosting_folder_s3}/script.js"
  source       = "../website/front-end/script.js"
  etag         = filemd5("../website/front-end/script.js")
  content_type = "text/javascript"
}

resource "aws_s3_object" "fontcss" {
  bucket       = aws_s3_bucket.website_host.id
  key          = "${var.web_hosting_folder_s3}/style.css"
  source       = "../website/front-end/style.css"
  etag         = filemd5("../website/front-end/style.css")
  content_type = "text/css"
}

resource "aws_s3_object" "config_js" {
  bucket       = aws_s3_bucket.website_host.id
  key          = "${var.web_hosting_folder_s3}/config.js"
  source       = local_file.config.filename
  content_type = "text/javascript"
  etag         = filemd5(local_file.config.filename)

  depends_on = [local_file.config]
}

