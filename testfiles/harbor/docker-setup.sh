#!/bin/bash
# Update system and install dependencies
echo "Updating system and installing dependencies..."
sudo apt-get update -y
sudo apt-get install -y curl apt-transport-https ca-certificates software-properties-common lsb-release

# Install OpenSSL (latest version)
echo "Installing OpenSSL..."
sudo apt-get install -y openssl

# docker installation doc link
# https://docs.docker.com/engine/install/debian/
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
# containerd.io=1.7.25-1
sudo apt-get install -y docker-ce=5:27.5.0-1~debian.12~bookworm docker-ce-cli=5:27.5.0-1~debian.12~bookworm docker-buildx-plugin=0.20.0-1~debian.12~bookworm docker-compose-plugin=2.32.1-1~debian.12~bookworm

# Harbor release github link 
# https://github.com/goharbor/harbor/releases
# Download and extract Harbor offline installer
wget https://github.com/goharbor/harbor/releases/download/v2.12.2/harbor-offline-installer-v2.12.2.tgz
tar xvzf harbor-offline-installer-v2.12.2.tgz

# Generate the Root CA certificate and private key
openssl genrsa -out ca.key 4096
openssl req -x509 -new -nodes -sha512 -days 3650 \
 -subj "/C=CN/ST=India/L=India/O=kodekloud/OU=Personal/CN=MyPersonal Root CA" \
 -key ca.key \
 -out ca.crt

# Generate the private key for kodekloud.com
openssl genrsa -out kodekloud.com.key 4096

# Create a certificate signing request (CSR) for kodekloud.com
openssl req -sha512 -new \
    -subj "/C=CN/ST=India/L=India/O=kodekloud/OU=Personal/CN=kodekloud.com" \
    -key kodekloud.com.key \
    -out kodekloud.com.csr

# Create a config file for certificate extensions
cat > v3.ext <<-EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
#DNS.1=
#DNS.2=
#DNS.3=
#IP.1=      # Add the IP address as a SAN
EOF

# Sign the CSR with the Root CA certificate to create the server certificate
openssl x509 -req -sha512 -days 3650 \
    -extfile v3.ext \
    -CA ca.crt -CAkey ca.key -CAcreateserial \
    -in kodekloud.com.csr \
    -out kodekloud.com.crt

# Copy the certificate and key to the /data/cert/ directory
mkdir -p /data/cert
cp -v kodekloud.com.crt /data/cert/
cp -v kodekloud.com.key /data/cert/

# Convert the certificate to PEM format
openssl x509 -inform PEM -in kodekloud.com.crt -out kodekloud.com.cert

# Create a directory for Docker to store the certificates
mkdir -p /etc/docker/certs.d/kodekloud.com/

# Copy the certificate files to the Docker certificate directory
cp -v kodekloud.com.cert /etc/docker/certs.d/kodekloud.com/
cp -v kodekloud.com.key /etc/docker/certs.d/kodekloud.com/
cp -v ca.crt /etc/docker/certs.d/kodekloud.com/

# Copy the CA certificate to the system's trusted CA directory
cp -v ca.crt /usr/local/share/ca-certificates/

# Update the system's CA certificates
sudo update-ca-certificates

echo "Use the custom harbor.yml file. Run the prepare script -> install.sh or docker compose up -d"
echo "Update the mapping port in the docker-compose.yml file"
echo "sed -i 's/8080/8085/g' /root/harbor/docker-compose.yml"
