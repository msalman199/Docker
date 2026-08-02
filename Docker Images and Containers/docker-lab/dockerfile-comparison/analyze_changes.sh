#!/bin/bash

CONTAINER_NAME=$1
if [ -z "$CONTAINER_NAME" ]; then
    echo "Usage: $0 <container_name>"
    exit 1
fi

echo "=== Container Change Analysis for $CONTAINER_NAME ==="
echo

# Get all changes
CHANGES=$(docker diff $CONTAINER_NAME)

# Count by type
ADDED=$(echo "$CHANGES" | grep '^A' | wc -l)
CHANGED=$(echo "$CHANGES" | grep '^C' | wc -l)
DELETED=$(echo "$CHANGES" | grep '^D' | wc -l)

echo "Summary:"
echo "  Added: $ADDED files/directories"
echo "  Changed: $CHANGED files/directories"
echo "  Deleted: $DELETED files/directories"
echo

# Show largest changes (by path length as proxy for importance)
echo "Most significant changes:"
echo "$CHANGES" | head -20

echo
echo "Custom/User changes (excluding system files):"
echo "$CHANGES" | grep -v -E "^[ACD] /(var|tmp|proc|sys|dev|run)" | head -10
