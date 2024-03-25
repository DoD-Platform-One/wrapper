# How to upgrade the Wrapper Package chart

This is a custom package, there is no upstream to upgrade from. This document will contain notes and examples to help use/understand how to use the wrapper.

## What is it?

The wrapper is a helm chart to add standard BB resources to custom charts, e.g. network policies, monitoring, istio resources, etc. It is sourced in the values file in BB at `.Values.wrapper`, this is where you can point it at a custom branch or other changes to the wrapper itself. It is used for all instances under `.Values.packages` in the values file in BB. This is where users can add/track custom charts that they want "wrapped".

## Why is it?

BB provides a platform for software, but realistically end users want to run their software, not just a platform. This wrapper is the standard solution to incorporate any software the end user wants to run into the BB platform with minimal customizations to get it to work.

## Gotchas

It's relatively difficult to deploy/test outside of using BB. Use `helm template chart` to test syntax and lint, then just commit push and test with BB with an override as shown here:

```yaml
wrapper:
  git:
    repo: "https://repo1.dso.mil/big-bang/product/packages/wrapper.git"
    path: "chart"
    tag: null
    branch: "my-test-branch"
```

Don't forget to add network and authorization policies if you need other packages to be able to reach your custom software.

### Kyverno Policies

You may need to add exclusions to kyverno policies for your packages. You'll know if you get Kyverno `events` that reference your resources. Here is an example to allow automounting of service tokens.

```yaml
kyvernoPolicies:
  values:
    policies:
      disallow-auto-mount-service-account-token:
        exclude:
          any:
            # allows my-app to mount service account tokens
            - resources:
                namespaces:
                - my-app
                kinds:
                - Pod
                names:
                - my-app-*
```

Here is a script that you can use to find kyverno issues.

```bash
app_name="my-app"
namespace="$app_name"
event_reason="Policy"
irrelevant_action="Resource Passed"
kubectl get event -A -o json | jq '[.items[] | select( (.reason | contains("'$event_reason'")) and ( (.message | contains("'$app_name'")) or (.related != null and (.related.namespace != null and (.related.namespace | contains("'$namespace'"))) or (.related.name != null and (.related.name | contains("'$app_name'"))) ) ) and (.action != "'$irrelevant_action'") )]'
```

## Examples

Here are some examples of good, bad and otherwise.

Find more at [`/docs/examples/`](/docs/examples/)

### Basic wrapper

```yaml
monitoring:
  enabled: true

packages:
  podinfo:
    enabled: true
    sourceType: "git"
    git:
      repo: https://repo1.dso.mil/big-bang/apps/sandbox/podinfo.git
      path: chart
      # tag: null
      # tag: 6.3.4
      # branch: main
      # existingSecret: ""
      # credentials:
      #   password: ""
      #   username: ""
    flux:
      timeout: 5m
    postRenderers: []
    dependsOn:
      - name: monitoring
        namespace: bigbang
    values:
      replicaCount: 3
```

### Wrapper with multiple endpoints, authorization policies, and network policies

```yaml
# this will often have to be set to audit if the end chart doesn't meet kyverno settings
# we should document how to set those to audit for the specific packages we want to only audit
kyvernoPolicies:
  values:
    validationFailureAction: "audit"

istio:
  enabled: true

wrapper:
  git:
    repo: "https://repo1.dso.mil/big-bang/product/packages/wrapper.git"
    path: "chart"
    # tag: null
    # branch: "my-test-branch"

packages:
  podinfo:
    enabled: true
    sourceType: "git"
    git:
      repo: https://github.com/stefanprodan/podinfo.git
      path: charts/podinfo
      # tag: null
      # tag: 6.3.4
      # branch: main
      # existingSecret: ""
      # credentials:
      #   password: ""
      #   username: ""
    flux:
      timeout: 5m
    postRenderers: []
    # dependsOn:
    #   - name: monitoring
    #     namespace: bigbang
    wrapper:
      enabled: true
    values:
      replicaCount: 3
    istio:
      injection: "enabled"
      hardened:
        enabled: true
        matchLabels:
          app.kubernetes.io/name: podinfo
        customAuthorizationPolicies:
          - name: "allow-nothing-1"
            enabled: true
            spec: {}
          - name: "allow-nothing-2"
            enabled: true
            spec: {}
      hosts:
        - names:
            - "podinfo"
          gateways:
            - "public"
          destination:
            port: 9898
        - names:
            - test-too
          domain: dev.test
          gateways:
            - public
          destination:
            port: 9898
    network:
      additionalPolicies:
        - name: policy-1
          spec:
            podSelector:
              matchLabels:
                role: db
            policyTypes:
              - Ingress
              - Egress
            ingress:
              - from:
                  - ipBlock:
                      cidr: 172.17.0.0/16
                      except:
                        - 172.17.1.0/24
                  - namespaceSelector:
                      matchLabels:
                        project: myproject
                  - podSelector:
                      matchLabels:
                        role: frontend
                ports:
                  - protocol: TCP
                    port: 6379
        - name: policy-2
          spec:
            podSelector:
              matchLabels:
                role: frontend
            policyTypes:
              - Ingress
              - Egress
            ingress:
              - from:
                  - ipBlock:
                      cidr: 172.19.0.0/16
                      except:
                        - 172.19.1.0/24
                  - namespaceSelector:
                      matchLabels:
                        project: myproject
                  - podSelector:
                      matchLabels:
                        role: frontend
                ports:
                  - protocol: TCP
                    port: 9300
```

### Deploying an addon normally both good and bad, an addon as a wrapped package, and both a good and bad wrapped custom applications

```yaml
monitoring:
  enabled: true

addons:
  # addon bad
  argocd:
    enabled: true
    sourceType: "git"
    git:
      repo: "https://repo1.dso.mil/big-bang/product/packages/argocd.git"
      path: "chart"
      credentials:
        password: "bad pass"
        username: "andrewshoell"
  # addon good
  fortify:
    enabled: true
    sourceType: "git"
    git:
      repo: "https://repo1.dso.mil/big-bang/product/packages/fortify.git"
      path: "chart"
      credentials:
        password: ""
        username: ""

packages:
  # custom good
  podinfoGood:
    enabled: true
    sourceType: "git"
    git:
      repo: https://repo1.dso.mil/big-bang/apps/sandbox/podinfo.git
      path: chart
      credentials:
        password: ""
        username: ""
    flux:
      timeout: 5m
    postRenderers: []
    dependsOn:
      - name: monitoring
        namespace: bigbang
    values:
      replicaCount: 3
  # custom bad
  podinfoBad:
    enabled: true
    sourceType: "git"
    git:
      repo: https://repo1.dso.mil/big-bang/apps/sandbox/podinfo.git
      path: chart
      credentials:
        password: "bad pass"
        username: "andrewshoell"
    flux:
      timeout: 5m
    postRenderers: []
    dependsOn:
      - name: monitoring
        namespace: bigbang
    values:
      replicaCount: 3
  # addon as wrapped package
  fortifyGood:
    enabled: true
    sourceType: "git"
    git:
      repo: "https://repo1.dso.mil/big-bang/product/packages/fortify.git"
      path: "chart"
      branch: "main"
      credentials:
        password: ""
        username: ""
```
