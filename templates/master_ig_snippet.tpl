apiVersion: kops/v1alpha2
kind: InstanceGroup
metadata:
  labels:
    kops.k8s.io/cluster: ${cluster_name}
  name: master-${az}
spec:
  associatePublicIp: false
  image: ${image}
  machineType: ${master_instance_type}
  maxSize: 1
  minSize: ${master_asg_size_min}
  nodeLabels:
    kops.k8s.io/instancegroup: master-${az}
  role: Master
  subnets:
  - ${az}

---
