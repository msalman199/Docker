#!/bin/bash

echo "=== Build Performance Comparison ==="

# Test traditional build
echo "Testing traditional Docker build..."
cd ~/buildkit-lab/nodejs-app
export DOCKER_BUILDKIT=0
time docker build -f Dockerfile.traditional -t perf-test:traditional . 2>&1 | grep real

# Test BuildKit build
echo "Testing BuildKit build..."
export DOCKER_BUILDKIT=1
time docker build -t perf-test:buildkit . 2>&1 | grep real

# Test with cache (second build)
echo "Testing BuildKit with cache (second build)..."
time docker build -t perf-test:buildkit-cached . 2>&1 | grep real

echo "=== Performance test completed ==="
