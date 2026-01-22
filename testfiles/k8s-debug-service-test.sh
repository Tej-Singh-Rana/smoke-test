#!/bin/bash

set -e

NAMESPACE=default
APP_NAME=hostnames
LABEL="app=hostnames"
SERVICE_PORT=80
POD_PORT=9376

echo "=== Creating Deployment ==="
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ${APP_NAME}
  namespace: ${NAMESPACE}
  labels:
    app: ${APP_NAME}
spec:
  replicas: 3
  selector:
    matchLabels:
      app: ${APP_NAME}
  template:
    metadata:
      labels:
        app: ${APP_NAME}
    spec:
      containers:
      - name: ${APP_NAME}
        image: registry.k8s.io/serve_hostname
        ports:
        - containerPort: ${POD_PORT}
EOF

echo
echo "=== Creating Service ==="
kubectl apply -f - <<EOF
apiVersion: v1
kind: Service
metadata:
  name: ${APP_NAME}
  namespace: ${NAMESPACE}
  labels:
    app: ${APP_NAME}
spec:
  type: ClusterIP
  selector:
    app: ${APP_NAME}
  ports:
  - name: http
    protocol: TCP
    port: ${SERVICE_PORT}
    targetPort: ${POD_PORT}
EOF

echo
echo "=== Waiting for Pods to be Ready ==="
kubectl rollout status deployment/${APP_NAME} -n ${NAMESPACE}

echo
echo "=== Pods ==="
kubectl get pods -n ${NAMESPACE} -l ${LABEL}

echo
echo "=== Service ==="
kubectl get svc ${APP_NAME} -n ${NAMESPACE}

SERVICE_IP=$(kubectl get svc ${APP_NAME} -n ${NAMESPACE} -o jsonpath='{.spec.clusterIP}')
echo "Service IP: ${SERVICE_IP}"

echo
echo "=== EndpointSlices ==="
kubectl get endpointslices -n ${NAMESPACE} -l k8s.io/service-name=${APP_NAME}

POD_IPS=$(kubectl get pods -n ${NAMESPACE} -l ${LABEL} -o jsonpath='{range .items[*]}{.status.podIP}{" "}{end}')

echo
echo "=== Running Tests from BusyBox Pod ==="
kubectl run -it --rm svc-debug \
  --namespace ${NAMESPACE} \
  --restart=Never \
  --image=busybox \
  -- sh -c "
    echo '--- DNS Tests ---';
    nslookup ${APP_NAME};
    nslookup ${APP_NAME}.${NAMESPACE}.svc.cluster.local;

    echo '--- Service Test (DNS) ---';
    wget -qO- ${APP_NAME}:${SERVICE_PORT};

    echo '--- Service Test (ClusterIP) ---';
    for i in 1 2 3; do
      wget -qO- ${SERVICE_IP}:${SERVICE_PORT};
    done;

    echo '--- Pod Direct Tests ---';
    for ip in ${POD_IPS}; do
      wget -qO- \$ip:${POD_PORT};
    done;
  "

echo
echo "=== All checks completed successfully ==="
