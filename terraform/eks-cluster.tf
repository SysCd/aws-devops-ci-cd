
resource "aws_eks_cluster" "devops_cluster" {  #Creates AWS eks cluster resource ref named" devops cluster" 
  name     = var.eks_cluster_name #Uses variable to name cluster
  role_arn = aws_iam_role.eks_cluster_role.arn #Gives the EKS cluster a permission key to interact with AWS
  version  = "1.28" #Uses Kubernetes version 1.28


  vpc_config {  #Allocates the EKS on the network
    subnet_ids = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id] #Uses 2 subnets for redundancy 
  }

  depends_on = [ #Waits for the IAM policy to be attached before creating this cluster
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]

  tags = { # A name tag for the EKS cluster
    Name = "devops-eks-cluster" 
  }
}

