resource "aws_security_group" "security_group" {
  name        = "ec2_server"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.vpc_main.id
}

resource "aws_vpc_security_group_ingress_rule" "inbound_http" {
  security_group_id = aws_security_group.security_group.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "inbound_ssh" {
  security_group_id = aws_security_group.security_group.id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "outbound_open" {
  security_group_id = aws_security_group.security_group.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}