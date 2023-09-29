{{/* vim: set filetype=mustache: */}}

{{- define "kyverno-notation-venafi.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "kyverno-notation-venafi.fullname" -}}
{{- if .Values.fullnameOverride -}}
  {{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
  {{- $name := default .Chart.Name .Values.nameOverride -}}
  {{- if contains $name .Release.Name -}}
    {{- .Release.Name | trunc 63 | trimSuffix "-" -}}
  {{- else -}}
    {{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
  {{- end -}}
{{- end -}}
{{- end -}}

{{- define "kyverno-notation-venafi.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "kyverno-notation-venafi.chartVersion" -}}
{{- .Chart.Version | replace "+" "_" -}}
{{- end -}}

{{- define "kyverno-notation-venafi.namespace" -}}
{{ default .Release.Namespace .Values.namespaceOverride }}
{{- end -}}

{{- define "kyverno-notation-venafi.clusterRoleName" -}}
{{ include "kyverno-notation-venafi.fullname" . }}-clusterrole
{{- end -}}

{{- define "kyverno-notation-venafi.roleName" -}}
{{ include "kyverno-notation-venafi.fullname" . }}-role
{{- end -}}

{{- define "kyverno-notation-venafi.serviceAccountName" -}}
{{ default (include "kyverno-notation-venafi.name" .) .Values.serviceAccount.name }}
{{- end -}}

{{- define "kyverno-notation-venafi.serviceName" -}}
{{- printf "%s-svc" (include "kyverno-notation-venafi.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
