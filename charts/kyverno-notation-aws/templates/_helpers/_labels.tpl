{{/* vim: set filetype=mustache: */}}

{{- define "kyverno-notation-venafi.labels.merge" -}}
{{- $labels := dict -}}
{{- range . -}}
  {{- $labels = merge $labels (fromYaml .) -}}
{{- end -}}
{{- with $labels -}}
  {{- toYaml $labels -}}
{{- end -}}
{{- end -}}

{{- define "kyverno-notation-venafi.labels" -}}
{{- template "kyverno-notation-venafi.labels.merge" (list
  (include "kyverno-notation-venafi.labels.common" .)
  (include "kyverno-notation-venafi.matchLabels.common" .)
) -}}
{{- end -}}

{{- define "kyverno-notation-venafi.labels.helm" -}}
helm.sh/chart: {{ template "kyverno-notation-venafi.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "kyverno-notation-venafi.labels.version" -}}
app.kubernetes.io/version: {{ template "kyverno-notation-venafi.chartVersion" . }}
{{- end -}}

{{- define "kyverno-notation-venafi.labels.common" -}}
{{- template "kyverno-notation-venafi.labels.merge" (list
  (include "kyverno-notation-venafi.labels.helm" .)
  (include "kyverno-notation-venafi.labels.version" .)
) -}}
{{- end -}}

{{- define "kyverno-notation-venafi.matchLabels.common" -}}
app.kubernetes.io/part-of: {{ template "kyverno-notation-venafi.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
