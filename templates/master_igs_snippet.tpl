apiVersion: kops/v1alpha2
kind: InstanceGroup
metadata:
  labels:
    kops.k8s.io/cluster: ${cluster_name}
  name: master-${az}
spec:
  associatePublicIp: false
  image: kope.io/k8s-1.9-debian-jessie-amd64-hvm-ebs-2018-03-11
  machineType: c4.large
  maxSize: 1
  minSize: 1
  nodeLabels:
    kops.k8s.io/instancegroup: master-${az}
  role: Master
  subnets:
  - ${az}

---
