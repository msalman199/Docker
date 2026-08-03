#!/bin/bash

DOCKER_USERNAME="yourusername"
IMAGE_NAME="${DOCKER_USERNAME}/cross-platform-demo:latest"

echo "Testing multi-architecture image: ${IMAGE_NAME}"

# Test AMD64
echo "Testing AMD64 platform..."
docker run --rm --platform linux/amd64 ${IMAGE_NAME} node -e "
const os = require('os');
console.log('Platform:', os.platform());
console.log('Architecture:', os.arch());
console.log('Node version:', process.version);
"

echo ""

# Test ARM64
echo "Testing ARM64 platform..."
docker run --rm --platform linux/arm64 ${IMAGE_NAME} node -e "
const os = require('os');
console.log('Platform:', os.platform());
console.log('Architecture:', os.arch());
console.log('Node version:', process.version);
"

echo ""
echo "Multi-architecture test completed!"
