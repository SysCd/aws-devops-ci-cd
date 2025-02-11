resource "aws_eks_node_group" "eks_nodes" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "eks-node-group"
  node_role_arn   = aws_iam_role.eks_worker_role.arn

  subnet_ids      = aws_subnet.eks_subnets[*].id
  instance_types  = ["t3.small"]   # Upgrade from t3.micro to t3.small

  scaling_config {
    desired_size = 1  # Keep 1 worker node
    min_size     = 1
    max_size     = 2  # Allow auto-scaling if needed
  }

  depends_on = [aws_eks_cluster.eks_cluster]
}
