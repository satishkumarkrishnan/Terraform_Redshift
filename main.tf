terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.0.0"
    }
  }
}

module "iam" {
  source="git@github.com:satishkumarkrishnan/Terraform_IAM.git?ref=main"
}


# Create a VPC for the region associated with the AZ
resource "aws_default_vpc" "default-tokyo-vpc" {
  force_destroy = "true" 
  tags = {
    Name = var.vpc
  }  
}

# Create a subnet for the AZ within the regional VPC
resource "aws_default_subnet" "tokyo_default_az1" {
  availability_zone = data.aws_availability_zone.example.name
 force_destroy = "true"
   tags = {
    Name        = "tokyo-subnets-default"
    } 
  depends_on = [aws_default_vpc.default-tokyo-vpc]  
}

resource "aws_redshift_authentication_profile" "tokyo_redshift" {
  authentication_profile_name = "tokyo-redshift"
  authentication_profile_content = jsonencode(
    {
      AllowDBUserOverride = "1"
      Client_ID           = "ExampleClientID"
      App_ID              = "example"
    }
  )
  depends_on = [aws_default_vpc.default-tokyo-vpc]
}

resource "aws_redshift_cluster" "tokyo-redshift-cluster" {
  cluster_identifier        = "tf-redshift-cluster"
  database_name             = "mydb"
  master_username           = "exampleuser"
  master_password           = "Tokyo123"
  node_type                 = "dc2.large"
  cluster_type              = "single-node"
  final_snapshot_identifier = "tokyo-cluster-backup8"
  depends_on = [aws_default_vpc.default-tokyo-vpc]  
}

resource "aws_redshift_cluster_iam_roles" "example" {
  cluster_identifier = aws_redshift_cluster.tokyo-redshift-cluster.cluster_identifier  
  iam_role_arns      = [module.iam.tokyo_IAM_role]
  depends_on         = [aws_default_vpc.default-tokyo-vpc]
}