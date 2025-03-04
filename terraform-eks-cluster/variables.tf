variable "security_group_name_prefix" {
  type    = string
  default = "eks-cluster-sg"
}

variable "ingress_cidr_blocks" {
  type    = list(string)
}

variable "egress_cidr_blocks" {
  type    = list(string)
}

variable "subnet_ids" {
  type    = list(string)
}

variable "eks_role_arn" {
  type    = string
}

variable "region" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "kube_version" {
  type = string
}

variable "endpoint_private_access" {
  type = bool
}

variable "endpoint_public_access" {
  type = bool
}

variable "vpc_id" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "authentication_mode" {
     type = string
}

variable "ip_family" {
   type = string
}
variable "vpc_cni_name" {
   type = string
}

variable "vpc_cni_version" {
   type = string

}

variable "coredns_version" {
     type = string
}

variable "coredns_name" {
     type = string
}

variable "ebscsidriver_role" {
     type = string
}

variable "ebscsidriver_name" {
     type = string
}

variable "ebscsidriver_version" {
     type = string
}

variable "eks_pod_identity_name" {
     type = string
}

variable "eks_pod_identity_version" {
     type = string
}

variable "kube-proxy_name" {
     type = string
}
variable "kube-proxy_version" {
     type = string
}


variable "runtime_node_group_name" {
     type = string
}
 
variable "data_node_group_name" {
     type = string
}
variable "node_group_role" {
     type = string
}

variable "runtime_node_group_lables" {
  type = map(string)
}

variable "data_node_group_lables" {
  type = map(string)
}

variable "data_node_machine_type" {
  type = string
}

variable "data_node_disk_size" {
  type = string
}

variable "desired_node_size" {
  type = number
}

variable "max_node_size" {
  type = number
}

variable "min_node_size" {
  type = number
}

variable "runtime_node_machine_type" {
  type = string
}

variable "runtime_node_disk_size" {
  type = string
}

 