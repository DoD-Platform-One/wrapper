# bigbang-wrapper

![Version: 0.0.0](https://img.shields.io/badge/Version-0.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

Adds full Big Bang integration into a package

## Upstream References

* <https://repo1.dso.mil/platform-one/big-bang/apps/wrapper>

## Learn More
* [Application Overview](docs/overview.md)
* [Other Documentation](docs/)

## Pre-Requisites

* Kubernetes Cluster deployed
* Kubernetes config installed in `~/.kube/config`
* Helm installed

Install Helm

https://helm.sh/docs/intro/install/

## Deployment

* Clone down the repository
* cd into directory
```bash
helm install bigbang-wrapper chart/
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| bigbang | object | `{"addons":{"authservice":{"enabled":false,"values":{"selector":{"key":"protect","value":"keycloak"}}}},"domain":"bigbang.dev","istio":{"enabled":false},"monitoring":{"enabled":false},"networkPolicies":{"controlPlaneCidr":"0.0.0.0/0","controlPlaneNode":null,"enabled":false},"openshift":false}` | Passdown values from Big Bang |
| package | object | `{"configMaps":{},"istio":{"hosts":[],"injection":true,"peerAuthentications":[]},"monitor":{"alerts":null,"dashboards":{},"encryptedMetrics":true,"services":[]},"name":"","namespace":{"name":null},"network":{"additionalPolicies":[],"allowControlPlaneEgress":false,"allowDnsEgress":true,"allowHttpsEgress":[],"allowIntraNamespace":true,"defaultDeny":true,"policies":true},"secrets":{},"sso":{"enabled":false},"values":{}}` | Passdown values from package |
| package.name | Required | `""` | Name of the package |
| package.namespace.name | string | Same as package.name | Name of the namespace.  Defaults to the same name as the package. |
| package.istio.injection | bool | `true` | Toggles sidecar injection into the package.  Enabling this allows [mTLS](https://en.wikipedia.org/wiki/Mutual_authentication#mTLS). |
| package.istio.peerAuthentications | list | If sidecar injection is enabled and peerAuthentication is blank, mTLS will be set to strict mode for the namespace. | Add policies to enforce traffic encryption (mTLS) through Istio sidecars.  [More info](https://istio.io/latest/docs/reference/config/security/peer_authentication/). |
| package.monitor.encryptedMetrics | bool | `true` | Toggle automatic setup of encrypted metrics via https.  Requires Istio injection.  Strict mTLS relies on this being enabled. |
| package.monitor.services | list | `[]` | Services to monitor using Prometheus.  Each service is specified as `name: "", [spec: {}](https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api.md#monitoring.coreos.com/v1.ServiceMonitorSpec)` |
| package.network.policies | bool | `true` | Toggle all policies on or off |
| package.network.defaultDeny | bool | `true` | Deny all traffic in the namespace by default |
| package.network.allowIntraNamespace | bool | `true` | Allow traffic between pods inside the namespace |
| package.network.allowControlPlaneEgress | bool | `false` | Allow egress traffic from the namespace to the Kubernetes control plane for API calls |
| package.network.allowDnsEgress | bool | `true` | Allow egress traffic from the namespace to the DNS port |
| package.network.allowHttpsEgress | list | `[]` | Allow https egress to internet from specific pods |
| package.network.additionalPolicies | list | `[]` | Custom egress/ingress policies to deploy.  [More info](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.25/#networkpolicy-v1-networking-k8s-io) |
| package.secrets | object | `{}` | Secrets that should be created prior to Helm install |
| package.configMaps | object | `{}` | ConfigMaps that should be created prior to Helm install |
| package.sso.enabled | bool | `false` | Toggle AuthService SSO for package; Chain must be setup in Authservice for this to work |
| package.values | object | `{}` | Pass through values to this package's upstream Helm chart |

## Contributing

Please see the [contributing guide](./CONTRIBUTING.md) if you are interested in contributing.
