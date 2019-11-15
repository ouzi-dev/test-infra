provider: google
google:
  project: {{ .gcloud.project }}
replicas: {{ .externalDns.replicas }}
metrics:
  enabled: true
policy: sync