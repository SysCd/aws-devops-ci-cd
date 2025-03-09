resource "aws_eks_cluster" "devops_cluster" {
  name     = var.eks_cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = "1.28"
  vpc_config {
    subnet_ids = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
  }
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]
  tags = {
    Name = "devops-eks-cluster"
  }
}