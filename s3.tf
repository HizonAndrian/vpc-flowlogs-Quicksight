data "aws_iam_policy_document" "s3_policy_document" {
  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.s3_bucket.arn}/*"]
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"

      values = ["bucket-owner-full-control"]
    }
  }
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "vpc-flowlogs-quicksight"
  force_destroy = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_encryption" {
  bucket = aws_s3_bucket.s3_bucket.id
  
  rule {
     apply_server_side_encryption_by_default {
       sse_algorithm = "AES256"
     }
  }
}

resource "aws_s3_bucket_versioning" "s3_versioning" {
  bucket = aws_s3_bucket.s3_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "s3_lifecycle" {
  bucket = aws_s3_bucket.s3_bucket.id

  rule {
    id = "30days-rule"

    # expiration {
    #   days = 90
    # }

    filter {
      prefix = ""
    }

    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days = 60
      storage_class = "STANDARD_IA"
    }

    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "s3_policy" {
  bucket = aws_s3_bucket.s3_bucket.id
  policy = data.aws_iam_policy_document.s3_policy_document.json
}

resource "aws_s3_bucket" "s3_athena" {
  bucket = "athena-results-for-quicksight"
  force_destroy = true
}