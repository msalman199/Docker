#!/bin/bash

# Secure Docker Container Launcher
# Usage: ./secure-container.sh <image> <command>

IMAGE=${1:-ubuntu:20.04}
COMMAND=${2:-/bin/bash}

echo "Launching secure container with image: $IMAGE"

docker run --rm -it \
  --security-opt seccomp=~/docker-security-lab/seccomp/restricted-profile.json \
  --security-opt apparmor=docker-restricted \
  --security-opt no-new-privileges:true \
  --user 1000:1000 \
  --memory=512m \
  --cpus="1.0" \
  --pids-limit=100 \
  --read-only \
  --tmpfs /tmp:rw,noexec,nosuid,size=100m \
  --cap-drop=ALL \
  --cap-add=CHOWN \
  --cap-add=SETUID \
  --cap-add=SETGID \
  "$IMAGE" "$COMMAND"
