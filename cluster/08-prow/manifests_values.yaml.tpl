namespace: {{ .prow.namespace }}
namespaceForJobs: {{ .prow.namespaceForJobs }}
credstash:
{{- range .prow.credstashSecrets }}
  - name: {{ .name }}
    keys:
{{- range .keys }}
    - name: {{ .name }}
      key: {{ .key }}
      table: {{ .table }}
      version: {{ .version | quote }}
{{- end }}
{{- end }}