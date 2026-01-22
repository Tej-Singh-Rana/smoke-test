#!/bin/bash
# Kubernetes CRI Debug Script using crictl
# Requires: crictl installed, Linux node, CRI runtime

set -euo pipefail

NAMESPACE="${1:-default}"  # Default namespace if not provided
LABEL_FILTER="${2:-}"       # Optional label filter, e.g., app=nginx

echo "=== CRI Debug Script for Namespace: $NAMESPACE ==="

# Function to automatically get pod IDs
get_pod_ids() {
    if [[ -z "$LABEL_FILTER" ]]; then
        crictl pods -q
    else
        crictl pods --label "$LABEL_FILTER" -q
    fi
}

# Function to get container IDs for a given pod
get_container_ids() {
    local pod_id="$1"
    crictl ps -a --pod "$pod_id" -q
}

echo
echo "=== Listing Pods ==="
crictl pods | awk 'NR==1; NR>1 {print}'

POD_IDS=$(get_pod_ids)
if [[ -z "$POD_IDS" ]]; then
    echo "No pods found in namespace '$NAMESPACE' with label '$LABEL_FILTER'. Exiting."
    exit 1
fi

echo
echo "=== Listing Images ==="
crictl images

echo
echo "=== Listing All Containers ==="
crictl ps -a

echo
echo "=== Listing Running Containers ==="
crictl ps

for pod_id in $POD_IDS; do
    echo
    echo "=== Pod ID: $pod_id ==="
    CONTAINER_IDS=$(get_container_ids "$pod_id")

    for cid in $CONTAINER_IDS; do
        echo
        echo "--- Container ID: $cid ---"

        # Container info
        crictl inspect "$cid" | jq '{id: .status.id, image: .status.imageRef, state: .status.state, pid: .status.pid}'

        # Execute a command (list root directory)
        echo "--- Executing: ls / inside container ---"
        crictl exec -i -t "$cid" ls /

        # Fetch full logs
        echo "--- Fetching full logs ---"
        crictl logs "$cid" || echo "No logs available"

        # Fetch latest 5 lines
        echo "--- Fetching last 5 log lines ---"
        crictl logs --tail=5 "$cid" || echo "No logs available"
    done
done

echo
echo "=== CRI Debug Script Completed ==="
