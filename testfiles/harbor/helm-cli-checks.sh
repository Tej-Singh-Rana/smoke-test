#!/bin/bash

# helm version installed on the lab
helm version

# helm env
helm env	

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
helm repo add cetic https://cetic.github.io/helm-charts
helm repo add cockroachdb https://charts.cockroachdb.com
helm repo add coredns https://coredns.github.io/helm
helm repo add elasticsearch https://helm.elastic.co
helm repo add harbor https://helm.goharbor.io
helm repo add kyverno https://kyverno.github.io/kyverno/
helm repo add linkerd https://helm.linkerd.io/stable
helm repo add minio https://charts.min.io
helm repo add opa https://open-policy-agent.github.io/gatekeeper/charts
helm repo add portainer https://portainer.github.io/k8s/helm/stable
helm repo add rancher https://releases.rancher.com/server-charts/stable
helm repo add traefik https://helm.traefik.io/traefik
helm repo add kafka https://charts.bitnami.com/bitnami
helm repo add kong https://charts.konghq.com
helm repo add external-dns https://charts.bitnami.com/bitnami
helm repo add prometheus https://prometheus-community.github.io/helm-charts

# Update Helm repositories
helm repo update

# Charts to install
charts=(
  "bitnami/nginx"
  "bitnami/mariadb"
  "bitnami/redis"
  "bitnami/tomcat"
  "bitnami/apache"
  "bitnami/rabbitmq"
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

# Course labs
echo "######################################################################"
echo "Course Labs checks"
echo "######################################################################"

# Helm search
helm search repo bitnami

# Install webapp-color-apd chart (helm install, helm lint)
git clone https://github.com/kodekloudhub/certified-kubernetes-application-developer-course.git /tmp/certified-kubernetes-application-developer-course
mv /tmp/certified-kubernetes-application-developer-course/resources/webapp-color-apd/ /opt/
awk '{gsub("apiVersion: v1","apiVersion: apps/v1")}1' /opt/webapp-color-apd/templates/deployment.yaml > tmpfile && mv tmpfile /opt/webapp-color-apd/templates/deployment.yaml
awk '{gsub(".Values.service.Name",".Values.service.name")}1' /opt/webapp-color-apd/templates/service.yaml > tmpfile && mv tmpfile /opt/webapp-color-apd/templates/service.yaml
sed -i '/type: ClusterIP/s/ClusterIP/NodePort/' /opt/webapp-color-apd/values.yaml && sed -i '/type: NodePort/a \ \ nodePort: 30090' /opt/webapp-color-apd/values.yaml
sed -i '/replicaCount: 0/s/0/2/' /opt/webapp-color-apd/values.yaml
kubectl create ns frontend-apd
helm lint /opt/webapp-color-apd
helm install webapp-color-apd /opt/webapp-color-apd --namespace frontend-apd

# Install different charts
helm install --generate-name /tmp/certified-kubernetes-application-developer-course/resources/new-version/
helm install --generate-name /tmp/certified-kubernetes-application-developer-course/resources/old-version/
helm install --generate-name /tmp/certified-kubernetes-application-developer-course/resources/security-alpha-apd/
helm install --generate-name /tmp/certified-kubernetes-application-developer-course/resources/web-dashboard-apd/
helm install --generate-name /tmp/certified-kubernetes-application-developer-course/resources/digi-locker-apd/

# List installed helm charts from all the namespaces
helm list -A

# Perform add repo, install and upgrade charts
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
helm repo ls
kubectl get ns cd-tool-apd >/dev/null 2>&1 || kubectl create ns cd-tool-apd
helm install --generate-name kubernetes-dashboard/kubernetes-dashboard --namespace cd-tool-apd
helm search repo kubernetes-dashboard -l
helm list -n cd-tool-apd

# Perform install, repo update and upgrade version 
helm repo add lvm-crystal-apd https://charts.bitnami.com/bitnami
helm install lvm-crystal-apd lvm-crystal-apd/nginx --version=13.2.8 --namespace=crystal-apd-ns
helm repo update lvm-crystal-apd -n crystal-apd-ns
helm upgrade lvm-crystal-apd lvm-crystal-apd/nginx -n crystal-apd-ns --version=13.2.12 --set replicaCount=2
helm status lvm-crystal-apd

# Polar chart
helm repo add polar https://charts.bitnami.com/bitnami
kubectl get ns cd-tool-apd >/dev/null 2>&1 || kubectl create ns cd-tool-apd
helm install nginx-server polar/nginx --namespace cd-tool-apd
helm list -n cd-tool-apd

# Install trivy deployments under "testing-apd" ns.
kubectl create ns testing-apd
helm repo add aquasecurity https://aquasecurity.github.io/helm-charts/
helm install --namespace=testing-apd image-scanner aquasecurity/trivy

helm uninstall atlanta-page-apd -n atlanta-page-04 >/dev/null 2>&1
helm list -n atlanta-page-04

# Install chart in ckad10-finance-ns namespace and perform repo update, upgrade, history and rollback command. 
kubectl create ns ckad10-finance-ns
helm install bitnami bitnami/nginx --version=13.2.8 --namespace=ckad10-finance-ns
helm repo update --debug
helm repo update --debug bitnami -n ckad10-finance-ns
helm upgrade bitnami bitnami/nginx -n ckad10-finance-ns --version=17.0.0 --set replicaCount=2
helm repo update bitnami -n ckad10-finance-ns
helm upgrade bitnami bitnami/nginx -n ckad10-finance-ns --version=18.3.0 --set replicaCount=3
helm history bitnami -n ckad10-finance-ns
helm rollback bitnami -n ckad10-finance-ns

# Perform install and uninstall
helm install bravo bitnami/drupal
helm uninstall bravo

# Pulling and extracting under the /root/
helm pull bitnami/apache --untar
helm install --generate-name apache/

# Pulling under the /opt directory
helm pull bitnami/apache --version 11.3.2 --untar --destination /opt/
ls -l /opt/

# Setup lvm-crystal-apd 
helm repo add lvm-crystal-apd https://charts.bitnami.com/bitnami
kubectl create ns crystal-apd-ns
helm install lvm-crystal-apd lvm-crystal-apd/nginx --version=13.2.8 --namespace=crystal-apd-ns

# After updating the helm chart, upgrade the helm chart version to above 13.2.9
# Upgrade the helm chart to above `13.2.9` and also, increase the replica count of the deployment to `2` from the command line.
helm upgrade lvm-crystal-apd lvm-crystal-apd/nginx -n crystal-apd-ns --version=13.2.12 --set replicaCount=2
helm repo update lvm-crystal-apd -n crystal-apd-ns
helm upgrade lvm-crystal-apd lvm-crystal-apd/nginx -n crystal-apd-ns --version=18.1.15 --set replicaCount=2

# Analysis "helm show" command
helm show readme bitnami/nginx
helm show chart bitnami/nginx  | head -n10
helm show all bitnami/nginx   | head -n10
helm show crds bitnami/tomcat  | head -n10
helm show crds bitnami/webapp  | head -n10

# Search operation
helm search hub kubernetes-dashboard
helm package /opt/webapp-color-apd/
ls -l /root/



