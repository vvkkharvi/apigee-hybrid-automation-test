 variable "subnet_id_1" {
  type = string
  default = "subnet-06cbaee4f582689cb"
 }
 
 variable "subnet_id_2" {
  type = string
  default = "subnet-0f553d9ba66f7b12d"
 }

  variable "subnet_id_3" {
  type = string
  default = "subnet-03484282661aaf320"
 }

variable "region" {
  type = string
  default = "ap-south-1"
 }
variable "cluster_name" {
  type = string
  default = "hl-apigee-hybrid-prod-dr-cluster"
 }
variable "kube_version" {
  type = string
  default = "1.30"
 }
variable "endpoint_private_access" {
  type = bool
  default = true
 }
variable "endpoint_public_access" {
  type = bool
  default = false
 }
variable "vpc_id" {
  type = string
  default = "vpc-06d885987f3e966bc"
 }
variable "data_node_machine_type" {
  type = string
  default = "t2.micro"
 }
variable "data_node_disk_size" {
  type = string
  default = "20"
 }
 variable "desired_node_size" {
  type = number
  default = 1
 }
 variable "max_node_size" {
  type = number
  default = 1
 }
 variable "min_node_size" {
  type = number
  default = 1
 }
 variable "runtime_node_machine_type" {
  type = string
  default = "t2.micro" 
 }
variable "runtime_node_disk_size" {
  type = string
  default = "20"
 }

 