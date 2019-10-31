{
  _config+:: {
    // This snippet walks the original object (super.jobs, set as temp var j) and creates a replacement jobs object
    //     excluding any members of the set specified (eg: controller and scheduler).
    local j = super.jobs,
    jobs: {
      [k]: j[k]
      for k in std.objectFields(j)
      if !std.setMember(k, ['CoreDNS'])
    },
  },

  // Same as above but for ServiceMonitor's
  local p = super.prometheus,
  prometheus: {
    [q]: p[q]
    for q in std.objectFields(p)
    if !std.setMember(q, ['serviceMonitorCoreDNS'])
  },

  prometheusAlerts+:: {
    local g = super.groups,
    groups: [
      l for l in g
      if !std.setMember(l.name, ['kubernetes-system-controller-manager', 'kubernetes-system-scheduler'])
    ],
  },

}
