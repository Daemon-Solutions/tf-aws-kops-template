variable "cluster_name" {
  type = "string"
}

variable "state_bucket" {
  type = "string"
}

variable "master_ha" {
  default = "0"
}

variable "azs" {
  type = "list"
}

variable "vpc_id" {
  type = "string"
}

variable "vpc_cidr" {
  type = "string"
}

variable "private_subnets" {
  type = "list"
}

variable "private_subnet_count" {
  type = "string"
}

variable "public_subnets" {
  type = "list"
}

variable "public_subnet_count" {
  type = "string"
}

variable "master_instance_type" {
  type    = "string"
  default = "c4.large"
}

variable "master_ami" {
  type    = "string"
  default = "kope.io/k8s-1.10-debian-jessie-amd64-hvm-ebs-2018-08-17"
}

variable "master_additional_policies" {
  type    = "string"
  default = ""
}

variable "node_ami" {
  type    = "string"
  default = "kope.io/k8s-1.10-debian-jessie-amd64-hvm-ebs-2018-08-17"
}

variable "node_instance_type" {
  type    = "string"
  default = "t2.medium"
}

variable "node_asg_size_min" {
  type    = "string"
  default = "2"
}

variable "node_asg_size_max" {
  type    = "string"
  default = "2"
}

variable "master_asg_size_min" {
  type    = "string"
  default = "1"
}

variable "enable_bastion" {
  default = "0"
}

variable "node_additional_policies" {
  type    = "string"
  default = ""
}

variable "node_target_group_arns" {
  type    = "list"
  default = []
}

variable "node_target_group_arns_count" {
  type    = "string"
  default = "1"
}

variable "node_additional_sgs" {
  type    = "list"
  default = []
}

variable "node_additional_sgs_count" {
  type    = "string"
  default = "1"
}

variable "kubernetes_version" {
  type    = "string"
  default = "1.9.6"
}

variable "api_public" {
  type    = "string"
  default = "0"
}

variable "dns_topology" {
  type    = "string"
  default = "Private"
}

variable "enable_aws_iam_authenticator" {
  default = "true"
}
