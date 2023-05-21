provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "name" {
ami = "ami-0889a44b331db0194"
key_name = "instance1"
instance_type = "t2.micro"  
}