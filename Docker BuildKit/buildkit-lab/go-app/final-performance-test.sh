#!/bin/bash

echo "=== Final Performance Comparison ==="

cd ~/buildkit-lab/nodejs-app

# Clean up existing images
docker rmi -f $(docker images -q buildkit-demo:*) 2>/dev/null || true

echo "Building with traditional Docker (BUILDKIT=0)..."
export DOCKER_BUILDKIT=0
time docker build -f Dockerfile.traditional -t buildkit-demo:traditional-final . > /dev/null 2>&1

echo "Building with BuildKit (BUILDKIT=1)..."
export DOCKER_BUILDKIT=1
time docker build -t buildkit-demo:buildkit-final . > /dev/null 2>&1

echo "Rebuilding with BuildKit (should use cache)..."
time docker build -t buildkit-demo:buildkit-cached-final . > /dev/null 2>&1

echo "=== Image sizes ==="
docker images | grep buildkit-demo

echo "=== Performance test completed ==="
