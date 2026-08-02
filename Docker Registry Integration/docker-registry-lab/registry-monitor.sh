#!/bin/bash

echo "Registry Monitoring Dashboard"
echo "============================"

# Function to get registry stats
get_registry_stats() {
    local registry_url=$1
    local auth=$2
    
    if [ -n "$auth" ]; then
        repos=$(curl -s -u $auth $registry_url/v2/_catalog | python3 -c "import sys, json; print(len(json.load(sys.stdin)['repositories']))" 2>/dev/null || echo "0")
    else
        repos=$(curl -s $registry_url/v2/_catalog | python3 -c "import sys, json; print(len(json.load(sys.stdin)['repositories']))" 2>/dev/null || echo "0")
    fi
    echo $repos
}

# Monitor Docker Hub usage
echo "Docker Hub Images: $(docker images | grep yourusername | wc -l)"

# Monitor private registry
echo "Private Registry Repositories: $(get_registry_stats http://localhost:5000 registryuser:registrypass)"

# Monitor system resources
echo "System Resources:"
echo "  Memory Usage: $(free -h | awk '/^Mem:/ {print $3 "/" $2}')"
echo "  Disk Usage: $(df -h ~/registry-data | awk 'NR==2 {print $3 "/" $2 " (" $5 ")"}')"

# Monitor Docker daemon
echo "Docker Status: $(systemctl is-active docker)"

# Monitor registry containers
echo "Registry Containers:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep registry

echo "Monitoring complete!"
