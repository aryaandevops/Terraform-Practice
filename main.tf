provider "aws" {
region = "us-east-1"
}

resource "aws_instance" "one" {
    count = 2
ami = "ami-02b64aa047cb5edf5"
instance_type = "t3.micro"
tags = {
 Name = "aryan-${count.index+1}"
 }
}
