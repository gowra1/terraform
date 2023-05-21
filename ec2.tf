provider "aws" {
  region = var.region
}

resource "aws_instance" "variable_ec2" {
ami = var.os_name
key_name = var.key
instance_type = var.instance_type  
}