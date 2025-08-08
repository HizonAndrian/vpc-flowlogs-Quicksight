resource "aws_glue_catalog_database" "vpc_flowlogs_db" {
  name = "vpc_flowlogs_db"
}

resource "aws_glue_crawler" "glue_crawlers" {
  database_name = aws_glue_catalog_database.vpc_flowlogs_db.name
  name          = "glue_crawlers"
  role          = aws_iam_role.glue_role.arn
  s3_target {
    path = "s3://${aws_s3_bucket.s3_bucket.bucket}/AWSLogs/"
  }
  table_prefix = "flowlogs_"

}


###############################
####     ROLE / POLICY
###############################

data "aws_iam_policy_document" "glue_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["glue.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "glue_policy_document" {
  version = "2012-10-17"
  statement {
    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]
    effect = "Allow"
    resources = [
      "${aws_s3_bucket.s3_bucket.arn}",
      "${aws_s3_bucket.s3_bucket.arn}/*"
    ]
  }

  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:logs:ap-southeast-1:686797372394:log-group:/aws-glue/*"
    ]
  }
}

resource "aws_iam_role" "glue_role" {
  name               = "glue_role"
  assume_role_policy = data.aws_iam_policy_document.glue_assume_role.json
}

resource "aws_iam_role_policy" "glue_policy" {
  name   = "glue_policy"
  role   = aws_iam_role.glue_role.id
  policy = data.aws_iam_policy_document.glue_policy_document.json
}

resource "aws_iam_role" "crawler_role" {
  name               = "crawler_role"
  assume_role_policy = data.aws_iam_policy_document.glue_assume_role.json
}

resource "aws_iam_role_policy" "crawler_policy" {
  name   = "crawler_policy"
  role   = aws_iam_role.crawler_role.id
  policy = data.aws_iam_policy_document.glue_policy_document.json
}