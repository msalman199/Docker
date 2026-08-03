#!/bin/bash

LOG_DIR="~/docker-swarm-lab/logs"
mkdir -p $LOG_DIR

echo "Collecting service logs..."

# Collect logs for each service
for service in $(docker service ls --format "{{.Name}}"); do
    echo "Collecting logs for $service..."
    docker service logs $service > "$LOG_DIR/${service}_$(date +%Y%m%d_%H%M%S).log" 2>&1
done

echo "Logs collected in $LOG_DIR"
ls -la $LOG_DIR
