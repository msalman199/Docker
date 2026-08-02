#!/bin/bash

echo "Docker Registry Lab Cleanup"
echo "=========================="

read -p "Are you sure you want to clean up all lab resources? (y/N): " confirm
if [[ $confirm != [yY] ]]; then
    echo "Cleanup cancelled."
    exit 0
fi

# Stop and remove containers
echo "Stopping containers..."
docker stop secure-registry 2>/dev/null
docker rm secure-registry 2>/dev/null

# Remove images (keep Docker Hub images for reference)
echo "Removing local images..."
docker rmi localhost:5000/registry-lab-app:v1.0 2>/dev/null
docker rmi localhost:5000/registry-lab-app:v2.0 2>/dev/null
docker rmi localhost:5000/registry-lab-app:latest 2>/dev/null
docker rmi registry-lab-app:v1.0 2>/dev/null
docker rmi registry-lab-app:v2.0 2>/dev/null

# Remove registry data (optional)
read -p "Remove registry data directory? (y/N): " remove_data
if [[ $remove_data == [yY] ]]; then
    rm -rf ~/registry-data
    rm -rf ~/registry-auth
    rm -rf ~/registry-config
fi

echo "Cleanup completed!"
