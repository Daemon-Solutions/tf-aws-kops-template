apiVersion: kops/v1alpha2
kind: Cluster
metadata:
  name: ${cluster_name}
spec:
  api:
    loadBalancer:
      type: Internal
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
    allowContainerRegistry: false
    legacy: false
  kubernetesApiAccess:
  - 0.0.0.0/0
  kubernetesVersion: 1.9.6
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
    dns:
      type: Private
    masters: private
    nodes: private

---

${master_igs_snippet}

apiVersion: kops/v1alpha2
kind: InstanceGroup
metadata:
  labels:
    kops.k8s.io/cluster: ${cluster_name}
  name: nodes
spec:
  associatePublicIp: false
  image: kope.io/k8s-1.9-debian-jessie-amd64-hvm-ebs-2018-03-11
  machineType: ${node_instance_type}
  maxSize: ${node_asg_size_max}
  minSize: ${node_asg_size_min}
  nodeLabels:
    kops.k8s.io/instancegroup: nodes
  role: Node
  subnets:
${private_subnets_list}
