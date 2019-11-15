## nginx configuration
## Ref: https://github.com/kubernetes/ingress/blob/master/controllers/nginx/configuration.md
##
controller:
  autoscaling:
    enabled: true
  service:
    omitClusterIP: true
    annotations: 
      external-dns.alpha.kubernetes.io/hostname: prow.{{ .baseDomain }}
  publishService:
    enabled: true

defaultBackend:
  service:
    omitClusterIP: true
