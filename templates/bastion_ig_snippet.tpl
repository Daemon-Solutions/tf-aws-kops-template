---

apiVersion: kops/v1alpha2
kind: InstanceGroup
metadata:
  labels:
    kops.k8s.io/cluster: ${cluster_name}
  name: bastions
spec:
  image: ${image}
  machineType: t2.micro
  maxSize: 1
  minSize: 1
  nodeLabels:
    kops.k8s.io/instancegroup: bastions
  cloudLabels:
${cloud_labels_snippet}
  role: Bastion
  subnets:
${subnets_list}
