region       = "ap-south-1"
kube_version = "1.30"

#security group
security_group_name_prefix = "eks-cluster-sg"
ingress_cidr_blocks        = ["0.0.0.0/0"]
egress_cidr_blocks         = ["0.0.0.0/0"]

#eks cluster
cluster_name = "eks-cluster-name"
vpc_id       = "vpc-id"

subnet_ids = [
  "subnet-id",
  "subnet-id",
  "subnet-id"
]
endpoint_private_access = true
endpoint_public_access  = false
eks_role_arn            = "EKS_ARN"
authentication_mode     = "API_AND_CONFIG_MAP"
ip_family               = "ipv4"

tags = {
  Project     = "Inspire"
  Name        = "NAME OF THE COMPANY"
  Environment = "Test"
  Owner       = "NAME"
  Application = "VirtualOffice"
}

#add ons
vpc_cni_name    = "vpc-cni"
vpc_cni_version = "v1.19.0-eksbuild.1"

coredns_name    = "coredns"
coredns_version = "v1.19.2-eksbuild.5"

ebscsidriver_name = "ebs-csi-driver"
ebscsidriver_version     = "v1.39.0-eksbuild.1"
ebscsidriver_role        = "EBS_DRIVER_ARN"

eks_pod_identity_name    = "eks-pod-identity"
eks_pod_identity_version = "v1.3.4-eksbuild.1"

kube-proxy_name          = "kube-proxy"
kube-proxy_version       = "v1.30.9-eksbuild.3"

#nodepools
runtime_node_group_name = "apigee-runtime"
data_node_group_name    = "apigee-data"
node_group_role         = "NODE_GROUP_ARN"
data_node_machine_type  = "t2.micro"
data_node_disk_size     = "20"
runtime_node_machine_type = "t2.micro"
runtime_node_disk_size    = "20"
desired_node_size = 3
max_node_size     = 3
min_node_size     = 3

data_node_group_lables = {
  "apigee.com/apigee-nodepool" = "data-runtime"
}

runtime_node_group_lables = {
  "apigee.com/apigee-nodepool" = "apigee-runtime"
}

