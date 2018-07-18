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

variable "private_subnets" {
  type = "list"
}

variable "public_subnets" {
  type = "list"
}
