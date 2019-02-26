apiVersion: kops/v1alpha2
kind: Cluster
metadata:
  name: ${cluster_name}
spec:
  api:
    loadBalancer:
      type: ${lb_type}
${aws_iam_authenticator_snippet}
  additionalPolicies:
    node: |
      ${node_additional_policies}
    master: |
      ${master_additional_policies}
  authorization:
    rbac: {}
  channel: stable
  cloudProvider: aws
  configBase: ${config_base}
  etcdClusters:
  - etcdMembers:
${etcd_members_snippet}
    name: main
  - etcdMembers:
${etcd_members_snippet}
    name: events
  iam:
    allowContainerRegistry: true
    legacy: false
  kubernetesApiAccess:
  - 0.0.0.0/0
  kubernetesVersion: ${kubernetes_version}
  masterPublicName: api.${cluster_name}
  networkCIDR: ${vpc_cidr}
  networkID: ${vpc_id}
  networking:
    calico: {}
  nonMasqueradeCIDR: 100.64.0.0/10
  sshAccess:
  - 0.0.0.0/0
  subnets:
${private_subnets_snippet}
${public_subnets_snippet}
  topology:
    bastion:
      bastionPublicName: bastion.${cluster_name}
    dns:
      type: ${dns_topology}
    masters: private
    nodes: private

---

${master_ig_snippet}

apiVersion: kops/v1alpha2
kind: InstanceGroup
metadata:
  labels:
    kops.k8s.io/cluster: ${cluster_name}
  name: nodes
spec:
  associatePublicIp: false
  image: ${image}
  machineType: ${node_instance_type}
  maxSize: ${node_asg_size_max}
  minSize: ${node_asg_size_min}
  nodeLabels:
    kops.k8s.io/instancegroup: nodes
  cloudLabels:
${cloud_labels_snippet}
  role: Node
  subnets:
${private_subnets_list}
${external_lbs_snippet}
${node_additional_sgs_snippet}

${bastion_ig_snippet}
