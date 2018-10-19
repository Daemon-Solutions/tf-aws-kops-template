apiVersion: kops/v1alpha2
kind: Cluster
metadata:
  name: ${cluster_name}
spec:
  api:
    loadBalancer:
      type: ${lb_type}
  kubeAPIServer:
    authenticationTokenWebhookConfigFile: /srv/kubernetes/aws-iam-authenticator/kubeconfig.yaml
  hooks:
  - name: kops-hook-authenticator-config.service
    before:
      - kubelet.service
    roles: [Master]
    manifest: |
      [Unit]
      Description=Download AWS Authenticator configs from S3
      [Service]
      Type=oneshot
      ExecStart=/bin/mkdir -p /srv/kubernetes/aws-iam-authenticator
      ExecStart=/usr/local/bin/aws s3 cp --recursive ${config_base}/addons/authenticator /srv/kubernetes/aws-iam-authenticator/
  additionalPolicies:
    node: |
      ${node_additional_policies}
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
      type: Private
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
  image: kope.io/k8s-1.9-debian-jessie-amd64-hvm-ebs-2018-03-11
  machineType: ${node_instance_type}
  maxSize: ${node_asg_size_max}
  minSize: ${node_asg_size_min}
  nodeLabels:
    kops.k8s.io/instancegroup: nodes
  role: Node
  subnets:
${private_subnets_list}
${external_lbs_snippet}
${node_additional_sgs_snippet}

${bastion_ig_snippet}
