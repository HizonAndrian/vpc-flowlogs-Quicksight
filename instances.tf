data "aws_ami" "getAMI" {
  most_recent = true
  owners      = ["137112412989"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-kernel-6.1-x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

resource "aws_instance" "ec2_server" {
  ami                    = data.aws_ami.getAMI.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.vpc_subnet["subnet1"].id
  vpc_security_group_ids = [aws_security_group.security_group.id]
  key_name               = "HelloWorld KP" # <--- existing keypair

}
