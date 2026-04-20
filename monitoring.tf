# Prometheus & Grafana Monitoring Stack via Helm
#
# Uncomment to deploy kube-prometheus-stack which includes:
# - Prometheus for metrics collection
# - Grafana for dashboards
# - AlertManager for alerting
# - Node Exporter, kube-state-metrics

# resource "helm_release" "prometheus_stack" {
#   name             = "kube-prometheus-stack"
#   repository       = "https://prometheus-community.github.io/helm-charts"
#   chart            = "kube-prometheus-stack"
#   version          = "58.2.1"
#   namespace        = "monitoring"
#   create_namespace = true
#
#   values = [<<-YAML
#     grafana:
#       adminPassword: "changeme"
#       ingress:
#         enabled: true
#         ingressClassName: alb
#         annotations:
#           alb.ingress.kubernetes.io/scheme: internal
#         hosts:
#           - grafana.internal
#
#     prometheus:
#       prometheusSpec:
#         retention: 15d
#         storageSpec:
#           volumeClaimTemplate:
#             spec:
#               storageClassName: gp3
#               resources:
#                 requests:
#                   storage: 50Gi
#
#     alertmanager:
#       alertmanagerSpec:
#         storage:
#           volumeClaimTemplate:
#             spec:
#               storageClassName: gp3
#               resources:
#                 requests:
#                   storage: 10Gi
#   YAML
#   ]
# }
