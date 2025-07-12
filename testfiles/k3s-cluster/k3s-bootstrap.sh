#!/bin/bash

set -euo pipefail

# === Versions ===
K3S_VERSION="v1.33.0+k3s1"
K3S_AIRGAP_IMAGE_VERSION="v1.33.0+k3s1"
KUBECTL_VERSION="v1.33.0"
CNI_VERSION="v1.6.2"

# === Install k3s binary ===
echo "Downloading k3s..."
curl -L --output /usr/bin/k3s "https://github.com/k3s-io/k3s/releases/download/${K3S_VERSION}/k3s"
chmod +x /usr/bin/k3s

# === Install CNI Plugins ===
echo "Installing CNI plugins..."
curl -LsSO "https://github.com/containernetworking/plugins/releases/download/${CNI_VERSION}/cni-plugins-linux-amd64-${CNI_VERSION}.tgz"
mkdir -pv /opt/cni/bin
tar -xzf "cni-plugins-linux-amd64-${CNI_VERSION}.tgz" -C /opt/cni/bin
mkdir -p /etc/cni/net.d
rm -f "cni-plugins-linux-amd64-${CNI_VERSION}.tgz"

# === Download air-gapped k3s images ===
echo "Downloading air-gapped k3s image archive..."
mkdir -p /var/lib/rancher/k3s/agent/images/
cd /var/lib/rancher/k3s/agent/images/
curl -LSO "https://github.com/k3s-io/k3s/releases/download/${K3S_AIRGAP_IMAGE_VERSION}/k3s-airgap-images-amd64.tar"

# === Install kubectl ===
echo "Installing kubectl..."
curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
mv kubectl /usr/bin/
chmod +x /usr/bin/kubectl

# === Bash Aliases & Completion ===
echo "Setting up kubectl aliases and completion..."
{
  echo 'alias kubectl="k3s kubectl"'
  echo 'alias k=kubectl'
  echo 'complete -F __start_kubectl k'
  echo 'source <(kubectl completion bash)'
  echo 'source /etc/profile.d/bash_completion.sh'
  echo "alias crictl='k3s crictl'" 
} >> /root/.bashrc

{
  echo 'alias kubectl="k3s kubectl"'
} >> /root/.bash_profile

{
  echo 'alias kubectl="k3s kubectl"'
} >> /etc/profile

mkdir -p /etc/bash_completion.d

# === Create crictl config ===
echo "Writing /etc/crictl.yaml..."
cat > /etc/crictl.yaml <<EOF
runtime-endpoint: unix:///var/run/containerd/containerd.sock
image-endpoint: unix:///var/run/containerd/containerd.sock
timeout: 10
EOF

# === Start containerd ===
start_containerd() {
  local log_file="/var/log/containerd.log"
  echo "Starting containerd..."
  /usr/bin/containerd > "$log_file" 2>&1 &
  local pid=$!
  sleep 2
  if ps -p "$pid" > /dev/null; then
    echo "containerd started successfully with PID $pid"
  else
    echo "❌ Failed to start containerd. Check $log_file for details."
    exit 1
  fi
}

start_containerd

# === Start k3s server ===
CONTROLPLANE_HOST=$(hostname)
advertise_address=$(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

echo "Starting k3s server..."
/usr/bin/k3s server \
  --advertise-address "$advertise_address" \
  --tls-san "$CONTROLPLANE_HOST" \
  --container-runtime-endpoint unix:///run/containerd/containerd.sock \
  > /tmp/k3s-server.log 2>&1 &

echo "✅ k3s installation complete. Logs: /tmp/k3s-server.log"
