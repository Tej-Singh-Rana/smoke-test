#!/bin/bash

# Add repositories
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add stable https://charts.helm.sh/stable
helm repo add elastic https://helm.elastic.co
helm repo add datadog https://helm.datadoghq.com
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo add jetstack https://charts.jetstack.io
helm repo add apache https://charts.apache.org
helm repo add cetic https://cetic.github.io/helm-charts
helm repo add cockroachdb https://charts.cockroachdb.com
helm repo add cloudfoundry https://charts.cloudfoundry.org
helm repo add coredns https://coredns.github.io/helm
helm repo add digitalocean https://charts.digitalocean.com
helm repo add elasticsearch https://helm.elastic.co
helm repo add mongodb https://repo.mongodb.org/helm/charts
helm repo add harbor https://helm.goharbor.io
helm repo add kyverno https://kyverno.github.io/kyverno/
helm repo add linkerd https://helm.linkerd.io/stable
helm repo add microk8s https://microk8s.io/helm-charts
helm repo add minio https://charts.min.io
helm repo add nginxfabric https://nginxinc.github.io/helm-charts
helm repo add openebs https://openebs.github.io/charts
helm repo add opa https://open-policy-agent.github.io/gatekeeper/charts
helm repo add portainer https://portainer.github.io/k8s/helm/stable
helm repo add rancher https://releases.rancher.com/server-charts/stable
helm repo add traefik https://helm.traefik.io/traefik
helm repo add bitnami-repo https://charts.bitnami.com
helm repo add akri https://aka.ms/akri-helm
helm repo add kafka https://charts.bitnami.com/bitnami
helm repo add kong https://charts.konghq.com
helm repo add mediawiki https://mediawiki.org/w/index.php?title=Extension:Helm
helm repo add external-dns https://charts.bitnami.com/bitnami
helm repo add prometheus https://prometheus-community.github.io/helm-charts

# Update Helm repositories
helm repo update

# Charts to install
charts=(
  "bitnami/nginx"
  "bitnami/mariadb"
  "bitnami/redis"
  "stable/mysql"
  "stable/postgresql"
  "elastic/elasticsearch"
  "datadog/datadog"
  "ingress-nginx/ingress-nginx"
  "prometheus-community/prometheus"
  "grafana/grafana"
  "hashicorp/vault"
  "jetstack/cert-manager"
  "apache/httpd"
  "cetic/prometheus"
  "cockroachdb/cockroachdb"
  "cloudfoundry/logsearch"
  "coredns/coredns"
  "digitalocean/do-kubernetes"
  "fairwinds/polaris"
  "mongodb/mongodb"
  "kyverno/kyverno"
  "linkerd/linkerd2"
  "microk8s/microk8s"
  "minio/minio"
  "nginxfabric/nginx-ingress"
  "openebs/openebs"
  "opa/gatekeeper"
  "portainer/portainer"
  "rancher/rancher"
  "traefik/traefik"
  "vmware/helm-charts"
  "waldo/waldo"
  "jetbrains/helm-charts"
  "akri/aks-virtual-kubelet"
  "azure/azure-cli"
  "bitnami/kafka"
  "kong/kong"
)

# Loop through each chart to install
for chart in "${charts[@]}"; do
  release_name="${chart##*/}-release"  # Generate release name from chart name
  helm install $release_name $chart
done
