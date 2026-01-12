locals {
  public_subnets = {
    for subnet_key, subnet_value in var.subnet_config :
    subnet_key => subnet_value
    if subnet_value.public == true
  }
}

resource "aws_vpc" "vpc_main" {
  cidr_block = "10.0.0.0/16"

  tags = var.resource_tags
}

resource "aws_subnet" "vpc_subnet" {
  for_each                = var.subnet_config
  vpc_id                  = aws_vpc.vpc_main.id
  cidr_block              = each.value.cidr_block
  map_public_ip_on_launch = true

  tags = {
    Name = each.key
  }
}

resource "aws_internet_gateway" "vpc_igw" {
  vpc_id = aws_vpc.vpc_main.id

  tags = var.resource_tags
}

resource "aws_route_table" "vpc_rtbl" {
  vpc_id = aws_vpc.vpc_main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_igw.id
  }

  tags = var.resource_tags
}

resource "aws_route_table_association" "vpc_rtbl_association" {
  for_each       = local.public_subnets
  subnet_id      = aws_subnet.vpc_subnet[each.key].id
  route_table_id = aws_route_table.vpc_rtbl.id
}

resource "aws_flow_log" "vpc_logs" {
  vpc_id               = aws_vpc.vpc_main.id
  log_destination_type = "s3"
  log_destination      = aws_s3_bucket.s3_bucket.arn
  traffic_type         = "ALL"
}