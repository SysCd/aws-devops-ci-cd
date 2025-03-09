resource "aws_eks_node_group" "eks_nodes" {
  cluster_name    = aws_eks_cluster.devops_cluster.name
  node_group_name = "devops-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
  instance_types  = [var.node_instance_type]
  scaling_config {
    desired_size = 1
    min_size     = 1
    max_size     = 2
  }
  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.ecr_read_only_policy
  ]
  tags = {
    Name = "devops-eks-nodes"
  }
}


