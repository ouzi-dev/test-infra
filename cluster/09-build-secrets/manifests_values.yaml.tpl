namespaceForJobs: {{ .prow.namespaceForJobs }}
credstash:
{{- range .build.credstashSecrets }}
  - name: {{ .name }}
    keys:
{{- range .keys }}
    - name: {{ .name }}
      key: {{ .key }}
      table: {{ .table }}
      version: {{ .version | quote }}
{{- end }}
{{- end }}