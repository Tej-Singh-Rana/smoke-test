#!/bin/bash

# Download and extract Harbor offline installer
wget https://github.com/goharbor/harbor/releases/download/v2.12.2/harbor-offline-installer-v2.12.2.tgz
tar xvzf harbor-offline-installer-v2.12.2.tgz

# Update apt repositories and install Docker
apt update
apt install -y docker-ce

# Enable and start Docker service
systemctl enable --now docker 

# Generate the Root CA certificate and private key
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
DNS.1=kodekloud.com
DNS.2=kodekloud
DNS.3=controlplane
EOF

# Sign the CSR with the Root CA certificate to create the server certificate
openssl x509 -req -sha512 -days 3650 \
    -extfile v3.ext \
    -CA ca.crt -CAkey ca.key -CAcreateserial \
    -in kodekloud.com.csr \
    -out kodekloud.com.crt

# Copy the certificate and key to the /data/cert/ directory
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
cp ca.crt /usr/local/share/ca-certificates/

# Update the system's CA certificates
sudo update-ca-certificates

echo "Update the mapping port in the docker-compose.yml file"
echo "Run the prepare script -> install.sh or docker compose up -d"

