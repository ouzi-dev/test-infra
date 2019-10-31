local deck = import 'prow-dashboards/deck.jsonnet';
local ghproxy = import 'prow-dashboards/ghproxy.jsonnet';
local hook = import 'prow-dashboards/hook.jsonnet';
local plank = import 'prow-dashboards/plank.jsonnet';
local prow = import 'prow-dashboards/prow.jsonnet';
local sinker = import 'prow-dashboards/sinker.jsonnet';
local tide = import 'prow-dashboards/tide.jsonnet';

local prowDashboards = [
  'deck-dashboard',
  'ghproxy-dashboard',
  'hook-dashboard',
  'plank-dashboard',
  'prow-dashboard',
  'sinker-dashboard',
  'tide-dashboard',
];

local branch = 'master';
local rawDashboards = [
  'nginx-ingress-controller',
];

local outputPath = 'https://raw.githubusercontent.com/ouzi-dev/test-infra/' + branch + '/monitoring/grafana-dashboards/output/';
local rawPath = 'https://raw.githubusercontent.com/ouzi-dev/test-infra/' + branch + '/monitoring/grafana-dashboards/raw/';

local mixin = 
  (import "kubernetes-mixin/mixin.libsonnet") +
  {
  _config+:: {
    kubeStateMetricsSelector: 'job="kube-state-metrics"',
    cadvisorSelector: 'job="kubernetes-cadvisor"',
    nodeExporterSelector: 'job="kubernetes-node-exporter"',
    kubeletSelector: 'job="kubernetes-kubelet"',
    grafanaK8s+:: {
      dashboardNamePrefix: 'Mixin / ',
      dashboardTags: ['kubernetes', 'infrastucture'],
    },
  },
};

local dashboardValues = {
  dashboards: {
    default: {
      ['mixin-' + std.strReplace(name, '.json', '')]: {url: outputPath + 'mixin-' + name }
      for name in std.objectFields(mixin.grafanaDashboards)
    },
  },
};

local allDashboardsValues = 
  dashboardValues + 
  {
    dashboards+: {
      default+: {
        [name]: {url: rawPath + name + '.json'}
        for name in rawDashboards
      },
    },
  } + 
  {
    dashboards+: {
      default+: {
        [name]: {url: outputPath + name + '.json'}
        for name in prowDashboards
      },
    },
  };
  

{ ['mixin-' + name]: mixin.grafanaDashboards[name] for name in std.objectFields(mixin.grafanaDashboards)} +
{['deck-dashboard.json']: deck} +
{['ghproxy-dashboard.json']: ghproxy} +
{['hook-dashboard.json']: hook} +
{['plank-dashboard.json']: plank} +
{['prow-dashboard.json']: prow} +
{['sinker-dashboard.json']: sinker} +
{['tide-dashboard.json']: tide} +
{['values.json']: allDashboardsValues}
