#!/bin/bash

echo "=== Docker Image Analysis ==="
echo

for image in $(docker images --format "{{.Repository}}:{{.Tag}}" | grep -v "<none>"); do
    echo "Image: $image"
    echo "  Size: $(docker images --format "{{.Size}}" $image)"
    echo "  Created: $(docker inspect --format='{{.Created}}' $image)"
    echo "  Architecture: $(docker inspect --format='{{.Architecture}}' $image)"
    echo "  Layers: $(docker history $image --quiet | wc -l)"
    echo "---"
done
