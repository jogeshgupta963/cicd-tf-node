terraform{
    required_providers {
      aws= {
        source="hashicorp/aws",
        version = ">4.0"
      }
    }
    backend "s3" {
        key = "aws/ec2-deploy/terraform.tfstate"
    }
}

provider "aws"{
    region = var.region
}

resource "aws_instance" "deployer" {
    ami = "ami-0376ec8eacdf70aae"
    instance_type = "t2.micro"
    key_name = aws_key_pair.deployer.key_name
    vpc_security_group_ids = [aws_security_group.deployer_sg.id]
    connection {
      type = "ssh"
      host = self.public_ip
      user="ubuntu"
      private_key = var.private_key
      timeout = "4m"
    }
    tags = {
      "name" = "deploy_TF_vm"
    }
}

resource "aws_security_group" "deployer_sg" {
    egress = [
    {
        cidr_blocks = ["0.0.0.0/0"]
        description = ""
        from_port = 0
        ipv6_cidr_blocks=[]
        prefix_lis_ids = []
        protocol = "-1"
        security_groups = []
        self = false
        to_port = 0
    }
    ]
    ingress = [  {
       cidr_blocks = ["0.0.0.0/0"]
        description = ""
        from_port = 80
        ipv6_cidr_blocks=[]
        prefix_lis_ids = []
        protocol = "tcp"
        security_groups = []
        self = false
        to_port = 80
    } ]
}

resource "aws_key_pair" "deployer" {
    key_name = var.key_name
    public_key = var.public_key
}

output "insance_public_ip"{
    value = aws_instance.deployer.public_ip
    sensitive = true
}