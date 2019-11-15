namespace: {{ .certmanager.namespace }}
email: {{ .email }}
gcloud:
  project: {{ .gcloud.project }}
credstash:
  svc_account_key: {{ .certmanager.svc_account.credstash.key }}
  svc_account_table: {{ .certmanager.svc_account.credstash.table }}
  svc_account_version: {{ .certmanager.svc_account.credstash.version | quote }}