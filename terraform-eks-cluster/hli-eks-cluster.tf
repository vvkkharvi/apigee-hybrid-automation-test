

#######################################################################################################
#security group

resource "aws_security_group" "UAT-Apigee-cluster-security-group" {
  name_prefix = "${var.security_group_name_prefix}-${var.cluster_name}"
  description = "${var.security_group_name_prefix}-${var.cluster_name}"
  vpc_id      = var.vpc_id

  # Inbound rule for all traffic from any source
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # All protocols
    cidr_blocks = var.ingress_cidr_blocks
  }

  # Outbound rule for all traffic to any destination
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # All protocols
    cidr_blocks = var.egress_cidr_blocks
  }

  tags = {
    Name = "${var.security_group_name_prefix}-${var.cluster_name}"
  }
}

#######################################################################################################
#eks cluster creation
resource "aws_eks_cluster" "apigee-cluster" {
  name     = var.cluster_name
  role_arn = var.eks_role_arn
  version  = var.kube_version

  vpc_config {
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    subnet_ids              = var.subnet_ids
    security_group_ids      = [aws_security_group.UAT-Apigee-cluster-security-group.id]
  }

  access_config {
    authentication_mode = var.authentication_mode
  }

  tags = var.tags

  kubernetes_network_config {
    ip_family = var.ip_family
  }

  depends_on = [
    aws_iam_role.eks_role
  ]
}

#######################################################################################################

#add ons
resource "aws_eks_addon" "vpc_cni" {
  cluster_name  = aws_eks_cluster.apigee-cluster.name
  addon_name    = var.vpc_cni_name
  addon_version = var.vpc_cni_version
}

resource "aws_eks_addon" "coredns" {
  cluster_name  = aws_eks_cluster.apigee-cluster.name
  addon_name    = var.coredns_name
  addon_version = var.coredns_version
}

# Amazon EBS CSI Driver addon for the EKS cluster
resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name = aws_eks_cluster.apigee-cluster.name
  addon_name   = var.ebscsidriver_name
  #  addon_version = "v1.37.0-eksbuild.1"
  addon_version = var.ebscsidriver_version


  service_account_role_arn = var.ebscsidriver_role
}

resource "aws_eks_addon" "eks_pod_identity_agent" {
  cluster_name  = aws_eks_cluster.apigee-cluster.name
  addon_name    = var.eks_pod_identity_name
  addon_version = var.eks_pod_identity_version
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name  = aws_eks_cluster.apigee-cluster.name
  addon_name    = var.kube-proxy_name
  addon_version = var.kube-proxy_version
}


#######################################################################################################
#nodepool creation
resource "aws_eks_node_group" "apigee-data" {
  cluster_name    = aws_eks_cluster.apigee-cluster.name
  node_group_name = var.data_node_group_name
  node_role_arn   = var.node_group_role
  subnet_ids      = var.subnet_ids
  scaling_config {
    desired_size = var.desired_node_size
    max_size     = var.max_node_size
    min_size     = var.min_node_size
  }
  labels = var.data_node_group_lables
  instance_types = [var.data_node_machine_type] # Replace with the desired instance types
  disk_size      = var.data_node_disk_size      # Replace with the desired storage size
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
  ]
}
resource "aws_eks_node_group" "apigee-runtime" {
  cluster_name    = aws_eks_cluster.apigee-cluster.name
  node_group_name = var.runtime_node_group_name
  node_role_arn   = var.node_group_role
  subnet_ids      = var.subnet_ids
  scaling_config {
    desired_size = var.desired_node_size
    max_size     = var.max_node_size
    min_size     = var.min_node_size
  }
  labels = var.runtime_node_group_lables
  instance_types = [var.runtime_node_machine_type] # Replace with the desired instance types
  disk_size      = var.runtime_node_disk_size      # Replace with the desired storage size
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
  ]
}


##############################################################################
