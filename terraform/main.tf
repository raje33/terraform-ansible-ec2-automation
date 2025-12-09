provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "controller" {
  ami           = "ami-0fd05997b4dff7aac"
  instance_type = "t2.micro"

  tags = {
    Name = "controller-node"
  }
}

resource "aws_instance" "managed" {
  ami           = "ami-0fd05997b4dff7aac"
  instance_type = "t2.micro"

  tags = {
    Name = "managed-node"
  }
}
