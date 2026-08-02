#!/bin/bash

echo "Registry Security Checklist"
echo "=========================="

# Check if registry is using authentication
echo "1. Authentication Status:"
if docker exec secure-registry env | grep -q "REGISTRY_AUTH"; then
    echo "   ✓ Authentication is enabled"
else
    echo "   ✗ Authentication is not enabled"
fi

# Check if registry is accessible externally
echo "2. Network Access:"
if netstat -tlnp | grep -q ":5000.*0.0.0.0"; then
    echo "   ⚠ Registry is accessible from all interfaces"
else
    echo "   ✓ Registry access is restricted"
fi

# Check registry logs for security events
echo "3. Recent Registry Activity:"
docker logs secure-registry --tail 5

echo "Security check complete!"
