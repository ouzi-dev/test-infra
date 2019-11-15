namespace: {{ .oauth2Proxy.namespace }}
image: quay.io/pusher/oauth2_proxy:v4.0.0
github:
  org: {{ .github.org }}
baseDomain: {{ .baseDomain }}
host: oauth2.{{ .baseDomain }}
credstash:
  oauthproxy_clientid:
    key: {{ .oauth2Proxy.clientid.credstash.key }}
    table: {{ .oauth2Proxy.clientid.credstash.table }}
    version: {{ .oauth2Proxy.clientid.credstash.version | quote }}
  oauthproxy_clientsecret:
    key: {{ .oauth2Proxy.clientsecret.credstash.key }}
    table: {{ .oauth2Proxy.clientsecret.credstash.table }}
    version: {{ .oauth2Proxy.clientsecret.credstash.version | quote }}
  oauthproxy_cookiesecret:
    key: {{ .oauth2Proxy.cookiesecret.credstash.key }}
    table: {{ .oauth2Proxy.cookiesecret.credstash.table }}
    version: {{ .oauth2Proxy.cookiesecret.credstash.version | quote }}  