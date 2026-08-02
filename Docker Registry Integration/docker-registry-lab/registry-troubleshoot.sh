#!/bin/bash

echo "Registry Troubleshooting Guide"
echo "============================="

# Check Docker daemon status
echo "1. Docker Service Status:"
systemctl is-active docker

# Check registry container status
echo "2. Registry Container Status:"
docker ps | grep registry || echo "No registry containers running"

# Check registry connectivity
echo "3. Registry Connectivity:"
if curl -s http://localhost:5000/v2/ > /dev/null; then
    echo "   ✓ Registry is accessible"
else
    echo "   ✗ Registry is not accessible"
fi

# Check disk space
echo "4. Disk Space:"
df -h ~/registry-data

# Check registry logs for errors
echo "5. Recent Registry Logs:"
if docker ps | grep -q secure-registry; then
    docker logs secure-registry --tail 10 | grep -i error || echo "   No errors found"
else
    echo "   Registry container not running"
fi

echo "Troubleshooting complete!
