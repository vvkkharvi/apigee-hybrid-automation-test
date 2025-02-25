provider "aws" {
  region = var.region
}

#######################################################################################################
# terraform {
#   backend "s3" {
#     bucket = "apigee-hybrid-prod"
#      key   = "apigee.tfstate"
#     region = "ap-south-1"
#   }
# }

#######################################################################################################

#node group role
resource "aws_iam_role" "nodegrp_role" {
  name = "hl-apigee-hybrid-prod-dr-nodepool-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach necessary IAM policies
resource "aws_iam_role_policy_attachment" "AmazonEBSCSIDriverPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.nodegrp_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryPullOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"
  role       = aws_iam_role.nodegrp_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodegrp_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodegrp_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodegrp_role.name
}

#######################################################################################################
#Cluster Role 
resource "aws_iam_role" "eks_role" {
  name = "hl-apigee-hybrid-prod-dr-cluster-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com",
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_role.name
}

#######################################################################################################
#ebs-csi-driver-role
resource "aws_iam_role" "ebs_driver_role" {
  name = "hl-apigee-hybrid-prod-ebscsidriver-dr-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com",
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "ebs_csi_driver_custom_policy" {
  name        = "hl-apigee-ebscsidriver-policy"
  description = "Custom policy for EBS CSI driver"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid     = "VisualEditor0",
        Effect  = "Allow",
        Action  = [
          "kms:Decrypt",
          "kms:GenerateDataKeyWithoutPlaintext",
          "kms:CreateGrant"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ebs_driver_custom_policy_attachment" {
  policy_arn = aws_iam_policy.ebs_csi_driver_custom_policy.arn
  role       = aws_iam_role.ebs_driver_role.name
}

resource "aws_iam_role_policy_attachment" "ebs_driver_aws_managed_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.ebs_driver_role.name
}



#######################################################################################################
#security group
resource "aws_security_group" "UAT-Apigee-cluster-security-group" {
  name_prefix = "eks-cluster-sg-hl-apigee-hybrid-prod-dr-cluster"
  description = "eks-cluster-sg-hl-apigee-hybrid-prod-dr-cluster"
  vpc_id      = var.vpc_id

  # Inbound rule for all traffic from any source
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # All protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound rule for all traffic to any destination
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # All protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-cluster-sg-hl-apigee-hybrid-prod-dr-cluster"
  }
}

#######################################################################################################
#eks cluster creation
resource "aws_eks_cluster" "apigee-cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_role.arn
  version =  var.kube_version

  vpc_config {
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    subnet_ids = [var.subnet_id_1, var.subnet_id_2, var.subnet_id_3]
    security_group_ids = [aws_security_group.UAT-Apigee-cluster-security-group.id]
  }

  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
  }

  tags = {
    Project      = "Inspire"
    Environment  = "Test"
    Owner        = "Paras B"
    Application  = "VirtualOffice"
    Name         = "hl-apigee-hybrid-non-prod-cluster"
  }

  kubernetes_network_config {
    ip_family = "ipv4"
  }

  depends_on = [
  aws_iam_role.eks_role,
 ]
}



# output "endpoint" {
#   value = aws_security_group.UAT-Apigee-cluster-security-group
# }

# output "kubeconfig-certificate-authority-data" {
#   value = aws_eks_cluster.apigee-cluster.certificate_authority[0].data
# }

#######################################################################################################

#add ons
resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.apigee-cluster.name
  addon_name   = "vpc-cni"
  addon_version = "v1.19.0-eksbuild.1"
}

resource "aws_eks_addon" "coredns" {
  cluster_name = aws_eks_cluster.apigee-cluster.name
  addon_name   = "coredns"
  addon_version = "v1.19.2-eksbuild.5"
}

# Amazon EBS CSI Driver addon for the EKS cluster
resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name = aws_eks_cluster.apigee-cluster.name
  addon_name   = "ebs-csi-driver"
#  addon_version = "v1.37.0-eksbuild.1"
  addon_version = "v1.39.0-eksbuild.1"


  service_account_role_arn = aws_iam_role.ebs_driver_role.arn
}

resource "aws_eks_addon" "eks_pod_identity_agent" {
  cluster_name = aws_eks_cluster.apigee-cluster.name
  addon_name   = "eks-pod-identity"
  addon_version = "v1.3.4-eksbuild.1"


}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name = aws_eks_cluster.apigee-cluster.name
  addon_name   = "kube-proxy"
  addon_version = "v1.30.9-eksbuild.3"
}

 
#######################################################################################################
#nodepool creation
resource "aws_eks_node_group" "apigee-data" {
  cluster_name    = aws_eks_cluster.apigee-cluster.name 
  node_group_name = "apigee-data" 
  node_role_arn   = aws_iam_role.nodegrp_role.arn 
  subnet_ids      = [var.subnet_id_1, var.subnet_id_2] 
  scaling_config {
    desired_size = 1 
    max_size     = 1 
    min_size     = 1 
  }
    labels = {
    "apigee.com/apigee-nodepool" = "apigee-data"
  }
  instance_types = [var.data_node_machine_type] # Replace with the desired instance types
  disk_size = var.data_node_disk_size # Replace with the desired storage size
  depends_on = [
   aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
   aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
  ]
}
resource "aws_eks_node_group" "apigee-runtime" {
  cluster_name    = aws_eks_cluster.apigee-cluster.name 
  node_group_name = "apigee-runtime" 
  node_role_arn   = aws_iam_role.nodegrp_role.arn 
  subnet_ids      = [var.subnet_id_1, var.subnet_id_2] 
  scaling_config {
    desired_size = var.desired_node_size
    max_size     = var.max_node_size
    min_size     = var.min_node_size 
  }
    labels = {
    "apigee.com/apigee-nodepool" = "apigee-runtime"
  }
  instance_types = [var.runtime_node_machine_type] # Replace with the desired instance types
  disk_size = var.runtime_node_disk_size # Replace with the desired storage size
  depends_on = [
   aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
   aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
  ]
}


##############################################################################
