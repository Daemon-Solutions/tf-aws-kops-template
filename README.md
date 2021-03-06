# tf-aws-kops-template

Returns a kops cluster template that can be used with `kops
create|replace`. Assumes:
 * VPC exists
 * Private and public subnets exist
 * Subnets are in >=3 AZs
 * Private topology
 * Private DNS
 * Calico networking
 * No bastions
 * RBAC enabled

## Usage

```js
module "cluster" {
  source           = "git::ssh://git@gogs.bashton.net/Bashton-Terraform-Modules/tf-aws-kops-template"
  cluster_name     = "my-k8s-cluster.private"
  state_bucket     = "my-kops-state-bucket"
  master_ha        = "0"
  azs              = [ "eu-west-1a", "eu-west-1b", "eu-west-1c" ]
  vpc_id           = "vpc-blahblahblah"
  private_subnets  = [ "subnet-blahblah", "subnet-blahblah", "subnet-blahblah" ]
  public_subnets   = [ "subnet-blahblah", "subnet-blahblah", "subnet-blahblah" ]
  master_instance_type = "c4.large"
  node_instance_type   = "t2.medium"
  node_asg_size_min    = "2"
  node_asg_size_max    = "2"
}
```

## Variables

Variables marked with an * are mandatory, the others have sane defaults and can be omitted.

 - `cluster_name`* - Name of the cluster (also the route53 zone)
 - `state_bucket`* - Name of S3 bucket where cluster state, PKI etc are kept
 - `master_ha` - If false there will be 1 master, if true there will be 3
 - `azs`* - list of AZs in which to distribute subnets
 - `vpc_cidr`* - CIDR of the VPC where the cluster will be deployed
 - `vpc_id`* - ID of the VPC where the cluster will be deployed
 - `public_subnets`* - Public subnet IDs
 - `private_subnets`* - Private subnet IDs
 - `master_instance_type` - Instance type for master(s)
 - `node_instance_type` - Instance type for nodes
 - `node_asg_size_min` - Minimum number fo nodes
 - `node_asg_size_max` - Maximum number fo nodes

## Outputs

 - `content` - the complete cluster configuration

# TODO

 - Address the assumptions above to make more generic
