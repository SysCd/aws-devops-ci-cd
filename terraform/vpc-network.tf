# Terraform Required Version
terraform {
  required_version = ">= 1.3.0"
}

# AWS Provider
provider "aws" {
  region = var.aws_region
}

# Variables (Define defaults)
variable "aws_region" {
  default = "eu-west-2"
}

variable "eks_cluster_name" {
  default = "devops-eks-cluster"
}

variable "node_instance_type" {
  default = "t3.small"
}

# VPC Configuration
resource "aws_vpc" "devops_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "devops-vpc"
  }
}

# Public Subnet 1 (eu-west-2a)
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.devops_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-2a"
  tags = {
    Name = "devops-public-subnet-1"
  }
}

# Public Subnet 2 (eu-west-2b)
resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.devops_vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-2b"
  tags = {
    Name = "devops-public-subnet-2"
  }
}

# Internet Gateway for VPC
resource "aws_internet_gateway" "devops_igw" {
  vpc_id = aws_vpc.devops_vpc.id
  tags = {
    Name = "devops-igw"
  }
}

# Route Table for Public Subnets
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.devops_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.devops_igw.id
  }
  tags = {
    Name = "devops-public-route-table"
  }
}

# Route Table Associations
resource "aws_route_table_association" "public_subnet_1_association" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_2_association" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}

# IAM Role for EKS Cluster
resource "aws_iam_role" "eks_cluster_role" {
  name = "eksClusterRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "eks.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
  tags = {
    Name = "eks-cluster-role"
  }
}

# Attach EKS Cluster Policy to Role
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# IAM Role for EKS Node Group
resource "aws_iam_role" "eks_node_role" {
  name = "eksNodeRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
  tags = {
    Name = "eks-node-role"
  }
}

# Attach Node Group Policies
resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "ecr_read_only_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}