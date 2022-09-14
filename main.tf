
#Setting the AWS as the Terraform Provider
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.30.0"
      
    }
  }
}

#Setting region and grabbing acccess key info
provider "aws" {
  # Configuration options
  region = "us-east-1"

  
# PRIVATE DATA  access_key = ""
# PRIVATE DATA  secret_key = ""
}


#Setting up demo VPC
resource "aws_vpc" "Demo-vpc" {
    cidr_block = "21.0.0.0/16"

    tags = {
      Name = "LP-demoVPC"
    }
    
}

#Setting up subnet for demo
resource "aws_subnet" "Demo-subnet" {
    vpc_id = aws_vpc.Demo-vpc.id
    cidr_block = "21.0.1.0/24"
    availability_zone = "us-east-1a"

    tags = {
      Name = "LP-demoSUBNET"
    }
  
}

#Setting up internet gateway for demo
resource "aws_internet_gateway" "Demo-gateway" {
  vpc_id = aws_vpc.Demo-vpc.id

  tags = {
    Name = "LP-demoGATEWAY"
  }
}

#Setting up route table for demo
resource "aws_route_table" "Demo-route-table" {
  vpc_id = aws_vpc.Demo-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Demo-gateway.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.Demo-gateway.id
  }

  tags = {
    Name = "LP-demoROUTE"
  }
}

#Associating the route table with the subnet
resource "aws_route_table_association" "Demo-RT-Association" {
  subnet_id      = aws_subnet.Demo-subnet.id
  route_table_id = aws_route_table.Demo-route-table.id
}


#Creating security group for SSH/web traffic
resource "aws_security_group" "Demo-allow-traffic" {
  name        = "allow-SSH-web"
  description = "Allow HTTP and SSH"
  vpc_id      = aws_vpc.Demo-vpc.id

  ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "LP-allow-SSH-web"
  }
}

#Setting up network interface for demo
resource "aws_network_interface" "Demo-NIC" {
  subnet_id       = aws_subnet.Demo-subnet.id
  private_ips     = ["21.0.1.21"]
  security_groups = [aws_security_group.Demo-allow-traffic.id]

#  attachment {
#    instance     = aws_instance.test.id
#    device_index = 1
#  }
}

#Setting up the elastice IP for demo
resource "aws_eip" "Demo-EIP" {
  vpc                       = true
  network_interface         = aws_network_interface.Demo-NIC.id
  associate_with_private_ip = "21.0.1.21"
  depends_on = [
    aws_internet_gateway.Demo-gateway
  ]
}

#Setting up EC2 instance for web demo
resource "aws_instance" "LucidPoint-demo" {

    ami = "ami-06640050dc3f556bb"
    instance_type = "t2.micro"
    availability_zone = "us-east-1a"
#    security_groups = [ "LP-allow-SSH-web" ]
    key_name = "LucidPoint_Demo_key"
    network_interface {
      device_index = 0
      network_interface_id = aws_network_interface.Demo-NIC.id
    }

    user_data = <<-EOF
              #!/bin /bash
              sudo yum install -y httpd
              sudo yum install -y wget
              sudo yum install -y unzip
              EOF

    tags = {
      Name = "LP-demoEC2"
    }
  
 
}
