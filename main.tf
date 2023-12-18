


module "iam" {
  source="git@github.com:satishkumarkrishnan/Terraform_IAM.git?ref=main"  
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

resource "aws_redshift_cluster" "tokyo-redshift-cluster" {
  cluster_identifier = "tf-redshift-cluster"
  database_name      = "mydb"
  master_username    = "exampleuser"
  node_type          = "dc1.large"
  cluster_type       = "single-node"

  #manage_master_password = true
}

resource "aws_redshift_cluster_iam_roles" "example" {
  cluster_identifier = aws_redshift_cluster.tokyo-redshift0cluster.cluster_identifier
  #cluster_identifier = aws_redshift_cluster.example.cluster_identifier
  #iam_role_arns      = [aws_iam_role.example.arn]
  iam_role_arns      = [module.iam.tokyo_IAM_role]
}