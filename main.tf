provider "aws" {
  region = "us-west-2"  # Update with your desired region
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "my_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-west-2a"  # Update with your desired availability zone
}

resource "aws_outpost" "my_outpost" {
  site_id = "site-xxxxxxxxxxxxx"  # Replace with your Outpost Site ID
}

resource "aws_subnet_outpost" "my_subnet_outpost" {
  subnet_id    = aws_subnet.my_subnet.id
  outpost_arn  = aws_outpost.my_outpost.arn
}

resource "aws_security_group" "my_security_group" {
  vpc_id = aws_vpc.my_vpc.id
  
  // Inbound rule to allow SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Update with a more specific IP range
  }

  // Additional security group rules as needed
}

resource "aws_instance" "my_instance" {
  ami           = "ami-xxxxxxxxxxxxxxxxx"
  instance_type = "t2.micro"  # Update with your desired instance type
  subnet_id     = aws_subnet_outpost.my_subnet_outpost.id
  security_groups = [aws_security_group.my_security_group.name]

  // Define other instance settings such as key_name, user_data, etc.
}

resource "aws_eip" "my_eip" {
  instance = aws_instance.my_instance.id
}

output "instance_id" {
  value = aws_instance.my_instance.id
  description = "ID of the created EC2 instance"
}

output "public_ip" {
  value = aws_eip.my_eip.public_ip
  description = "Public IP address of the EC2 instance"
}
