resource "aws_eks_node_group" "eks_nodes" {  #Creates an EKS node group (EC2 workers) for the Kubernetes cluster
  cluster_name    = aws_eks_cluster.devops_cluster.name  #Associates with the EKS cluster "devops-eks-cluster"
  node_group_name = "devops-node-group"  #Names the node group in AWS as "devops-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn  #Assigns IAM role for node permissions (e.g., EKS, ECR access)
  subnet_ids      = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]  #Deploys nodes in two public subnets (eu-west-2a, eu-west-2b) for high availability
  instance_types  = [var.node_instance_type]  #Sets EC2 instance type (t3.small with 2 vCPUs, 2GB RAM)
  scaling_config {  #Define auto scaling settings for the node group
    desired_size = 1  #Initial number of nodes: 1
    min_size     = 1  #Minimum number of nodes: 1
    max_size     = 2  #Maximum number of nodes: 2
  }
  depends_on = [  #Ensures IAM policies are attached before node group creation
    aws_iam_role_policy_attachment.eks_worker_node_policy,  
    aws_iam_role_policy_attachment.eks_cni_policy, 
    aws_iam_role_policy_attachment.ecr_read_only_policy 
  ]
  tags = {  #Adds metadata for identification in AWS
    Name = "devops-eks-nodes"  #Labels the node group as "devops-eks-nodes"
  }
}