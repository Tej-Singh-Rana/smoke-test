#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Update apt and install prerequisite package
apt-get update
apt-get install -y software-properties-common

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

# Verify the key fingerprint
apt-key fingerprint 0EBFCD88

# Add Docker's stable repository
add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable"

# Update the package list again after adding repo
apt-get update

# Install netcat and specific version of containerd.io
apt-get install -y netcat containerd.io=1.6.6-1

sed -i '/^\s*disabled_plugins\s*=\s*\[.*"cri".*\]/d' /etc/containerd/config.toml

systemctl enable --now containerd

# Define your Kubernetes version here (example: 1.28.5-1.1)
k8s_version="1.33.0-1.1"

# Create keyrings directory for Kubernetes
sudo mkdir -m 755 -p /etc/apt/keyrings

# Download and store the Kubernetes GPG key
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.33/deb/Release.key | \
    sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Add Kubernetes apt repository
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.33/deb/ /" | \
    sudo tee /etc/apt/sources.list.d/kubernetes.list

# Update package list
sudo apt-get update

# Install kubelet, kubeadm, and kubectl with specified version
sudo apt-get install --no-install-recommends -y \
    kubelet=$k8s_version \
    kubectl=$k8s_version \
    kubeadm=$k8s_version

# Hold packages to prevent unintended upgrades
sudo apt-mark hold kubelet kubeadm kubectl containerd.io

# Disable crictl CLI warnings
cat > /etc/crictl.yaml <<EOF
runtime-endpoint: unix:///var/run/containerd/containerd.sock
image-endpoint: unix:///var/run/containerd/containerd.sock
timeout: 10
EOF

# Enable bash completion for kubectl and add alias for root user
mkdir -p /etc/bash_completion.d

# Add completions and alias to /root/.bashrc
{
  echo "source /etc/profile.d/bash_completion.sh"
  echo "source <(kubectl completion bash)"
  echo "alias k=kubectl"
  echo "complete -F __start_kubectl k"
} >> /root/.bashrc

# Add completions and alias to /root/.bash_profile
{
  echo "source /etc/profile.d/bash_completion.sh"
  echo "source <(kubectl completion bash)"
  echo "alias k=kubectl"
  echo "complete -F __start_kubectl k"
} >> /root/.bash_profile

# Setup the IP address
IP_ADDR=$(ip addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
echo $IP_ADDR

# Bootstrap
kubeadm init --apiserver-cert-extra-sans=node01 --apiserver-advertise-address $IP_ADDR --pod-network-cidr=172.17.0.0/16 --service-cidr=172.20.0.0/16

echo "#######################"
echo "To print the token to join the worker node: kubeadm token create --print-join-command"
echo "#######################"

# To start using your cluster, you need to run the following as a regular user:
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f https://raw.githubusercontent.com/Tej-Singh-Rana/k8s-test/refs/heads/master/custom-kube-flannel.yaml
