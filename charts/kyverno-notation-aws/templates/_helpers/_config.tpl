{{/* vim: set filetype=mustache: */}}

{{- define "kyverno-notation-venafi.config.imagePullSecret" -}}
{{- printf "{\"auths\":{\"%s\":{\"auth\":\"%s\"}}}" .registry (printf "%s:%s" .username .password | b64enc) | b64enc }}
{{- end -}}
