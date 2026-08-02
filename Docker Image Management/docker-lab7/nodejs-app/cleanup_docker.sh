#!/bin/bash

echo "=== Docker Cleanup Script ==="
echo "Current disk usage:"
docker system df

echo
echo "Cleaning up..."

# Remove dangling images
echo "Removing dangling images..."
docker image prune -f

# Remove unused containers
echo "Removing stopped containers..."
docker container prune -f

# Remove unused networks
echo "Removing unused networks..."
docker network prune -f

# Remove unused volumes
echo "Removing unused volumes..."
docker volume prune -f

echo
echo "Cleanup complete. New disk usage:"
docker system df

echo
echo "Remaining images:"
docker images
