#!/bin/bash

echo "Registry Performance Comparison"
echo "==============================="

# Test Docker Hub push/pull time
echo "Testing Docker Hub..."
time_start=$(date +%s)
docker pull yourusername/registry-lab-app:v1.0 > /dev/null 2>&1
time_end=$(date +%s)
dockerhub_time=$((time_end - time_start))
echo "Docker Hub pull time: ${dockerhub_time} seconds"

# Test private registry push/pull time
echo "Testing Private Registry..."
time_start=$(date +%s)
docker pull localhost:5000/registry-lab-app:v1.0 > /dev/null 2>&1
time_end=$(date +%s)
private_time=$((time_end - time_start))
echo "Private Registry pull time: ${private_time} seconds"

echo "Performance comparison complete!"
