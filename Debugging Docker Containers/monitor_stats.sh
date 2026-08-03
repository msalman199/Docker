#!/bin/bash
echo "Timestamp,Container,CPU%,Memory Usage,Memory Limit,Memory%,Net I/O,Block I/O" > container_stats.csv

for i in {1..10}; do
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    docker stats --no-stream --format "$timestamp,{{.Container}},{{.CPUPerc}},{{.MemUsage}},{{.MemPerc}},{{.NetIO}},{{.BlockIO}}" >> container_stats.csv
    sleep 5
done
