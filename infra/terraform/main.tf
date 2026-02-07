terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
    }
    null = {
      source = "hashicorp/null"
    }
    helm = {
      source  = "hashicorp/helm"
    }
  }
}

provider "kubernetes" {
  # Terraform Kubernetes provider bude číst kubeconfig
  config_path = "~/.kube/config"   # Path to your Minikube kubeconfig
  config_context = "minikube"      # Force Terraform to use the minikube context
}


provider "helm" {
  kubernetes = {
    config_path    = "~/.kube/config"
    config_context = "minikube"
  }
}

# Helm release pro Argo CD
resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
}

resource "helm_release" "nginx_ingress" {
  name       = "ingress-nginx"
  namespace  = "ingress-nginx"
  create_namespace = true
  chart      = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"

  values = [
    file("${path.module}/nginx-values.yaml")
  ]
}

# Spuštění minikube clusteru lokálně - pro Windows
resource "null_resource" "start_minikube" {
  provisioner "local-exec" {
    interpreter = ["PowerShell", "-Command"]
    command = <<EOT
if (-not (minikube status -q)) {
    Write-Host "Starting minikube..."
    minikube start
} else {
    Write-Host "Minikube already running."
}
EOT
  }
}


# Vytvoření namespace "apps"
resource "kubernetes_namespace_v1" "apps" {
  metadata {
    name = "apps"
  }

  # Závislost na spuštění minikube
  depends_on = [null_resource.start_minikube]
}
