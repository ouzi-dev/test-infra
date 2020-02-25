namespace: {{ .gkePreemptibleKiller.namespace }}
image:
  tag: 1.1.21
credstash:
  service_account:
    key: prow-gke-preemptible-killer-svc-account-key
    table: 
    version: 