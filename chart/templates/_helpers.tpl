{{- /* Converts the string in . to a legal Kubernetes resource name */ -}}
{{- define "resourceName" -}}
  {{- regexReplaceAll "\\W+" . "-" | trimPrefix "-" | trunc 63 | trimSuffix "-" | kebabcase -}}
{{- end -}}

{{- /* Common labels for all objects */ -}}
{{- define "commonLabels" -}}
app.kubernetes.io/name: {{ include "resourceName" .Values.package.name }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/version: {{ default .Chart.Version .Chart.AppVersion | replace "+" "_" }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
{{- end -}}

{{- /* Add exposed ports to network policy */ -}}
{{- /* Could be in destnation.port, http[].route[].destination.port.number */ -}}
{{- /* Use: include "exposedPorts" .Values.package.istio.hosts[0] */ -}}
{{- define "exposedPorts" -}}
{{- $ports := list -}}
{{- $ports = append $ports (dig "destination" "port" nil .) -}}
{{- range $rule := concat (default list .http) (default list .tls) (default list .tcp) -}}
  {{- range $route := $rule.route -}}
    {{- $ports = append $ports (dig "destination" "port" "number" nil $route) -}}
  {{- end -}}
{{- end -}}
{{- $ports = compact (uniq $ports) -}}
{{- if $ports -}}
ports:
{{- range $port := $ports }}
- port: {{ $port }}
{{- end -}}
{{- end -}}
{{- end -}}

{{- /* Returns name of istio Namespace Selector*/ -}}
{{- define "istioNamespaceSelectorIngress" -}}
{{- if .Values.bigbang.istioCore.enabled -}}
istio-gateway
{{- else -}}
istio-controlplane
{{- end -}}
{{- end -}}

{{- /* Returns name of istio Namespace Selector*/ -}}
{{- define "istioNamespaceSelectorEgress" -}}
{{- if .Values.bigbang.istioCore.enabled -}}
istio-core
{{- else -}}
istio-controlplane
{{- end -}}
{{- end -}}