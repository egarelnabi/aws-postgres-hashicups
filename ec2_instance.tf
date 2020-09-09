terraform {
  required_version = ">= 0.12.12"
}

provider "aws" {
  #need to parameterize
  region = "us-east-2"
}

data "aws_ami" "rhel_ami" {
  most_recent = true
  owners      = ["309956199498"]

  filter {
    name   = "name"
    values = ["*RHEL-7.3_HVM_GA-*"]
  }
}

data "template_file" "config" {
  template = file("postgres.tpl")
}

resource "aws_instance" "ubuntu" {
  count         = 1
  ami           = data.aws_ami.rhel_ami.id
  instance_type = "t2.micro"
  #add parameterized vars for security group & subnets

  tags = {
    Name = "eyad"
  }
  
  user_data = data.template_file.config.rendered

}