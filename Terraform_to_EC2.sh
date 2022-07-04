#Tools required: Terraform, AWS account with security credentials, and Keypair.
#Expected Deliverables:
#- Launch an EC2 instance
#- Connect to instance
#- Install Jenkins, Java, and Python on the instance.
#Step 1: Install the Terraform on the local\AWS machine.
#Step 2: Create an IMA user on the AWS account.
#Step 3: Write a terraform script.
#Step 1 : Terraform Installation on Linux operating system.
# Execute the following commands to install the terraform.
yum install wget
wget https://releases.hashicorp.com/terraform/1.2.3/terraform_1.2.3_linux_arm64.zip
#Install unzip package.
$ sudo apt-get install -y unzip
#Unzip the terraform_0.14.9_linux_amd64.zip file
unzip terraform_1.2.3_linux_arm64.zip
# Move the file terraform files to the given below location
sudo mv terraform /usr/local/bin/
terraform -version
#Step 2: Create an IMA user and keypair.
# 1. Sign in as a root user on your AWS account.
# 2. Search for the IAM service and navigate to the Users screen.
# 3. Click on Add User to navigate to a user detail form. Provide all details, such as the
# username and access type and give the permission to the user and click on the add
# user.
# 4. The user has added and download the .csv file of Access key ID and Secret access key
# (keep it in a safe place or remember both Access key ID and Secret access key. )
# 5. Log in to the newly created account and negative to the EC2 instance and select keypair
# from network & security.
# 6. Provide the name and select the RSA and .pem and create key pair and save the .pem
# file.
# Step :3y
# Write a script
# 1. Create a new directory and switch to the directory.
# 2. Create a new file with .tf excitation.
#3. Write a script
provider "aws" {
region = "us-east-1"
access_key = "AKIAT7DAGQZD3DXXXX"
secret_key = "Yt7nXBDRu69jmjBcvRaaXrwfWMSI5rsFq2vOXXXXX"
}
resource "aws_security_group" "sg" {
name = "allow_tls"
description = "Allow TLS inbound traffic"
ingress {
description = "SSH"
from_port = 22
to_port = 22
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}
ingress {
description = "HTTP"
from_port = 8080
to_port = 8080
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}
egress {
from_port = 22
to_port = 22
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}
tags = {
Name = "allow_tls"
}
}
resource "aws_instance" "instance"{
ami = "ami-0cff7528ff583bf9a"
instance_type = "t2.micro"
key_name = "teraform"

user_data = <<-EOF
#!/bin/bash
#Updating the newly instally system(EC2)
sudo yum update
# Wget Installation
sudo yum install wget git -y
# java installation
sudo yum install java-1.8.0-openjdk-devel -y
# Jenkins installation
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
sudo yum upgrade -y
sudo yum install jenkins -y
sudo systemctl start jenkins
#python installation
sudo yum install python37 -y
EOF
}
resource "aws_network_interface_sg_attachment" "sg_attachment" {
security_group_id = aws_security_group.sg.id
network_interface_id = aws_instance.instance.primary_network_interface_id
}
#Run the $ terraform init command

