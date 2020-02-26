namespace: {{ .gkePreemptibleKiller.namespace }}
image:
  tag: 1.1.21
service_account:
  credstash:
    key: {{ .gkePreemptibleKiller.service_account.credstash.key }}
    table: {{ default "credential-store" .gkePreemptibleKiller.service_account.credstash.table }}
    version: {{ default "" .gkePreemptibleKiller.service_account.credstash.version }}