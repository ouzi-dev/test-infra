local alertmanagerHost = 'alertmanager.test-infra.ouzi.io';
local prometheusHost = 'prometheus.test-infra.ouzi.io';

local prometheusVPC = import 'pvc.libsonnet';

local kp =
  (import 'kube-prometheus/kube-prometheus.libsonnet') +
  (import 'kube-prometheus/kube-prometheus-anti-affinity.libsonnet') +
  (import 'kube-prometheus/kube-prometheus-managed-cluster.libsonnet') +
  (import 'kube-prometheus/kube-prometheus-config-mixins.libsonnet') + 
  (import 'managed-gke.libsonnet') +
  (import 'additional-scrape.libsonnet') +
  (import 'pvc.libsonnet') +
  (import 'prometheus-adapter-custom-rules.libsonnet') +
  (import 'alertmanager-config.libsonnet') +
  {
    _config+:: {
      namespace: 'monitoring',
      customPVCSize: '100Gi',
    },
    alertmanager+:: {
      alertmanager+: {
        spec+: {
          externalUrl: 'https://' + alertmanagerHost,
        },
      },
    },
    prometheus+:: {
      prometheus+: {
        spec+: {
          externalUrl: 'https://' + prometheusHost,
          replicas: 1,
          retention: '30d',
        },
      },
    },
  };

{ ['00-namespace']: kp.kubePrometheus[name] for name in std.objectFields(kp.kubePrometheus) } +
{
  ['01-prometheus-operator-' + name]: kp.prometheusOperator[name]
  for name in std.filter((function(name) name != 'serviceMonitor'), std.objectFields(kp.prometheusOperator))
} +
{ 'prometheus-operator-serviceMonitor': kp.prometheusOperator.serviceMonitor } +
{ ['node-exporter-' + name]: kp.nodeExporter[name] for name in std.objectFields(kp.nodeExporter) } +
{ ['kube-state-metrics-' + name]: kp.kubeStateMetrics[name] for name in std.objectFields(kp.kubeStateMetrics) } +
{ ['alertmanager-' + name]: kp.alertmanager[name] for name in std.objectFields(kp.alertmanager) } +
{ ['prometheus-' + name]: kp.prometheus[name] for name in std.objectFields(kp.prometheus) } +
{ ['prometheus-adapter-' + name]: kp.prometheusAdapter[name] for name in std.objectFields(kp.prometheusAdapter) }
