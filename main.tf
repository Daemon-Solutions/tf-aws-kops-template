data "template_file" "cluster" {
  template = "${file("${path.module}/templates/cluster.tpl")}"

  vars {
    cluster_name            = "${var.cluster_name}"
    config_base             = "s3://${var.state_bucket}/${var.cluster_name}"
    vpc_cidr                = "${var.vpc_cidr}"
    vpc_id                  = "${var.vpc_id}"
    etcd_members_snippet    = "${join("", data.template_file.etcd_members.*.rendered)}"
    private_subnets_snippet = "${join("", data.template_file.private_subnets.*.rendered)}"
    public_subnets_snippet  = "${join("", data.template_file.public_subnets.*.rendered)}"
    master_ig_snippet       = "${join("", data.template_file.master_ig.*.rendered)}"
    bastion_ig_snippet      = "${join("", data.template_file.bastion_ig.*.rendered)}"
    private_subnets_list    = "${join("", formatlist("  - %s\n", var.azs))}"
    node_instance_type      = "${var.node_instance_type}"
    node_asg_size_min       = "${var.node_asg_size_min}"
    node_asg_size_max       = "${var.node_asg_size_max}"
    enable_bastion          = "${var.enable_bastion}"
  }
}

data "template_file" "etcd_members" {
  template = "${file("${path.module}/templates/etcd_members_snippet.tpl")}"
  count    = "${var.master_ha ? 3 : 1}"

  vars {
    az  = "${element(var.azs, count.index)}"
    azl = "${substr(element(var.azs, count.index), -1, 1)}"
  }
}

data "template_file" "private_subnets" {
  template = "${file("${path.module}/templates/private_subnets_snippet.tpl")}"
  count    = "${length(var.private_subnets)}"

  vars {
    subnet_id = "${element(var.private_subnets, count.index)}"
    az        = "${element(var.azs, count.index)}"
  }
}

data "template_file" "public_subnets" {
  template = "${file("${path.module}/templates/public_subnets_snippet.tpl")}"
  count    = "${length(var.public_subnets)}"

  vars {
    subnet_id = "${element(var.public_subnets, count.index)}"
    az        = "${element(var.azs, count.index)}"
  }
}

data "template_file" "master_ig" {
  template = "${file("${path.module}/templates/master_ig_snippet.tpl")}"
  count    = "${var.master_ha ? 3 : 1}"

  vars {
    cluster_name         = "${var.cluster_name}"
    az                   = "${element(var.azs, count.index)}"
    master_instance_type = "${var.master_instance_type}"
  }
}

data "template_file" "bastion_ig" {
  template = "${file("${path.module}/templates/bastion_ig_snippet.tpl")}"
  count    = "${var.enable_bastion}"

  vars {
    cluster_name            = "${var.cluster_name}"
    public_subnets_list     = "${join("", formatlist("  - utility-%s\n", var.azs))}"
  }
}
