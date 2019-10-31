local k = import 'ksonnet/ksonnet.beta.4/k.libsonnet';

{
    prometheus+:: {
      local p = self,
      name:: $._config.prometheus.name,
      //local c = super.clusterRole,
      clusterRole:
        local clusterRole = k.rbac.v1.clusterRole;
        local policyRule = clusterRole.rulesType;

        local nodeMetricsRule = policyRule.new() +
                                policyRule.withApiGroups(['']) +
                                policyRule.withResources(['nodes/metrics']) +
                                policyRule.withVerbs(['get']);

        local metricsRule = policyRule.new() +
                            policyRule.withNonResourceUrls('/metrics') +
                            policyRule.withVerbs(['get']);

        local podNodesRule = policyRule.new() +
                             policyRule.withApiGroups(['']) +
                             policyRule.withResources(['pods', 'nodes']) +
                             policyRule.withVerbs(['list', 'get', 'watch']);

        local servicesRule = policyRule.new() +
                             policyRule.withApiGroups(['']) +
                             policyRule.withResources(['services', 'endpoints']) +
                             policyRule.withVerbs(['list', 'get', 'watch']);

        local rules = [nodeMetricsRule, metricsRule, podNodesRule, servicesRule];

        clusterRole.new() +
        clusterRole.mixin.metadata.withName('prometheus-' + p.name) +
        clusterRole.withRules(rules),
    },
}