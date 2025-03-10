# Terraform Required Version
terraform {  #Configures Terraform settings
  required_version = ">= 1.3.0"  #Ensures Terraform version is 1.3.0 or higher for compatibility
}

# AWS Provider
provider "aws" { 
  region = var.aws_region
}

# Variables (Define defaults)
variable "aws_region" {  #Declares a variable for the AWS region
  default = "eu-west-2"  #Sets default region to eu-west-2 (London)
}

variable "eks_cluster_name" {  #Declares a variable for the EKS cluster name
  default = "devops-eks-cluster"  #Sets default cluster name to devops-eks-cluster
}

variable "node_instance_type" {  #Declares a variable for the node instance type
  default = "t3.small"  #Sets default instance type to t3.small (2 vCPUs, 2GB RAM)
}

# VPC Configuration
resource "aws_vpc" "devops_vpc" {  #Creates a VPC for the project
  cidr_block = "10.0.0.0/16"  #Sets VPC IP range to 10.0.0.0/16 (65,536 IPs)
  tags = {  #Adds metadata for identification
    Name = "devops-vpc"  #Labels the VPC as devops-vpc in AWS
  }
}

# Public Subnet 1 (eu-west-2a)
resource "aws_subnet" "public_subnet_1" {  #Creates a public subnet in eu-west-2a
  vpc_id                  = aws_vpc.devops_vpc.id  #Links to the devops_vpc
  cidr_block              = "10.0.1.0/24"  #Sets subnet IP range to 10.0.1.0/24 (256 IPs)
  map_public_ip_on_launch = true  #Enables public IP assignment for instances in this subnet
  availability_zone       = "eu-west-2a"  #Places subnet in eu-west-2a AZ
  tags = {  #Adds metadata for identification
    Name = "devops-public-subnet-1"  #Labels the subnet as devops-public-subnet-1
  }
}

# Public Subnet 2 (eu-west-2b)
resource "aws_subnet" "public_subnet_2" {  #Creates a public subnet in eu-west-2b
  vpc_id                  = aws_vpc.devops_vpc.id  #Links to the devops_vpc
  cidr_block              = "10.0.2.0/24"  #Sets subnet IP range to 10.0.2.0/24 (256 IPs)
  map_public_ip_on_launch = true  #Enables public IP assignment for instances in this subnet
  availability_zone       = "eu-west-2b"  #Places subnet in eu-west-2b AZ
  tags = {  #Adds metadata for identification
    Name = "devops-public-subnet-2"  #Labels the subnet as devops-public-subnet-2
  }
}

# Internet Gateway for VPC
resource "aws_internet_gateway" "devops_igw" {  #Creates an internet gateway for the VPC
  vpc_id = aws_vpc.devops_vpc.id  #Attaches to the devops_vpc
  tags = {  #Adds metadata for identification
    Name = "devops-igw"  #Labels the gateway as devops-igw
  }
}

# Route Table for Public Subnets
resource "aws_route_table" "public_route_table" {  #Creates a route table for public subnets
  vpc_id = aws_vpc.devops_vpc.id  #Links to the devops_vpc
  route {  #Defines a route for internet access
    cidr_block = "0.0.0.0/0"  #Routes all traffic (0.0.0.0/0) to the internet
    gateway_id = aws_internet_gateway.devops_igw.id  #Sends traffic through the devops_igw
  }
  tags = {  #Adds metadata for identification
    Name = "devops-public-route-table"  #Labels the route table as devops-public-route-table
  }
}

# Route Table Associations
resource "aws_route_table_association" "public_subnet_1_association" {  #Associates subnet 1 with the route table
  subnet_id      = aws_subnet.public_subnet_1.id  #Links to public_subnet_1
  route_table_id = aws_route_table.public_route_table.id  #Applies the public route table
}

resource "aws_route_table_association" "public_subnet_2_association" {  #Associates subnet 2 with the route table
  subnet_id      = aws_subnet.public_subnet_2.id  #Links to public_subnet_2
  route_table_id = aws_route_table.public_route_table.id  #Applies the public route table
}

# IAM Role for EKS Cluster
resource "aws_iam_role" "eks_cluster_role" {  #Creates an IAM role for the EKS cluster
  name = "eksClusterRole"  #Names the role "eksClusterRole" in AWS
  assume_role_policy = jsonencode({  #Defines the trust policy for the role
    Version = "2012-10-17"  #Sets policy version to 2012-10-17
    Statement = [{  #Starts a list of permissions
      Effect = "Allow"  #Allows the action
      Principal = {  #Specifies who can assume the role
        Service = "eks.amazonaws.com"  #Permits the EKS service to use this role
      }
      Action = "sts:AssumeRole"  #Grants permission to assume the role
    }]
  })
  tags = {  #Adds metadata for identification
    Name = "eks-cluster-role"  #Labels the role as "eks-cluster-role"
  }
}

# Attach EKS Cluster Policy to Role
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {  #Attaches a policy to the EKS cluster role
  role       = aws_iam_role.eks_cluster_role.name  #Links to the "eks_cluster_role"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"  #Attaches AmazonEKSClusterPolicy for cluster management
}

# IAM Role for EKS Node Group
resource "aws_iam_role" "eks_node_role" {  #Creates an IAM role for EKS worker nodes
  name = "eksNodeRole"  #Names the role "eksNodeRole" in AWS
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
    Name = "eks-node-role"  #Labels the role as "eks-node-role"
  }
}

# Attach Node Group Policies
resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {  #Attaches a policy for node communication
  role       = aws_iam_role.eks_node_role.name  #Links to the "eks_node_role"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"  #Attaches AmazonEKSWorkerNodePolicy for node-cluster interaction
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {  #Attaches a policy for networking
  role       = aws_iam_role.eks_node_role.name  #Links to the "eks_node_role"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"  #Attaches AmazonEKS_CNI_Policy for VPC networking (pod IPs)
}

resource "aws_iam_role_policy_attachment" "ecr_read_only_policy" {  #Attaches a policy for container image access
  role       = aws_iam_role.eks_node_role.name  #Links to the "eks_node_role"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"  #Attaches AmazonEC2ContainerRegistryReadOnly for pulling images from ECR
}