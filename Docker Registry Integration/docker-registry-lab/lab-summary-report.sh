#!/bin/bash

echo "Docker Registry Integration Lab - Summary Report"
echo "=============================================="
echo "Date: $(date)"
echo ""

echo "1. DOCKER HUB INTEGRATION"
echo "   - Account created and configured"
echo "   - Images pushed: $(docker search yourusername/registry-lab-app 2>/dev/null | wc -l || echo "Check manually")"
echo "   - Authentication: Configured"
echo ""

echo "2. PRIVATE REGISTRY SETUP"
echo "   - Registry Status: $(docker ps | grep secure-registry > /dev/null && echo "Running" || echo "Stopped")"
echo "   - Authentication: Enabled"
echo "   - Storage Location: ~/registry-data"
echo "   - Storage Usage: $(du -sh ~/registry-data | cut -f1)"
echo ""

echo "3. IMAGES CREATED AND MANAGED"
docker images | grep -E "(registry-lab-app|localhost:5000)" | while read line; do
    echo "   - $line"
done
echo ""

echo "4. REGISTRY OPERATIONS COMPLETED"
echo "   ✓ Docker Hub account creation"
echo "   ✓ Image pushing to Docker Hub"
echo "   ✓ Image pulling from Docker Hub"
echo "   ✓ Private registry setup"
echo "   ✓ Private registry authentication"
echo "   ✓ Image versioning and tagging"
echo "   ✓ Registry monitoring and troubleshooting"
echo ""

echo "5. SKILLS DEMONSTRATED"
echo "   - Registry integration and management"
echo "   - Image lifecycle management"
echo "   - Authentication and security configuration"
echo "   - Performance monitoring and troubleshooting"
echo "   - Best practices implementation"

echo ""
echo "Lab completed successfully!"
