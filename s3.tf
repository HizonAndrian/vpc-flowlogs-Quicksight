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

resource "aws_s3_bucket" "s3_athena" {
  bucket = "athena-results-for-quicksight"
}


resource "aws_s3_bucket_policy" "s3_policy" {
  bucket = aws_s3_bucket.s3_bucket.id
  policy = data.aws_iam_policy_document.s3_policy_document.json
}