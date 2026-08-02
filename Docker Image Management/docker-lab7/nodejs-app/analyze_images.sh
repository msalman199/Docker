#!/bin/bash

echo "=== Docker Image Analysis ==="
echo

echo "All nodejs-lab-app images:"
docker images | grep nodejs-lab-app | sort -k3

echo
echo "=== Size Comparison ==="
for tag in latest optimized multistage advanced; do
    if docker images nodejs-lab-app:$tag &> /dev/null; then
        size=$(docker images nodejs-lab-app:$tag --format "{{.Size}}")
        echo "nodejs-lab-app:$tag - $size"
    fi
done

echo
echo "=== Layer Analysis ==="
echo "Layers in multistage build:"
docker history nodejs-lab-app:multistage --no-trunc

echo
echo "=== Security Scan (if available) ==="
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
    -v $HOME/Library/Caches:/root/.cache/ \
    aquasec/trivy:latest image nodejs-lab-app:advanced || echo "Trivy not available, skipping security scan"
