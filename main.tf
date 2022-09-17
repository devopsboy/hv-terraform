provider "aws" {
  region = "ap-south-1"  #CHANGE_ME
  access_key = "******"  #CHANGE_ME
  secret_key = "******"  #CHANGE_ME

  default_tags {
    tags = {
      App = "task"
      Managed_By = "terraform"
    }
  }
}

locals {
  common_ip = "0.0.0.0/0"                   #UPDATE_ME
  ssh_key_name = "task-ssh"                 #UPDATE_ME
  subnet_id = "subnet-021f99cd0e64d2842"    #UPDATE_ME
  vpc_id = "vpc-097a3e1a9180950fc"          #UPDATE_ME

  user_data_task = <<-EOF
    #!/bin/bash
    # Install nginx & AWS-cli
    sudo apt-get update
    sudo apt install -y nginx
    sudo apt-get install awscli --yes

    # Getting the Instance details
    export AWS_REGION= *****                     #CHANGE_ME
    export AWS_ACCESS_KEY_ID= ******             #CHANGE_ME
    export AWS_SECRET_ACCESS_KEY= *****          #CHANGE_ME
    echo "<br><h1>&emsp;<u>Welcome to HyperVerge</u></h1>" > index.html
    INSTANCE_ID=$(aws --region $AWS_REGION ec2 describe-instances --filters Name=tag:Name,Values=task Name=instance-state-name,Values=running --output text --query 'Reservations[*].Instances[*].InstanceId')
    echo "<br><h2>Instance ID&emsp;&emsp;&emsp;&ensp;: $INSTANCE_ID</h2>" >> index.html
    PUBLIC_IP_ADDRESS=$(aws --region $AWS_REGION ec2 describe-instances --filters Name=tag:Name,Values=task Name=instance-state-name,Values=running --output text --query 'Reservations[*].Instances[*].[PublicIpAddress]')
    echo "<br><h2>Public IP address&emsp;: $PUBLIC_IP_ADDRESS</h2>" >> index.html
    PRIVATE_IP_ADDRESS=$(aws --region $AWS_REGION ec2 describe-instances --filters Name=tag:Name,Values=task Name=instance-state-name,Values=running --output text --query 'Reservations[*].Instances[*].[PrivateIpAddress]')
    echo "<br><h2>Private IP address&ensp;: $PRIVATE_IP_ADDRESS</h2>" >> index.html
    MAC_ADDRESS=$(aws --region $AWS_REGION ec2 describe-network-interfaces --filters Name=addresses.private-ip-address,Values=$PRIVATE_IP_ADDRESS --output text --query 'NetworkInterfaces[0].MacAddress')
    echo "<br><h2>Mac address&emsp;&emsp;&emsp;: $MAC_ADDRESS</h2>" >> index.html

    # Start Nginx
    sudo cp index.html /var/www/html
    sudo systemctl start nginx
  EOF

  user_data_health = <<EOF
    #!/bin/bash
    # Install Docker
    sudo yum update
    sudo yum -y install docker 

    # Install Docker-compose
    wget https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) 
    sudo mv docker-compose-$(uname -s)-$(uname -m) /usr/local/bin/docker-compose
    sudo chmod -v +x /usr/local/bin/docker-compose
    sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

    # Start Docker
    sudo systemctl enable docker.service
    sudo systemctl start docker.service
  EOF
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

module "task" {
  source = "./app/task"

  key_name = local.ssh_key_name
  subnet_id = local.subnet_id
  user_data = local.user_data_task
  common_ip = local.common_ip
  vpc_id = local.vpc_id
}

module "health" {
  source = "./app/health"

  key_name = local.ssh_key_name
  subnet_id = local.subnet_id
  user_data = local.user_data_health
  common_ip = local.common_ip
  vpc_id = local.vpc_id
}