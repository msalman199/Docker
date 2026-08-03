<div align="center">

# 🐳 Debugging Docker Containers

### A Hands-On Al Nafi Lab for Systematic Container Troubleshooting

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![Nginx](https://img.shields.io/badge/Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![NodeJS](https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=node.js&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Alpine](https://img.shields.io/badge/Alpine%20Linux-0D597F?style=for-the-badge&logo=alpinelinux&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white)

**Difficulty:** Intermediate • **Estimated Time:** 90–120 minutes

</div>

---

## 📖 Table of Contents

- [🎯 Lab Objectives](#-lab-objectives)
- [✅ Prerequisites](#-prerequisites)
- [🖥️ Lab Environment Setup](#️-lab-environment-setup)
- [🛠️ Task 1: Environment Preparation and Docker Installation](#️-task-1-environment-preparation-and-docker-installation)
- [📜 Task 2: Using Docker Logs for Container Debugging](#-task-2-using-docker-logs-for-container-debugging)
- [🧑‍💻 Task 3: Executing Commands Inside Running Containers](#-task-3-executing-commands-inside-running-containers)
- [🔍 Task 4: Inspecting Containers with Docker Inspect](#-task-4-inspecting-containers-with-docker-inspect)
- [📊 Task 5: Monitoring Container Performance with Docker Stats](#-task-5-monitoring-container-performance-with-docker-stats)
- [🧩 Task 6: Comprehensive Debugging Scenario](#-task-6-comprehensive-debugging-scenario)
- [🚨 Task 7: Debugging Common Container Issues](#-task-7-debugging-common-container-issues)
- [🧰 Task 8: Creating a Debugging Toolkit](#-task-8-creating-a-debugging-toolkit)
- [🧹 Cleanup](#-cleanup)
- [🩹 Troubleshooting Tips](#-troubleshooting-tips)
- [🏁 Conclusion](#-conclusion)

---

## 🎯 Lab Objectives

By the end of this lab, you will be able to:

| # | Objective |
|---|-----------|
| 1 | Use `docker logs` to view and analyze container logs for troubleshooting |
| 2 | Execute commands inside running containers using `docker exec` for debugging |
| 3 | Inspect container configurations and metadata using `docker inspect` |
| 4 | Monitor real-time container performance using `docker stats` |
| 5 | Apply systematic debugging approaches to identify and resolve container issues |
| 6 | Understand common Docker container problems and their solutions |

## ✅ Prerequisites

Before starting this lab, you should have:

- ✔️ Basic understanding of Linux command line operations
- ✔️ Familiarity with Docker concepts (containers, images, basic commands)
- ✔️ Knowledge of text editors like `nano` or `vim`
- ✔️ Understanding of basic networking concepts
- ✔️ Experience with previous Docker labs or equivalent knowledge

## 🖥️ Lab Environment Setup

> **☁️ Note:** Al Nafi provides Linux-based cloud machines for this lab. Simply click **Start Lab** to access your dedicated Linux machine. The provided machine is bare metal with no pre-installed tools — you will install Docker and other required tools during the lab.

---

## 🛠️ Task 1: Environment Preparation and Docker Installation

![Task Stack](https://img.shields.io/badge/Stack-Docker%20Engine-2496ED?style=flat-square&logo=docker&logoColor=white) ![Task Stack](https://img.shields.io/badge/Stack-Ubuntu-E95420?style=flat-square&logo=ubuntu&logoColor=white)

> 🚦 **Sign-in Step:** Installing the Docker Engine and provisioning a handful of intentionally quirky containers — the "patients" you'll be diagnosing for the rest of the lab.

### 🧩 Subtask 1.1: Update System and Install Docker

```bash
# 🔄 Update the package manager
sudo apt update && sudo apt upgrade -y

# 📦 Install required packages
sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release

# 🔑 Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# ➕ Add Docker repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 🔄 Update package index
sudo apt update

# 🐳 Install Docker Engine
sudo apt install -y docker-ce docker-ce-cli containerd.io

# 👤 Add current user to docker group
sudo usermod -aG docker $USER

# ▶️ Start and enable Docker service
sudo systemctl start docker
sudo systemctl enable docker
```

### 🧩 Subtask 1.2: Verify Docker Installation

```bash
# ✅ Verify Docker installation
docker --version

# 👋 Test Docker with hello-world
docker run hello-world

# 🔎 Check Docker service status
sudo systemctl status docker
```

### 🧩 Subtask 1.3: Create Test Containers for Debugging

```bash
# 🌐 Create a simple web server container
docker run -d --name webserver-debug -p 8080:80 nginx:latest

# 🧪 Create a container with environment variables
docker run -d --name env-test -e TEST_VAR="debugging_lab" -e DEBUG_MODE="true" alpine:latest sleep 3600

# ⚠️ Create a container that will have issues (intentionally)
docker run -d --name problematic-app -p 9090:8080 nginx:latest

# 🔁 Create a container with custom command
docker run -d --name custom-app alpine:latest sh -c "while true; do echo 'App running at $(date)'; sleep 10; done"

# 📋 Verify all containers are running
docker ps
```

<!-- TODO: Take a screenshot of `docker ps` output here for your lab notebook -->

---

## 📜 Task 2: Using Docker Logs for Container Debugging

![Task Stack](https://img.shields.io/badge/Tool-docker%20logs-2496ED?style=flat-square&logo=docker&logoColor=white)

> 🚦 **Sign-in Step:** `docker logs` is your first stop for any misbehaving container — it surfaces `stdout`/`stderr` output without ever needing to step inside.

### 🧩 Subtask 2.1: Basic Log Viewing

```bash
# 📄 View logs from the custom-app container
docker logs custom-app

# 🕒 View logs with timestamps
docker logs -t custom-app

# 🔟 View only the last 10 lines of logs
docker logs --tail 10 custom-app

# 👀 Follow logs in real-time (like tail -f)
docker logs -f custom-app
```

> ⏹️ **Note:** Press `Ctrl+C` to stop following logs.

### 🧩 Subtask 2.2: Advanced Log Options

```bash
# 📅 View logs since a specific time
docker logs --since "2024-01-01T00:00:00" webserver-debug

# 📅 View logs until a specific time
docker logs --until "2024-12-31T23:59:59" webserver-debug

# 🔢 View logs with specific number of lines and follow
docker logs --tail 5 -f custom-app &

# 🛑 Stop the background log following
jobs
kill %1
```

### 🧩 Subtask 2.3: Debugging with Log Analysis

```bash
# 🚨 Create a container that will generate errors
docker run -d --name error-prone alpine:latest sh -c "
while true; do
  echo 'Normal operation'
  sleep 5
  echo 'Warning: Low memory' >&2
  sleep 5
  echo 'Error: Connection failed' >&2
  sleep 10
done"

# 📖 View all logs (stdout and stderr)
docker logs error-prone

# 🔴 View only stderr (error messages)
docker logs error-prone 2>&1 | grep -i error

# 🟡 View logs with grep filtering
docker logs error-prone | grep -i warning
```

<!-- TODO: Try filtering error-prone's logs for a third keyword of your choice -->

---

## 🧑‍💻 Task 3: Executing Commands Inside Running Containers

![Task Stack](https://img.shields.io/badge/Tool-docker%20exec-2496ED?style=flat-square&logo=docker&logoColor=white) ![Task Stack](https://img.shields.io/badge/Runtime-Python-3776AB?style=flat-square&logo=python&logoColor=white)

> 🚦 **Sign-in Step:** `docker exec` opens a live window straight into the container's process namespace — for when logs alone don't tell the full story.

### 🧩 Subtask 3.1: Basic Docker Exec Usage

```bash
# 🖥️ Execute an interactive bash shell in the webserver container
docker exec -it webserver-debug /bin/bash

# 📂 Inside the container, explore the environment
# (Run these commands inside the container shell)
pwd
ls -la
ps aux
cat /etc/nginx/nginx.conf
exit
```

### 🧩 Subtask 3.2: Non-Interactive Command Execution

```bash
# 📁 Execute single commands without interactive shell
docker exec webserver-debug ls -la /var/log/nginx/

# 🔎 Check nginx process status
docker exec webserver-debug ps aux | grep nginx

# ⚙️ View nginx configuration
docker exec webserver-debug cat /etc/nginx/conf.d/default.conf

# 💾 Check disk usage inside container
docker exec webserver-debug df -h

# 🌐 Check network configuration
docker exec webserver-debug ip addr show
```

### 🧩 Subtask 3.3: Debugging Application Issues

```bash
# 🐍 Create a container with a Python application that has issues
docker run -d --name python-debug python:3.9-slim sh -c "
cat > /app.py << 'EOF'
import time
import os
import sys

def main():
    print('Starting application...')
    counter = 0
    while True:
        counter += 1
        print(f'Iteration {counter}')

        if counter == 5:
            print('Warning: Approaching error condition', file=sys.stderr)

        if counter == 10:
            print('Error: Simulated application error', file=sys.stderr)
            # Don't exit, just continue with errors

        time.sleep(3)

if __name__ == '__main__':
    main()
EOF

python /app.py"

# 🔬 Debug the Python application
docker exec -it python-debug /bin/bash

# 📂 Inside the container, examine the application
# cat /app.py
# ps aux
# python --version
# exit
```

### 🧩 Subtask 3.4: Installing Debug Tools Inside Containers

```bash
# 🧰 Install debugging tools inside a running container
docker exec -it webserver-debug /bin/bash

# 📥 Inside the container, install tools
# apt update
# apt install -y curl wget htop procps net-tools
# htop
# netstat -tulpn
# curl localhost
# exit

# ⚡ Alternative: Install tools non-interactively
docker exec webserver-debug apt update
docker exec webserver-debug apt install -y curl procps
docker exec webserver-debug curl -I localhost
```

<!-- TODO: Install `net-tools` non-interactively into python-debug and run `netstat -tulpn` -->

---

## 🔍 Task 4: Inspecting Containers with Docker Inspect

![Task Stack](https://img.shields.io/badge/Tool-docker%20inspect-2496ED?style=flat-square&logo=docker&logoColor=white) ![Task Stack](https://img.shields.io/badge/Format-JSON-000000?style=flat-square&logo=json&logoColor=white)

> 🚦 **Sign-in Step:** `docker inspect` returns the full JSON metadata record of a container — state, networking, mounts, resource limits, everything Docker knows about it.

### 🧩 Subtask 4.1: Basic Container Inspection

```bash
# 🗂️ Inspect the webserver container
docker inspect webserver-debug

# 🎯 Get specific information using format option
docker inspect --format='{{.State.Status}}' webserver-debug

# 🌐 Get container IP address
docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' webserver-debug

# 🔌 Get port mappings
docker inspect --format='{{.NetworkSettings.Ports}}' webserver-debug
```

### 🧩 Subtask 4.2: Analyzing Container Configuration

```bash
# 🌱 Get environment variables
docker inspect --format='{{.Config.Env}}' env-test

# 📦 Get mounted volumes
docker inspect --format='{{.Mounts}}' webserver-debug

# ▶️ Get container command and arguments
docker inspect --format='{{.Config.Cmd}}' custom-app

# 📁 Get container working directory
docker inspect --format='{{.Config.WorkingDir}}' webserver-debug

# 🕒 Get container creation time
docker inspect --format='{{.Created}}' webserver-debug
```

### 🧩 Subtask 4.3: Network and Resource Inspection

```bash
# 🌐 Get detailed network information
docker inspect --format='{{json .NetworkSettings}}' webserver-debug | python3 -m json.tool

# 🧮 Get resource limits
docker inspect --format='{{.HostConfig.Memory}}' webserver-debug
docker inspect --format='{{.HostConfig.CpuShares}}' webserver-debug

# ♻️ Get restart policy
docker inspect --format='{{.HostConfig.RestartPolicy}}' webserver-debug

# 📝 Get log configuration
docker inspect --format='{{.HostConfig.LogConfig}}' webserver-debug
```

### 🧩 Subtask 4.4: Troubleshooting with Inspect

```bash
# ⚙️ Create a container with specific configuration for debugging
docker run -d --name debug-config \
  --memory="256m" \
  --cpus="0.5" \
  --restart=unless-stopped \
  -e DEBUG_LEVEL="verbose" \
  -v /tmp:/app/temp \
  alpine:latest sleep 3600

# 🔍 Inspect the configuration
docker inspect debug-config

# ✅ Verify resource limits
docker inspect --format='Memory Limit: {{.HostConfig.Memory}}' debug-config
docker inspect --format='CPU Limit: {{.HostConfig.CpuShares}}' debug-config
docker inspect --format='Restart Policy: {{.HostConfig.RestartPolicy.Name}}' debug-config

# 📦 Check if volumes are mounted correctly
docker inspect --format='{{range .Mounts}}{{.Source}} -> {{.Destination}}{{end}}' debug-config
```

<!-- TODO: Write a --format query that prints debug-config's DEBUG_LEVEL env var only -->

---

## 📊 Task 5: Monitoring Container Performance with Docker Stats

![Task Stack](https://img.shields.io/badge/Tool-docker%20stats-2496ED?style=flat-square&logo=docker&logoColor=white) ![Task Stack](https://img.shields.io/badge/Data-CSV-217346?style=flat-square&logo=microsoftexcel&logoColor=white)

> 🚦 **Sign-in Step:** `docker stats` streams live CPU, memory, network, and block I/O metrics — the pulse monitor for your containers.

### 🧩 Subtask 5.1: Basic Performance Monitoring

```bash
# 📡 View stats for all running containers
docker stats

# 🎯 View stats for specific containers
docker stats webserver-debug custom-app

# 📸 View stats without streaming (one-time snapshot)
docker stats --no-stream

# 🗃️ View stats with custom format
docker stats --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}"
```

### 🧩 Subtask 5.2: Creating Load for Monitoring

```bash
# 🔥 Create a CPU-intensive container
docker run -d --name cpu-load alpine:latest sh -c "
while true; do
  echo 'scale=5000; 4*a(1)' | bc -l > /dev/null
done"

# 🧠 Create a memory-intensive container
docker run -d --name memory-load alpine:latest sh -c "
apk add --no-cache python3
python3 -c '
import time
data = []
for i in range(1000):
    data.append(\"x\" * 1024 * 1024)  # 1MB chunks
    time.sleep(0.1)
    if i % 100 == 0:
        print(f\"Allocated {i} MB\")
'"

# 📈 Monitor the performance impact
docker stats --no-stream cpu-load memory-load
```

### 🧩 Subtask 5.3: Advanced Performance Analysis

```bash
# 🧾 Create a script to log stats over time
cat > monitor_stats.sh << 'EOF'
#!/bin/bash
echo "Timestamp,Container,CPU%,Memory Usage,Memory Limit,Memory%,Net I/O,Block I/O" > container_stats.csv

for i in {1..10}; do
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    docker stats --no-stream --format "$timestamp,{{.Container}},{{.CPUPerc}},{{.MemUsage}},{{.MemPerc}},{{.NetIO}},{{.BlockIO}}" >> container_stats.csv
    sleep 5
done
EOF

chmod +x monitor_stats.sh
./monitor_stats.sh

# 📊 View the collected data
cat container_stats.csv
```

### 🧩 Subtask 5.4: Resource Limit Testing

```bash
# 🚧 Create a container with memory limits
docker run -d --name limited-memory --memory="128m" alpine:latest sh -c "
apk add --no-cache python3
python3 -c '
import time
try:
    data = []
    for i in range(200):
        data.append(\"x\" * 1024 * 1024)  # Try to allocate 200MB
        print(f\"Allocated {i+1} MB\")
        time.sleep(0.5)
except MemoryError:
    print(\"Memory limit reached!\")
    time.sleep(3600)
'"

# 📉 Monitor the memory-limited container
docker stats --no-stream limited-memory

# 💀 Check if container was killed due to memory limit
docker logs limited-memory
docker inspect --format='{{.State.ExitCode}}' limited-memory
```

<!-- TODO: Lower the memory limit to 64m and observe whether OOMKilled flips to true -->

---

## 🧩 Task 6: Comprehensive Debugging Scenario

![Task Stack](https://img.shields.io/badge/Database-MySQL-4479A1?style=flat-square&logo=mysql&logoColor=white) ![Task Stack](https://img.shields.io/badge/Backend-Node.js-339933?style=flat-square&logo=node.js&logoColor=white) ![Task Stack](https://img.shields.io/badge/Network-Bridge-2496ED?style=flat-square&logo=docker&logoColor=white)

> 🚦 **Sign-in Step:** A realistic multi-container app — Node.js talking to MySQL over a custom bridge network — so every debugging tool from Tasks 2–5 gets exercised together.

### 🧩 Subtask 6.1: Setting Up a Complex Debugging Scenario

```bash
# 🌉 Create a network for our application
docker network create debug-network

# 🗄️ Create a database container
docker run -d --name debug-db \
  --network debug-network \
  -e MYSQL_ROOT_PASSWORD=rootpass \
  -e MYSQL_DATABASE=testdb \
  -e MYSQL_USER=testuser \
  -e MYSQL_PASSWORD=testpass \
  mysql:8.0

# 🚀 Create an application container that connects to the database
docker run -d --name debug-app \
  --network debug-network \
  -p 3000:3000 \
  node:16-alpine sh -c "
npm init -y
npm install express mysql2
cat > app.js << 'EOF'
const express = require('express');
const mysql = require('mysql2');
const app = express();

const db = mysql.createConnection({
  host: 'debug-db',
  user: 'testuser',
  password: 'testpass',
  database: 'testdb'
});

app.get('/', (req, res) => {
  console.log('Received request to /');
  res.json({status: 'ok', message: 'App is running'});
});

app.get('/db-test', (req, res) => {
  console.log('Testing database connection...');
  db.query('SELECT 1 as test', (err, results) => {
    if (err) {
      console.error('Database error:', err);
      res.status(500).json({error: 'Database connection failed'});
    } else {
      console.log('Database connection successful');
      res.json({status: 'ok', data: results});
    }
  });
});

const port = 3000;
app.listen(port, '0.0.0.0', () => {
  console.log(\`Server running on port \${port}\`);
});
EOF

node app.js"
```

### 🧩 Subtask 6.2: Debugging the Application

```bash
# ⏳ Wait for containers to start
sleep 30

# 📋 Check container status
docker ps

# 🌐 Test the application
curl http://localhost:3000/
curl http://localhost:3000/db-test

# 📜 Debug using logs
docker logs debug-app
docker logs debug-db

# 🔗 Inspect network connectivity
docker exec debug-app ping -c 3 debug-db
docker exec debug-app nslookup debug-db

# 🗃️ Check database status
docker exec -it debug-db mysql -u root -prootpass -e "SHOW DATABASES;"
```

### 🧩 Subtask 6.3: Performance Analysis of the Complete System

```bash
# 📊 Monitor all containers
docker stats --no-stream debug-db debug-app

# 🌉 Inspect network configuration
docker network inspect debug-network

# 📈 Check resource usage over time
docker stats debug-db debug-app &
STATS_PID=$!

# 🔁 Generate some load
for i in {1..20}; do
  curl -s http://localhost:3000/ > /dev/null
  curl -s http://localhost:3000/db-test > /dev/null
  sleep 1
done

# 🛑 Stop monitoring
kill $STATS_PID
```

<!-- TODO: Add a third endpoint to app.js and repeat the load-test loop against it -->

---

## 🚨 Task 7: Debugging Common Container Issues

![Task Stack](https://img.shields.io/badge/Focus-Failure%20Modes-D93F3F?style=flat-square&logo=docker&logoColor=white)

> 🚦 **Sign-in Step:** Three of the most common real-world Docker failures, reproduced on purpose so you recognize the signature of each one instantly.

### 🧩 Subtask 7.1: Container Won't Start

```bash
# 💥 Create a container with startup issues
docker run -d --name startup-issue alpine:latest /nonexistent/command

# 🔍 Debug the startup issue
docker ps -a | grep startup-issue
docker logs startup-issue
docker inspect --format='{{.State.ExitCode}}' startup-issue
docker inspect --format='{{.State.Error}}' startup-issue
```

### 🧩 Subtask 7.2: Port Binding Issues

```bash
# ⚔️ Try to create a container with conflicting port
docker run -d --name port-conflict -p 8080:80 nginx:latest

# 🔎 Debug port conflicts
docker ps
netstat -tulpn | grep 8080
docker inspect --format='{{.NetworkSettings.Ports}}' webserver-debug
```

### 🧩 Subtask 7.3: Resource Exhaustion

```bash
# 🪫 Create a container that exhausts resources
docker run -d --name resource-hog --memory="64m" alpine:latest sh -c "
dd if=/dev/zero of=/tmp/bigfile bs=1M count=100
"

# 🔍 Debug resource issues
docker logs resource-hog
docker stats --no-stream resource-hog
docker inspect --format='{{.State.OOMKilled}}' resource-hog
```

<!-- TODO: Reproduce a fourth failure mode of your choice (e.g. a missing volume mount) and diagnose it the same way -->

---

## 🧰 Task 8: Creating a Debugging Toolkit

![Task Stack](https://img.shields.io/badge/Base%20Image-Ubuntu%2022.04-E95420?style=flat-square&logo=ubuntu&logoColor=white) ![Task Stack](https://img.shields.io/badge/Tools-tcpdump%20%7C%20strace%20%7C%20jq-2496ED?style=flat-square&logo=gnu-bash&logoColor=white)

> 🚦 **Sign-in Step:** Packaging everything you've learned into a reusable debug image and a one-shot diagnostic script — your permanent debugging kit for future labs.

### 🧩 Subtask 8.1: Building a Debug Container

```bash
# 🏗️ Create a comprehensive debugging container
cat > Dockerfile.debug << 'EOF'
FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    curl \
    wget \
    net-tools \
    iputils-ping \
    dnsutils \
    htop \
    strace \
    tcpdump \
    vim \
    jq \
    mysql-client \
    postgresql-client \
    redis-tools \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /debug
CMD ["/bin/bash"]
EOF

# 🔨 Build the debug image
docker build -f Dockerfile.debug -t debug-toolkit .

# 🧪 Use the debug toolkit to inspect other containers
docker run -it --rm --network debug-network debug-toolkit bash

# 📂 Inside the debug container, you can:
# ping debug-db
# nslookup debug-app
# curl debug-app:3000
# mysql -h debug-db -u testuser -ptestpass testdb
# exit
```

### 🧩 Subtask 8.2: Creating Debug Scripts

```bash
# 📝 Create a comprehensive debugging script
cat > debug_container.sh << 'EOF'
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
EOF

chmod +x debug_container.sh

# ▶️ Test the debug script
./debug_container.sh webserver-debug
```

<!-- TODO: Extend debug_container.sh to also print the container's restart policy -->

---

## 🧹 Cleanup

```bash
# 🛑 Stop and remove all containers
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)

# 🌉 Remove custom network
docker network rm debug-network

# 🗑️ Remove custom images
docker rmi debug-toolkit

# 🧽 Clean up files
rm -f monitor_stats.sh debug_container.sh container_stats.csv Dockerfile.debug
```

---

## 🩹 Troubleshooting Tips

<details>
<summary>🔴 Issue: Container logs are not showing</summary>

**Solution:** Check if the application is writing to stdout/stderr

```bash
docker exec -it <container> ls -la /proc/1/fd/
```

</details>

<details>
<summary>🔴 Issue: Cannot execute commands in container</summary>

**Solution:** Verify the container is running and a shell exists

```bash
docker exec <container> ls /bin/
```

</details>

<details>
<summary>🔴 Issue: High resource usage</summary>

**Solution:** Check for resource limits and optimize the application

```bash
docker update --memory=512m --cpus=1 <container>
```

</details>

<details>
<summary>🔴 Issue: Network connectivity problems</summary>

**Solution:** Inspect network configuration and DNS resolution

```bash
docker network ls && docker exec <container> nslookup <target>
```

</details>

---

## 📌 Key Concepts

| Concept | Purpose |
|---|---|
| `docker logs` | stdout/stderr retrieval — first-line triage for crashing or misbehaving apps |
| `docker exec` | Live shell/command access inside a running container's namespace |
| `docker inspect` | Full JSON metadata: state, network, mounts, resource limits, restart policy |
| `docker stats` | Real-time CPU/memory/network/block I/O metrics per container |
| Exit codes & `OOMKilled` | Distinguish crashed apps from resource-limit kills |
| Custom bridge networks | Enable service-name DNS resolution between linked containers |

---

## 🏁 Conclusion

In this comprehensive lab, you learned essential Docker debugging techniques that are crucial for maintaining containerized applications in production environments.

### ✅ Key Accomplishments

- 📜 **Log Analysis** — used `docker logs` with various options to troubleshoot application issues and monitor container behavior
- 🧑‍💻 **Interactive Debugging** — leveraged `docker exec` to access running containers and perform real-time debugging
- 🔍 **Configuration Inspection** — utilized `docker inspect` to examine container metadata, networking, and resource configurations
- 📊 **Performance Monitoring** — implemented `docker stats` to track resource usage and identify performance bottlenecks

### 🌍 Real-World Applications

These debugging skills are fundamental for DevOps engineers, system administrators, and developers working with containerized applications. The ability to quickly diagnose and resolve container issues reduces downtime, improves application reliability, and enhances overall system performance.

The debugging techniques practiced in this lab apply directly to production scenarios where containers fail to start, experience performance issues, or encounter networking problems. Combining these tools systematically enables efficient troubleshooting of complex containerized environments and helps maintain robust production systems.

> 💡 **Remember:** Effective debugging is an iterative process that combines multiple tools and techniques. Always start with basic checks (container status, logs) before moving to advanced debugging methods (performance monitoring, network analysis).

---

<div align="center">

![Al Nafi](https://img.shields.io/badge/Al%20Nafi-Cybersecurity%20Training-1E3A8A?style=for-the-badge)

</div>
