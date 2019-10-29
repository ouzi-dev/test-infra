
    {
        local k = import 'ksonnet/ksonnet.beta.3/k.libsonnet',
        local ingress = k.extensions.v1beta1.ingress,
        local ingressTls = ingress.mixin.spec.tlsType,
        local ingressRule = ingress.mixin.spec.rulesType,
        local httpIngressPath = ingressRule.mixin.http.pathsType,
        local alertmanagerSecretName = 'alertmanager-tls',
        local prometheusSecretName = 'prometheus-tls',
        local oauthNamespace = 'oauth-proxy',
        _config+::{
            namespace: 'monitoring',
            alertmanagerHost: 'alertmanager.example.com',
            prometheusHost: 'prometheus.example.com',
            tlsEnabled: false,
        },
        ingress+:: {
            'alertmanager':
                ingress.new() +
                ingress.mixin.metadata.withName('alertmanager') +
                ingress.mixin.metadata.withNamespace(namespace) +
                ingress.mixin.metadata.withAnnotations({
                'certmanager.io/cluster-issuer': 'letsencrypt-prod',
                'ingress.kubernetes.io/ssl-redirect': 'true',
                'kubernetes.io/ingress.class': 'nginx',
                'nginx.ingress.kubernetes.io/auth-url': 'https://$host/oauth2/auth',
                'nginx.ingress.kubernetes.io/auth-signin': 'https://$host/oauth2/start?rd=$escaped_request_uri',
                }) +
                ingress.mixin.spec.withRules(
                ingressRule.new() +
                ingressRule.withHost(alertmanagerHost) +
                ingressRule.mixin.http.withPaths(
                    httpIngressPath.new() +
                    httpIngressPath.mixin.backend.withServiceName('alertmanager-main') +
                    httpIngressPath.mixin.backend.withServicePort($._config.bleh)
                ),
                ) +
                ingress.mixin.spec.withTls(
                ingressTls.new() +
                ingressTls.withHosts([alertmanagerHost]) +
                ingressTls.withSecretName(alertmanagerSecretName)
                ),
            'alertmanager-oauth':
                ingress.new() +
                ingress.mixin.metadata.withName('alertmanager-oauth') +
                ingress.mixin.metadata.withNamespace(oauthNamespace) +
                ingress.mixin.metadata.withAnnotations({
                'certmanager.io/cluster-issuer': 'letsencrypt-prod',
                'ingress.kubernetes.io/ssl-redirect': 'true',
                'kubernetes.io/ingress.class': 'nginx',
                }) +
                ingress.mixin.spec.withRules(
                ingressRule.new() +
                ingressRule.withHost(alertmanagerHost) +
                ingressRule.mixin.http.withPaths(
                    httpIngressPath.new() +
                    httpIngressPath.mixin.backend.withServiceName('oauth2-proxy') +
                    httpIngressPath.mixin.backend.withServicePort('http')
                ),
                ) +
                ingress.mixin.spec.withTls(
                ingressTls.new() +
                ingressTls.withHosts([alertmanagerHost]) +
                ingressTls.withSecretName(alertmanagerSecretName)
                ),
            'prometheus':
                ingress.new() +
                ingress.mixin.metadata.withName('prometheus') +
                ingress.mixin.metadata.withNamespace(namespace) +
                ingress.mixin.metadata.withAnnotations({
                'certmanager.io/cluster-issuer': 'letsencrypt-prod',
                'ingress.kubernetes.io/ssl-redirect': 'true',
                'kubernetes.io/ingress.class': 'nginx',
                'nginx.ingress.kubernetes.io/auth-url': 'https://$host/oauth2/auth',
                'nginx.ingress.kubernetes.io/auth-signin': 'https://$host/oauth2/start?rd=$escaped_request_uri',
                }) +
                ingress.mixin.spec.withRules(
                ingressRule.new() +
                ingressRule.withHost(prometheusHost) +
                ingressRule.mixin.http.withPaths(
                    httpIngressPath.new() +
                    httpIngressPath.mixin.backend.withServiceName('prometheus-k8s') +
                    httpIngressPath.mixin.backend.withServicePort('web')
                ),
                ) +
                ingress.mixin.spec.withTls(
                ingressTls.new() +
                ingressTls.withHosts([prometheusHost]) +
                ingressTls.withSecretName(prometheusSecretName)
                ),
            'prometheus-oauth':
                ingress.new() +
                ingress.mixin.metadata.withName('prometheus-oauth') +
                ingress.mixin.metadata.withNamespace(oauthNamespace) +
                ingress.mixin.metadata.withAnnotations({
                'certmanager.io/cluster-issuer': 'letsencrypt-prod',
                'ingress.kubernetes.io/ssl-redirect': 'true',
                'kubernetes.io/ingress.class': 'nginx',
                }) +
                ingress.mixin.spec.withRules(
                ingressRule.new() +
                ingressRule.withHost(prometheusHost) +
                ingressRule.mixin.http.withPaths(
                    httpIngressPath.new() +
                    httpIngressPath.mixin.backend.withServiceName('oauth2-proxy') +
                    httpIngressPath.mixin.backend.withServicePort('http')
                ),
                ) +
                ingress.mixin.spec.withTls(
                ingressTls.new() +
                ingressTls.withHosts([prometheusHost]) +
                ingressTls.withSecretName(prometheusSecretName)
                ),
        }
    }
