local k = import 'ksonnet/ksonnet.beta.4/k.libsonnet';
local clusterRole = k.rbac.v1.clusterRole;
local policyRule = clusterRole.rulesType;
{
  prometheus+:: {
    clusterRole+: {
      rules+:[
        local podNodesRule = policyRule.new() +
                             policyRule.withApiGroups(['']) +
                             policyRule.withResources(['pods', 'nodes']) +
                             policyRule.withVerbs(['list', 'get', 'watch']);
        podNodesRule,
        local servicesRule = policyRule.new() +
                             policyRule.withApiGroups(['']) +
                             policyRule.withResources(['services', 'endpoints']) +
                             policyRule.withVerbs(['list', 'get', 'watch']);
        servicesRule,
      ],
    },
  },
}