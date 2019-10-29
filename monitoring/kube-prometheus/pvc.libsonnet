local k = import 'ksonnet/ksonnet.beta.4/k.libsonnet';
local pvc = k.core.v1.persistentVolumeClaim;
local defaultPVCSize = '200Gi';
local defaultPVCStorageClass = 'default';

{
  _config+:: {
    customPVCSize: defaultPVCSize,
    customPVCStorageClass: defaultPVCStorageClass,
  },
  prometheus+:: {
    prometheus+: {
      spec+: {
        storage: {  // https://github.com/coreos/prometheus-operator/blob/master/Documentation/api.md#storagespec
          volumeClaimTemplate:  // (same link as above where the 'pvc' variable is defined)
            pvc.new() +  // http://g.bryan.dev.hepti.center/core/v1/persistentVolumeClaim/#core.v1.persistentVolumeClaim.new
            pvc.mixin.spec.withAccessModes('ReadWriteOnce') +
            pvc.mixin.spec.resources.withRequests({ storage: $._config.customPVCSize }) +
            pvc.mixin.spec.withStorageClassName($._config.customPVCStorageClass),
        },
      },
    },
  },
}