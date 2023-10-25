provider "aws" {
  region = "us-east-1"
  access_key = "AWS_ACCESS_KEY"
  secret_key = "AWS_SECRET_KEY"
}

variable "name" {
    description = "Name the instance on deploy"
}



resource "aws_instance" "devops_01_docker-nginx" {
    ami = "ami-0889a44b331db0194"
    instance_type = "t2.micro"
    key_name = "devops_01"
    vpc_security_group_ids = ["sg-0454b7e51120799e6"]

    tags = {
        Name = "${var.name}"
    }
    user_data = <<-EOF
    #!/bin/bash
    set -ex
    sudo yum update -y
    sudo yum install -y yum-utils
    sudo yum install git -y
    sudo yum install docker -y
    sudo service docker start
    sudo usermod -a -G docker ec2-user
    sudo curl -L https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    sudo docker pull nginx:latest 
    
  EOF

}
