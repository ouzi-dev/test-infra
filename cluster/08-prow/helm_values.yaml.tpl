prowbucketname: {{ .prow.prowbucketname }}
podNamespace: {{ .prow.namespaceForJobs }}
secrets:
  slackToken: slack-token
  githubToken: github-token
  oauthConfig: oauth-config
  bucketGcsCredentials: prow-bucket-gcs-credentials

deck:
  ingress:
    host: prow.{{ .baseDomain }}
    annotations:
      nginx.ingress.kubernetes.io/auth-url: "https://oauth2.{{ .baseDomain }}/oauth2/auth"
      nginx.ingress.kubernetes.io/auth-signin: "https://oauth2.{{ .baseDomain }}/oauth2/start?rd=/redirect/$http_host$request_uri"

hook:
  ingress:
    host: prow.{{ .baseDomain }}

github:
  org: {{ .github.org }}
  bot:
    username: {{ .github.bot.username }}

ghproxy:
  cache:
    sizeGB: 19
    storageClassName: ssd-retain

monitoring:
  enabled: true 