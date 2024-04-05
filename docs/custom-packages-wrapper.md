# Custom Helm Chart Deployment and the "Package Wrapper"

Big Bang provides "a declarative, continuous delivery tool for deploying DoD hardened and approved packages into a Kubernetes cluster." That's great for providing out of the box security and providing a quicker CtF/cATO ([Certificate to Field](https://p1.dso.mil/services/cybersecurity/ctf)/[Continuous Authority to Operate](https://p1.dso.mil/services/cybersecurity/cato)); however, it wouldn't do much for most users until it allows you to deploy your own software as well, enter the "package wrapper."

## What is the Package Wrapper?

[The package wrapper](https://repo1.dso.mil/big-bang/product/packages/wrapper) is a Big Bang maintained, open source project that provides a helm chart that "wraps" any given helm chart, identified by the given values, in predefined, but customizable resources that facilitate easier integration into the Big Bang ecosystem. To understand how this works requires understanding of how Big Bang uses Flux to manage packages. Understanding how to use it in 90% of cases requires far less.

1. `.Values.wrapper` is where the wrapper itself is defined, useful for pinning a wrapper version.
1. `.Values.packages.*` is where packages that should be deployed using the wrapper are defined.
1. `.Values.packages.*.values` is where values can be passed to the wrapped packages.

Here are some override values for Big Bang that will deploy podinfo after the monitoring package finishes:

```yaml
monitoring:
  enabled: true

packages:
  podinfo:
    enabled: true
    wrapper:
      enabled: true
    sourceType: "git"
    git:
      repo: https://repo1.dso.mil/big-bang/apps/sandbox/podinfo.git
      path: chart
      tag: null # set tag to null if pointing at a branch
      # tag: 6.3.4 # set tag to pin version
      branch: main # set branch for testing improvements
      # existingSecret: "" # use if the k8s secret is being managed somewhere else
      # credentials: # use to manage a new secret for git authentication
      #   password: "" # pass git password in using github.com/getsops/sops or some other secure tool
      #   username: "" # pass git username in
    flux:
      timeout: 5m
    postRenderers: []
    dependsOn:
      - name: monitoring
        namespace: bigbang
    values:
      replicaCount: 3
```

## How does the `.Values.packages` map work?

Every key of `.Values.packages` represents a custom helm chart that should be wrapped, deployed, and managed by Big Bang. Those keys point to structured maps that configure how to wrap, deploy, and manage that helm chart. You can find the package map structure [here](https://docs-bigbang.dso.mil/latest/values/#packages).

As previously mentioned, one of the most important keys in the package map is [`.Values.packages.*.values`](https://docs-bigbang.dso.mil/latest/values/#packagessamplevalues). This in an unstructured map that will get passed to the custom chart as overrides.

## What does the wrapper do?

To facilitate integration into a hardened Big Bang cluster, the wrapper deploys several resources and enables deploying even more. The most important default configuration includes networking resources like [Istio Virtual Services](https://istio.io/latest/docs/reference/config/networking/virtual-service/), [Istio Authorization Policies](https://istio.io/latest/docs/reference/config/security/authorization-policy/), [Network Policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/), [Enabling Sticky Sessions](https://istio.io/latest/docs/reference/config/networking/destination-rule/#LoadBalancerSettings), [Istio Peer Authentications](https://istio.io/latest/docs/reference/config/security/peer_authentication/), etc. Having default configurations for these enables consumers to get the strength and hardening of Big Bang packages with minimal effort, particularly if the target package is a web app. Consider this minimal configuration for [podinfo](https://repo1.dso.mil/big-bang/apps/sandbox/podinfo.git). This deploys a hardened, scaled, webserver at a pinned version with Istio integration with 13 lines of yaml.

_NOTE: `packages.*.wrapper.enabled` needs to be set to `true` to get any wrapper resources._

```yaml
packages:
  podinfo:
    enabled: true
    wrapper:
      enabled: true
    git:
      repo: https://repo1.dso.mil/big-bang/apps/sandbox/podinfo.git
      tag: "6.0.0-bb.9"
      credentials:
        password: "overriden with sops file"
        username: "bbuser"
    values:
      replicaCount: 3
```

### Can it do more?

At the time of writing, the wrapper also supports deploying secrets, config maps, and monitoring/alerting/dashboard integration. There is also a way to integrate [authservice sso](https://repo1.dso.mil/big-bang/product/packages/authservice/-/blob/main/chart/values.yaml?ref_type=heads#L134), enabling OIDC/SAML authentication for the package. In addition to everything currently supported, as we add more to Big Bang we attempt to keep support for those features in wrapper at parity. New features, issues, and help requests can be submitted through the wrapper's [gitlab issues](https://repo1.dso.mil/big-bang/product/packages/wrapper/-/issues/new).

## Where can I learn more?

- [BB Docs](https://docs-bigbang.dso.mil/latest/docs/guides/deployment-scenarios/extra-package-deployment/)
- [Wrapper Docs](https://repo1.dso.mil/big-bang/product/packages/wrapper/-/blob/main/docs/DEVELOPMENT_MAINTENANCE.md)
- [Wrapper Examples](https://repo1.dso.mil/big-bang/product/packages/wrapper/-/tree/main/docs/examples)
