data "aws_ssm_parameter" "ubuntu_2204" {
  name = "/aws/service/canonical/ubuntu/server/22.04/stable/current/amd64/hvm/ebs-gp2/ami-id"
}

resource "aws_key_pair" "tfkey" { key_name = "tf-key"; public_key = file(var.ssh_public_key_path) }

resource "aws_security_group" "main_sg" {
  name = "tf-ansible-sg"
  ingress { from_port=22; to_port=22; protocol="tcp"; cidr_blocks=["0.0.0.0/0"] }
  ingress { from_port=80; to_port=80; protocol="tcp"; cidr_blocks=["0.0.0.0/0"] }
  egress  { from_port=0; to_port=0; protocol="-1"; cidr_blocks=["0.0.0.0/0"] }
}

resource "aws_instance" "controller" {
  ami = data.aws_ssm_parameter.ubuntu_2204.value
  instance_type = var.instance_type
  key_name = aws_key_pair.tfkey.key_name
  vpc_security_group_ids = [aws_security_group.main_sg.id]
  associate_public_ip_address = true
  tags = { Name = "controller" }
}

resource "aws_instance" "managed" {
  ami = data.aws_ssm_parameter.ubuntu_2204.value
  instance_type = var.instance_type
  key_name = aws_key_pair.tfkey.key_name
  vpc_security_group_ids = [aws_security_group.main_sg.id]
  associate_public_ip_address = true
  tags = { Name = "managed" }
}
