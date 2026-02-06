output "namespace" {
  value = kubernetes_namespace_v1.apps.metadata[0].name
}

output "minikube_status" {
  value = "Cluster should be running. Check with 'minikube status'"
}
