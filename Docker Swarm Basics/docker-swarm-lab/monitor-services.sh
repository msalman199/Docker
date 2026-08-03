#!/bin/bash

echo "=== Docker Swarm Status ==="
docker info | grep -A 5 "Swarm:"
echo

echo "=== Node Information ==="
docker node ls
echo

echo "=== Stack Information ==="
docker stack ls
echo

echo "=== Service Status ==="
docker service ls
echo

echo "=== Service Details ==="
for service in $(docker service ls --format "{{.Name}}"); do
    echo "--- Service: $service ---"
    docker service ps $service --format "table {{.Name}}\t{{.Image}}\t{{.Node}}\t{{.DesiredState}}\t{{.CurrentState}}"
    echo
done

echo "=== Resource Usage ==="
docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}"
