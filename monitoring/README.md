# Ouzi Prow monitoring

## Prometheus

We use [kube-prometheus](https://github.com/coreos/kube-prometheus) to generate all the manifests for prometheus and alertmanager.

To generate the manifests you just need to run:
```
make compile
```

## Grafana

Important: 

* We need to create the secret with the username and password for the admin user, these credentials are in credstash and you can create the secret just running `make grafana-secret`

* Grafana will be deployed using Prow, we need to generate the dashboards and push them to github manually. We can do this with `make grafana-dashboards`, that will generate the grafana dashboards and the values to be used later on the Grafana deployment. If you want to deploy Grafana from your local machine, you need to set the correct branch in [dashboards.jsonnet](./grafana-dashboards/dashboards.jsonnet), push the dashboards to your branch in github (__Only the dashboards! please don't change the branch in `dashboards.jsonnet` and don't push the file [values.json](./grafana-dashboards/output/values.json) with a branch different than master!__) and then you can run `make grafana-apply` to apply the helm chart using the dashboards in your branch.

Grafana uses jsonnet to import dashboards for [Prow](https://github.com/kubernetes/test-infra/tree/master/prow/cluster/monitoring/mixins/grafana_dashboards) and [kubernetes-mixin](https://github.com/kubernetes-monitoring/kubernetes-mixin)

Once the dashboards are generated and pushed to the repo, we use helm to deploy Grafana, this is due the cool feature added to the [grafana chart](https://github.com/helm/charts/tree/master/stable/grafana) to get dashboards directly from a URL.

### How to add new json dashboard

If you want to add a new dashboard in json:
* Add your `.json` dashboard in [./grafana-dashboards/raw](./grafana-dashboards/raw)
* Add the name of the file __without the json extension__ to the array `rawDashboards` in [dashboards.jsonnet](./grafana-dashboards/dashboards.jsonnet)
* Run `make grafana-dashboards`
* Push your changes to github and create a PR :) 