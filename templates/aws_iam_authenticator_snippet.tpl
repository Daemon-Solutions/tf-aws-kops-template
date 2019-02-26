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
      ExecStart=/bin/bash -c 'PATH=/bin:/usr/local/bin aws s3 cp --recursive ${config_base}/addons/authenticator /srv/kubernetes/aws-iam-authenticator/'
