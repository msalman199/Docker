#!/bin/bash

echo "=== BuildKit Verification Tests ==="

# Test 1: Verify BuildKit is enabled
echo "Test 1: Checking BuildKit status..."
if docker info | grep -q "BuildKit"; then
    echo "✓ BuildKit is enabled"
else
    echo "✗ BuildKit is not enabled"
fi

# Test 2: Test cache mount functionality
echo "Test 2: Testing cache mount..."
cd ~/buildkit-lab/nodejs-app
if docker build -q -t test-cache . > /dev/null 2>&1; then
    echo "✓ Cache mount build successful"
else
    echo "✗ Cache mount build failed"
fi

# Test 3: Test multi-stage build
echo "Test 3: Testing multi-stage build..."
cd ~/buildkit-lab/go-app
if docker build -q -t test-multistage . > /dev/null 2>&1; then
    echo "✓ Multi-stage build successful"
else
    echo "✗ Multi-stage build failed"
fi

# Test 4: Test secret mount
echo "Test 4: Testing secret mount..."
cd ~/buildkit-lab/nodejs-app
if [ -f api-key.txt ] && docker build --secret id=api_key,src=./api-key.txt -f Dockerfile.secrets -q -t test-secrets . > /dev/null 2>&1; then
    echo "✓ Secret mount build successful"
else
    echo "✗ Secret mount build failed"
fi

# Test 5: Test buildx functionality
echo "Test 5: Testing buildx..."
if docker buildx version > /dev/null 2>&1; then
    echo "✓ Buildx is available"
else
    echo "✗ Buildx is not available"
fi

echo "=== Verification completed ==="
