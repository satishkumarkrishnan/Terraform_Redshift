terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      #version   = "~> 5.4.0"  
    }
  }
}

module "iam" {
  source="git@github.com:satishkumarkrishnan/Terraform_IAM.git?ref=main"
}

module "vpc" {
  source ="git@github.com:satishkumarkrishnan/terraform-aws-vpc.git?ref=main"
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
  
}

/*resource "aws_redshift_cluster" "tokyo-redshift-cluster" {
  cluster_identifier = "tf-redshift-cluster"
  database_name      = "mydb"
  master_username    = "exampleuser"
  node_type          = "dc2.large"
  cluster_type       = "single-node"
  master_password    = "Tokyo123"
}*/

resource "aws_redshift_cluster" "tokyo-redshift-cluster" {
  cluster_identifier = "tf-redshift-cluster"
  database_name      = "mydb"
  master_username    = "exampleuser"
  master_password    = "Tokyo123"
  node_type          = "dc2.large"
  cluster_type       = "single-node"
  
}

resource "aws_redshift_cluster_iam_roles" "example" {
  cluster_identifier = aws_redshift_cluster.tokyo-redshift-cluster.cluster_identifier
  #cluster_identifier = aws_redshift_cluster.example.cluster_identifier
  #iam_role_arns      = [aws_iam_role.example.arn]
  iam_role_arns      = [module.iam.tokyo_IAM_role]
  
}