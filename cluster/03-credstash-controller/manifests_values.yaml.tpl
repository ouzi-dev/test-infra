namespace: {{ .credstashcontroller.namespace }}
image: davidjmarkey/credstash-kubernetes-controller:0.6.2
aws:
  region: {{ .credstashcontroller.aws.region }}