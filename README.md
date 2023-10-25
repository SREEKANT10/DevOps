# DevOps-Project (using terraform only)
Using terraform for provisioning manually or using jenkins to automate the process
<pre>
1.Login to root account and create iam user account with administrative access
2.Create a key pair “devops_01.ppk” in iam user account
3.Create access keys for iam account add the access_key and secret_key in .tf file
4.Create project directory
5.Create main.tf file
6.Add the content:
</pre>

      provider "aws" {
        region = "us-east-1"
        access_key = ""
        secret_key = ""
      }
      
      variable "name" {
          description = "Name the instance on deploy"
      }

      resource "aws_instance" "devops_01_docker-nginx" {
          ami = "ami-0889a44b331db0194"
          instance_type = "t2.micro"
          key_name = "devops_01"

          tags = {
              Name = "${var.name}"
          }
          user_data = <<-EOF
          #!/bin/bash
          set -ex
          sudo yum update -y
          sudo yum install -y yum-utils
          sudo yum install docker -y
          sudo service docker start
          sudo usermod -a -G docker ec2-user
          sudo curl -L https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
          sudo chmod +x /usr/local/bin/docker-compose
          sudo docker pull nginx:latest
          sudo git clone https://github.com/AbhiGupta8295/devops_project.git .

        EOF

      }
<pre>
7.Open cmd prompt, go to project directory
8.Run terraform init, plan, apply
9.Once the ec2 instance gets started, copy its public dns address
10.Open putty.exe to connect through ssh client
11.Using the dns address and keypair file connect to the instance
12.Run the command ‘docker ps’ to check whether docker is running or not
13.Run git clone git@github.com:AbhiGupta8295/devops_project.git to add the repository in the 	docker.
14.Move using cd to repository directory. 
15.Run below command to run the nginx image on docker host on port 8000.
16.docker run -d -p 8000:80 -v ~/repo-name:/usr/share/nginx/html --name your-nginx-name-here nginx.
</pre>

# To run terraform using jenkins pipeline
<pre>
1.Launch an ec2 instance.
2.Connect using putty.
3.Install git, jenkins and terraform on it.
3.Connect to dns address of the instance on port 8080.
4.Run 'sudo systemctl status jenkins' to get administrator password for connecting into jenkins GUI.
5.Click install suggested plugins and then go to manage jenkins > plugins > available plugins > search terraform and install without restart.
6.Goto to manage jenkins > tools > add terraform. give terraform name (e.g terraform-11, terraform-15), uncheck install automatically, add path ( to get path run   'which terraform' on putty which is connected to the instance. e.g /usr/bin/), apply and save.
7.Click new item > select pipeline.
8.Check github project and definition > pipeline script.
9.Write the pipeline script and use pipeline syntax for reference.
10.While writing reference for github repo goto pipeline syntax > snippet generator > select git from dropdown and add relevant details.
11.In credentials section, click add > jenkins > select username with password > username and password.
12.Select your added credential in step 10 click generate pipeline script. copy and paste in jenkins script.
</pre>
<pre>

13.Script for devops_project repo :

pipeline{
    agent any
    tools {
        terraform 'terraform-11'
    }
    stages {
        stage ('Git Checkout'){
            steps{
                git branch: 'main', credentialsId: '', url: 'https://github.com/AbhiGupta8295/devops_project'
            }
        }
        stage ('Terraform init'){
            steps{
                sh 'terraform init'
            }
        }
        stage ( 'Terraform Apply'){
            steps{
                sh 'terraform apply --auto-approve'
            }
        }
    }

14. Now, the ec2 instance will need a IAM role in order to execute AWS commands (mentioned in main.tf).
15. go to aws account create an iam role with administrative access.
16. go to ec2 instances > select instance > actions > security > modify iam > attach and save.
17. build pipeline and check progress in console output.
</pre>
