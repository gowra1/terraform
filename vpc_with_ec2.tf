provider "aws" {
  alias  = "dev-us-east-1"  
  region = "us-east-1"  # Update with your desired AWS region
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"  # Update with your desired CIDR block

  tags = {
    Name = "MyVPC"  # Update with your desired VPC name
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"  # Update with your desired subnet CIDR block
  availability_zone       = "us-east-1a"  # Update with your desired availability zone

  tags = {
    Name = "MySubnet"  # Update with your desired subnet name
  }
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "MyIGW"  # Update with your desired internet gateway name
  }
}

resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "MyRouteTable"  # Update with your desired route table name
  }
}

resource "aws_route_table_association" "my_route_table_assoc" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.my_route_table.id
}

resource "aws_security_group" "my_security_group" {
  name        = "MySecurityGroup"  # Update with your desired security group name
  description = "Allow SSH and HTTP access"  # Update with your desired security group description
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Update with the allowed source IP ranges
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Update with the allowed source IP ranges
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my_instance" {
  ami           = "ami-0889a44b331db0194"  # Update with the desired AMI ID
  instance_type = "t2.micro"  # Update with the desired instance type
  key_name      = "instance1"  # Update with the name of your key pair
  subnet_id     = aws_subnet.my_subnet.id
  vpc_security_group_ids = [aws_security_group.my_security_group.id]

  tags = {
    Name = "MyEC2Instance"  # Update with your desired EC2 instance name
  }
}