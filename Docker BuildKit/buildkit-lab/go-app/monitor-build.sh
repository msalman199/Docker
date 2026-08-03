#!/bin/bash

BUILD_START=$(date +%s)
echo "Starting build at $(date)"

# Monitor system resources during build
(
  while true; do
    echo "$(date): CPU: $(top -bn1 | grep "Cpu(s)" | awk '{print $2}'), Memory: $(free -h | grep Mem | awk '{print $3"/"$2}')"
    sleep 2
  done
) &
MONITOR_PID=$!

# Run the build
docker build -t buildkit-demo:monitored .

# Stop monitoring
kill $MONITOR_PID 2>/dev/null

BUILD_END=$(date +%s)
BUILD_TIME=$((BUILD_END - BUILD_START))
echo "Build completed in ${BUILD_TIME} seconds"
