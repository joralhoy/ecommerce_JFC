provider "aws" {
  region = "us-east-1"
}


resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.project_name}-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })
}


resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_cloudwatch_log_group" "eks_cluster_logs" {
  name              = "/aws/eks/${aws_eks_cluster.eks_cluster.name}/cluster"
  retention_in_days = 30 
  tags = {
    Project = var.project_name
  }
}

resource "aws_eks_cluster" "eks_cluster" {
  name     = "${var.project_name}-eks-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = var.private_subnet_ids
  }

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]
}


resource "aws_iam_role" "eks_fargate_pod_execution_role" {
  name = "${var.project_name}-eks-fargate-pod-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "eks-fargate-pods.amazonaws.com"
      }
    }]
  })

  tags = {
    Name = "${var.project_name}-eks-fargate-pod-execution-role"
    Project = var.project_name
  }
}

resource "aws_iam_role_policy_attachment" "eks_fargate_pod_execution_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.eks_fargate_pod_execution_role.name
}


resource "aws_eks_fargate_profile" "eks_fargate_profile" {
  cluster_name           = aws_eks_cluster.eks_cluster.name
  fargate_profile_name   = "${var.project_name}-fargate-profile"
  pod_execution_role_arn = aws_iam_role.eks_fargate_pod_execution_role.arn

  subnet_ids = var.private_subnet_ids

  selector {
    namespace = "default"
  }
  selector {
    namespace = "jfc-ecommerce-front" 
  }
  selector {
    namespace = "jfc-ecommerce-back" 
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_fargate_pod_execution_policy
  ]
  tags = {
    Name = "${var.project_name}-fargate-profile"
  }
}
