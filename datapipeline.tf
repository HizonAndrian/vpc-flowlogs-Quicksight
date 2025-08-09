resource "aws_glue_catalog_database" "vpc_flowlogs_db" {
  name = "vpc_flowlogs_db"
}

resource "aws_glue_catalog_table" "glue_catalog_table" {
  name          = "glue_catalog_table"
  database_name = aws_glue_catalog_database.vpc_flowlogs_db.name

  table_type = "EXTERNAL_TABLE"

  storage_descriptor {
    location      = "s3://${aws_s3_bucket.s3_bucket.bucket}/AWSLogs/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      name                  = "vpcflowlogs-serde"
      serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"
      parameters = {
        "field.delim" = " "
      }
    }

    columns {
      name = "version"
      type = "int"
    }
    columns {
      name = "account_id"
      type = "string"
    }
    columns {
      name = "interface_id"
      type = "string"
    }
    columns {
      name = "srcaddr"
      type = "string"
    }
    columns {
      name = "dstaddr"
      type = "string"
    }
    columns {
      name = "srcport"
      type = "int"
    }
    columns {
      name = "dstport"
      type = "int"
    }
    columns {
      name = "protocol"
      type = "int"
    }
    columns {
      name = "packets"
      type = "int"
    }
    columns {
      name = "bytes"
      type = "int"
    }
    columns {
      name = "start"
      type = "bigint"
    }
    columns {
      name = "end"
      type = "bigint"
    }
    columns {
      name = "action"
      type = "string"
    }
    columns {
      name = "log_status"
      type = "string"
    }
  }
}

#Scan the data within S3.
resource "aws_glue_crawler" "glue_crawler" {
  database_name = aws_glue_catalog_database.vpc_flowlogs_db.name
  name          = "glue_crawler"
  role          = aws_iam_role.glue_role.arn
  s3_target {
    path = "s3://${aws_s3_bucket.s3_bucket.bucket}/AWSLogs/"
  }
  table_prefix = "flowlogs_"
  classifiers  = [aws_glue_classifier.vpc_flowlogs_classifier.name]
}

resource "aws_glue_classifier" "vpc_flowlogs_classifier" {
  name = "vpc_flowlogs_classifier"

  grok_classifier {
    classification = "vpcflowlogs"
    grok_pattern   = "%%{NUMBER:version:int} %%{NOTSPACE:account_id} %%{NOTSPACE:interface_id} %%{IP:srcaddr} %%{IP:dstaddr} %%{NUMBER:srcport:int} %%{NUMBER:dstport:int} %%{NUMBER:protocol:int} %%{NUMBER:packets:int} %%{NUMBER:bytes:int} %%{NUMBER:start:long} %%{NUMBER:end:long} %%{WORD:action} %%{WORD:log_status}"
  }

}



###############################
####     ROLE / POLICY
###############################

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

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
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws-glue/*"
    ]
  }
  statement {
    actions = [
      "glue:GetTable",
      "glue:GetTables",
      "glue:GetDatabase",
      "glue:GetDatabases",
      "glue:CreateTable",
      "glue:UpdateTable",
      "glue:UpdatePartition",
      "glue:DeleteTable",
      "glue:CreateDatabase",
      "glue:BatchGetPartition",
      "glue:BatchCreatePartition"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:catalog",
      "arn:aws:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:database/vpc_flowlogs_db",
      "arn:aws:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/vpc_flowlogs_db/*"
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
