#!/bin/bash

echo "Registry Maintenance Script"
echo "=========================="

# Show registry catalog
echo "Current repositories:"
curl -s -u registryuser:registrypass http://localhost:5000/v2/_catalog | python3 -m json.tool

# Show storage usage
echo -e "\nStorage usage:"
du -sh ~/registry-data

# Show number of images
echo -e "\nLocal images:"
docker images | grep -E "(registry-lab-app|localhost:5000)" | wc -l

echo -e "\nMaintenance complete!"
