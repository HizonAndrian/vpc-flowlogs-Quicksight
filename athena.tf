#Athena
resource "aws_athena_database" "athena_db" {
  name   = "athena_db"
  bucket = aws_s3_bucket.s3_athena.bucket
}

#Destination where Athena will store the query results
resource "aws_athena_workgroup" "athena_workgroup" {
  name          = "athena_workgroup"
  force_destroy = true

  configuration {
    enforce_workgroup_configuration    = true
    publish_cloudwatch_metrics_enabled = true

    result_configuration {
      output_location = "s3://${aws_s3_bucket.s3_athena.bucket}/output/"
    }
  }
}

data "aws_iam_policy_document" "athena_policy_doc" {
  version = "2012-10-17"
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["athena.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "athena_policy" {
  version = "2012-10-17"
  statement {
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
      "s3:PutObject"
    ]
    effect = "Allow"
    resources = [
      aws_s3_bucket.s3_athena.arn,
      "${aws_s3_bucket.s3_athena.arn}/*"
    ]
  }
  statement {
    actions = [
      "athena:StartQueryExecution",
      "athena:GetQueryExecution",
      "athena:GetQueryResults",
      "athena:ListWorkGroups"
    ]
    effect    = "Allow"
    resources = ["*"]
  }
  statement {
    actions = [
      "glue:GetTable",
      "glue:GetTables",
      "glue:GetDatabase",
      "glue:GetDatabases"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:glue:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:catalog",
      "arn:aws:glue:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:database/vpc_flowlogs_db",
      "arn:aws:glue:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:table/vpc_flowlogs_db/*"
    ]
  }
}


resource "aws_iam_role" "athena_role" {
  name               = "athena_role"
  assume_role_policy = data.aws_iam_policy_document.athena_policy_doc.json
}

resource "aws_iam_role_policy" "athena_policy" {
  name   = "athena_policy"
  role   = aws_iam_role.athena_role.id
  policy = data.aws_iam_policy_document.athena_policy.json
}

# Basic changes. Yes sir
# Testing number 2