#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 <container_name>"
    exit 1
fi

CONTAINER=$1

echo "=== Container Debug Report for: $CONTAINER ==="
echo "Generated at: $(date)"
echo

echo "=== Container Status ==="
docker ps -a --filter name=$CONTAINER

echo -e "\n=== Container Logs (last 20 lines) ==="
docker logs --tail 20 $CONTAINER

echo -e "\n=== Container Inspection ==="
echo "State: $(docker inspect --format='{{.State.Status}}' $CONTAINER)"
echo "Exit Code: $(docker inspect --format='{{.State.ExitCode}}' $CONTAINER)"
echo "Started At: $(docker inspect --format='{{.State.StartedAt}}' $CONTAINER)"
echo "IP Address: $(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $CONTAINER)"

echo -e "\n=== Resource Usage ==="
docker stats --no-stream $CONTAINER

echo -e "\n=== Port Mappings ==="
docker inspect --format='{{range $p, $conf := .NetworkSettings.Ports}}{{$p}} -> {{(index $conf 0).HostPort}}{{end}}' $CONTAINER

echo -e "\n=== Environment Variables ==="
docker inspect --format='{{range .Config.Env}}{{println .}}{{end}}' $CONTAINER

echo -e "\n=== Mounted Volumes ==="
docker inspect --format='{{range .Mounts}}{{.Source}} -> {{.Destination}} ({{.Type}}){{end}}' $CONTAINER

echo -e "\n=== Process List ==="
docker exec $CONTAINER ps aux 2>/dev/null || echo "Cannot access process list"

echo -e "\n=== Network Connectivity Test ==="
docker exec $CONTAINER ping -c 2 8.8.8.8 2>/dev/null || echo "Cannot test network connectivity"

echo "=== End of Debug Report ==="
