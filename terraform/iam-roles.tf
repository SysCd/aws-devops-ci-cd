# IAM Role for EKS Cluster
resource "aws_iam_role" "eks_role" {  #Creates an IAM role for the EKS cluster
  name = "eks-cluster-role-terraform"  #Names the role "eks-cluster-role-terraform" in AWS
  assume_role_policy = jsonencode({  #Defines the trust policy for the role
  Version = "2012-10-17"  #Sets policy version to 2012-10-17 (standard for IAM policies)

    Statement = [{  #Starts a list of permissions
      Effect = "Allow"  #Allows the action
      Principal = {  #Specifies who can assume the role
        Service = "eks.amazonaws.com"  #Permits the EKS service to use this role
      }
      Action = "sts:AssumeRole"  #Grants permission to assume the role
    }]
  })

  tags = {  #Adds metadata for identification
    Name = "eks-cluster-role"  #Labels the role as "eks-cluster-role" in AWS
  }
}

# Attach EKS Cluster Policy
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {  #Attaches a policy to the EKS cluster role
  role       = aws_iam_role.eks_role.name  #Links to the "eks_role" IAM role
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"  #Attaches AmazonEKSClusterPolicy for cluster management
}

# IAM Role for Worker Nodes
resource "aws_iam_role" "eks_node_role" {  #Creates an IAM role for EKS worker nodes
  name = "eks-worker-role"  #Names the role "eks-worker-role" in AWS
  assume_role_policy = jsonencode({  #Defines the trust policy for the role
    Version = "2012-10-17"  #Sets policy version to 2012-10-17
    Statement = [{  #Starts a list of permissions
      Effect = "Allow"  #Allows the action
      Principal = {  #Specifies who can assume the role
        Service = "ec2.amazonaws.com"  #Permits EC2 instances (nodes) to use this role
      }
      Action = "sts:AssumeRole"  #Grants permission to assume the role
    }]
  })
  tags = {  #Adds metadata for identification
    Name = "eks-worker-role"  #Labels the role as "eks-worker-role" in AWS
  }
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {  #Attaches a policy for node communication
  role       = aws_iam_role.eks_node_role.name  #Links to the "eks_node_role" IAM role
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"  #Attaches AmazonEKSWorkerNodePolicy for node-cluster interaction
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {  #Attaches a policy for networking
  role       = aws_iam_role.eks_node_role.name  #Links to the "eks_node_role" IAM role
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"  #Attaches AmazonEKS_CNI_Policy for VPC networking (pod IPs)
}

resource "aws_iam_role_policy_attachment" "ecr_read_only_policy" {  #Attaches a policy for container image access
  role       = aws_iam_role.eks_node_role.name  #Links to the "eks_node_role" IAM role
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"  #Attaches AmazonEC2ContainerRegistryReadOnly for pulling images from ECR
}