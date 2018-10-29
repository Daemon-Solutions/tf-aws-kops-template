data "template_file" "cluster" {
  template = "${file("${path.module}/templates/cluster.tpl")}"

  vars {
    cluster_name             = "${var.cluster_name}"
    config_base              = "s3://${var.state_bucket}/${var.cluster_name}"
    vpc_cidr                 = "${var.vpc_cidr}"
    vpc_id                   = "${var.vpc_id}"
    etcd_members_snippet     = "${join("", data.template_file.etcd_members.*.rendered)}"
    private_subnets_snippet  = "${join("", data.template_file.private_subnets.*.rendered)}"
    public_subnets_snippet   = "${join("", data.template_file.public_subnets.*.rendered)}"
    master_ig_snippet        = "${join("", data.template_file.master_ig.*.rendered)}"
    bastion_ig_snippet       = "${join("", data.template_file.bastion_ig.*.rendered)}"
    private_subnets_list     = "${join("", formatlist("  - %s\n", slice(var.azs, 0, length(var.private_subnets))))}"
    node_instance_type       = "${var.node_instance_type}"
    node_asg_size_min        = "${var.node_asg_size_min}"
    node_asg_size_max        = "${var.node_asg_size_max}"
    image                    = "${var.node_ami}"
    external_lbs_snippet     = "${join("", data.template_file.external_lbs.*.rendered)}"
    node_additional_sgs_snippet = "${join("", data.template_file.node_additional_sgs.*.rendered)}"
    enable_bastion           = "${var.enable_bastion}"
    kubernetes_version       = "${var.kubernetes_version}"
    node_additional_policies = "${indent(6, var.node_additional_policies)}"
    master_additional_policies = "${indent(6, var.master_additional_policies)}"
    lb_type                  = "${var.api_public ? "Public" : "Internal" }"
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
  count    = "${var.private_subnet_count}"

  vars {
    subnet_id = "${element(var.private_subnets, count.index)}"
    az        = "${element(var.azs, count.index)}"
  }
}

data "template_file" "public_subnets" {
  template = "${file("${path.module}/templates/public_subnets_snippet.tpl")}"
  count    = "${var.public_subnet_count}"

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
    image                = "${var.master_ami}"
  }
}

data "template_file" "bastion_ig" {
  template = "${file("${path.module}/templates/bastion_ig_snippet.tpl")}"
  count    = "${var.enable_bastion}"

  vars {
    cluster_name         = "${var.cluster_name}"
    private_subnets_list = "${join("", formatlist("  - %s\n", slice(var.azs, 0, length(var.private_subnets))))}"
  }
}

data "template_file" "external_lbs" {
  template = "${file("${path.module}/templates/external_lbs_snippet.tpl")}"
  count    = "${var.node_target_group_arns_count}"

  vars {
    target_group_arns_list = "${join("", formatlist("  - targetGroupARN: %s\n", slice(var.node_target_group_arns, 0, length(var.node_target_group_arns))))}"
  }
}

data "template_file" "node_additional_sgs" {
  template = "${file("${path.module}/templates/node_additional_sgs_snippet.tpl")}"
  count    = "${var.node_additional_sgs_count}"

  vars {
    additional_sgs = "${join("", formatlist("  - %s\n", slice(var.node_additional_sgs, 0, length(var.node_additional_sgs))))}"
  }
}
