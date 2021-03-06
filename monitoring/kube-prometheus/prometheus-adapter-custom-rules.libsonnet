{
  _config+:: {
    prometheusAdapter+::{
      config:  |||
        rules:
        - seriesQuery: '{__name__=~"^container_.*",container_name!="POD",namespace!="",pod_name!=""}'
          seriesFilters: []
          resources:
            overrides:
              namespace:
                resource: namespace
              pod_name:
                resource: pod
          name:
            matches: ^container_(.*)_seconds_total$
            as: ""
          metricsQuery: sum(rate(<<.Series>>{<<.LabelMatchers>>,container_name!="POD"}[5m]))
            by (<<.GroupBy>>)
        - seriesQuery: '{__name__=~"^container_.*",container_name!="POD",namespace!="",pod_name!=""}'
          seriesFilters:
          - isNot: ^container_.*_seconds_total$
          resources:
            overrides:
              namespace:
                resource: namespace
              pod_name:
                resource: pod
          name:
            matches: ^container_(.*)_total$
            as: ""
          metricsQuery: sum(rate(<<.Series>>{<<.LabelMatchers>>,container_name!="POD"}[5m]))
            by (<<.GroupBy>>)
        - seriesQuery: '{__name__=~"^container_.*",container_name!="POD",namespace!="",pod_name!=""}'
          seriesFilters:
          - isNot: ^container_.*_total$
          resources:
            overrides:
              namespace:
                resource: namespace
              pod_name:
                resource: pod
          name:
            matches: ^container_(.*)$
            as: ""
          metricsQuery: sum(<<.Series>>{<<.LabelMatchers>>,container_name!="POD"}) by (<<.GroupBy>>)
        - seriesQuery: '{namespace!="",__name__!~"^container_.*"}'
          seriesFilters:
          - isNot: .*_total$
          resources:
            template: <<.Resource>>
          name:
            matches: ""
            as: ""
          metricsQuery: sum(<<.Series>>{<<.LabelMatchers>>}) by (<<.GroupBy>>)
        - seriesQuery: '{namespace!="",__name__!~"^container_.*"}'
          seriesFilters:
          - isNot: .*_seconds_total
          resources:
            template: <<.Resource>>
          name:
            matches: ^(.*)_total$
            as: ""
          metricsQuery: sum(rate(<<.Series>>{<<.LabelMatchers>>}[5m])) by (<<.GroupBy>>)
        - seriesQuery: '{namespace!="",__name__!~"^container_.*"}'
          seriesFilters: []
          resources:
            template: <<.Resource>>
          name:
            matches: ^(.*)_seconds_total$
            as: ""
          metricsQuery: sum(rate(<<.Series>>{<<.LabelMatchers>>}[5m])) by (<<.GroupBy>>)
        resourceRules:
          cpu:
            containerQuery: sum(rate(container_cpu_usage_seconds_total{<<.LabelMatchers>>,container!="POD",container!="",pod!=""}[5m])) by (<<.GroupBy>>)
            nodeQuery: sum(1 - rate(node_cpu_seconds_total{mode="idle"}[5m]) * on(namespace, pod) group_left(node) node_namespace_pod:kube_pod_info:{<<.LabelMatchers>>}) by (<<.GroupBy>>)
            resources:
              overrides:
                node:
                  resource: node
                namespace:
                  resource: namespace
                pod:
                  resource: pod
            containerLabel: container
          memory:
            containerQuery: sum(container_memory_working_set_bytes{<<.LabelMatchers>>,container!="POD",container!="",pod!=""}) by (<<.GroupBy>>)
            nodeQuery: sum(node_memory_MemTotal_bytes{job="node-exporter",<<.LabelMatchers>>} - node_memory_MemAvailable_bytes{job="node-exporter",<<.LabelMatchers>>}) by (<<.GroupBy>>)
            resources:
              overrides:
                instance:
                  resource: node
                namespace:
                  resource: namespace
                pod:
                  resource: pod
            containerLabel: container
          window: 5m
      |||,
    },
  },
}
