
#Setting the AWS Provider

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.30.0"
      
    }
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"

  #MOVE THIS TO VARS, ONCE WORKING
#Changing this  access_key = 
#Changing this  secret_key = 
}


resource "aws_instance" "LucidPoint-demo" {

    ami = "ami-06640050dc3f556bb"
    instance_type = "t2.micro"
    security_groups = [ "launch-wizard-1" ]
    key_name = "LucidPoint_Demo_key"

    tags = {
      Name = "LucidPoint-demoEC2"
    }
  
 
}

resource "aws_vpc" "Demo-vpc" {
    cidr_block = "10.0.0.0/16"

    tags = {
      Name = "LP-demoVPC"
    }
    
}

resource "aws_subnet" "Demo-subnet" {
    vpc_id = aws_vpc.Demo-vpc.id
    cidr_block = "10.0.1.0/24"

    tags = {
      Name = "LP-demoSUBNET"
    }
  
}
