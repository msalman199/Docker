<div align="center">

# 🐝 Docker Swarm Basics

### A Hands-On Al Nafi Lab for Native Container Orchestration

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Docker Swarm](https://img.shields.io/badge/Docker%20Swarm-1D63ED?style=for-the-badge&logo=docker&logoColor=white)
![Nginx](https://img.shields.io/badge/Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white)
![Redis](https://img.shields.io/badge/Redis-DC382D?style=for-the-badge&logo=redis&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![Bash](https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white)

**Difficulty:** Intermediate • **Estimated Time:** 120–150 minutes

</div>

---

## 📖 Table of Contents

- [🎯 Lab Objectives](#-lab-objectives)
- [✅ Prerequisites](#-prerequisites)
- [🖥️ Lab Environment Setup](#️-lab-environment-setup)
- [🛠️ Task 1: Environment Preparation and Docker Installation](#️-task-1-environment-preparation-and-docker-installation)
- [🐝 Task 2: Initialize Docker Swarm](#-task-2-initialize-docker-swarm)
- [🧱 Task 3: Create and Deploy a Simple Multi-Container Service](#-task-3-create-and-deploy-a-simple-multi-container-service)
- [📈 Task 4: Scale Services in Docker Swarm](#-task-4-scale-services-in-docker-swarm)
- [🚀 Task 5: Advanced Service Management](#-task-5-advanced-service-management)
- [📊 Task 6: Monitoring and Troubleshooting](#-task-6-monitoring-and-troubleshooting)
- [🧹 Task 7: Cleanup and Stack Management](#-task-7-cleanup-and-stack-management)
- [🩹 Troubleshooting Common Issues](#-troubleshooting-common-issues)
- [📌 Key Concepts Summary](#-key-concepts-summary)
- [🏁 Conclusion](#-conclusion)

---

## 🎯 Lab Objectives

By the end of this lab, you will be able to:

| # | Objective |
|---|-----------|
| 1 | Understand the fundamentals of container orchestration using Docker Swarm |
| 2 | Initialize a Docker Swarm cluster on a single machine |
| 3 | Deploy multi-container applications using Docker Stack |
| 4 | Scale services dynamically within a Docker Swarm environment |
| 5 | Manage and monitor services in a Swarm cluster |
| 6 | Understand the difference between Docker Compose and Docker Stack |

## ✅ Prerequisites

Before starting this lab, you should have:

- ✔️ Basic understanding of Docker containers and images
- ✔️ Familiarity with Linux command line operations
- ✔️ Knowledge of YAML file structure
- ✔️ Understanding of basic networking concepts
- ✔️ Experience with Docker Compose (recommended but not required)

## 🖥️ Lab Environment Setup

> **☁️ Al Nafi Cloud Machine:** This lab uses a Linux-based cloud machine provided by Al Nafi. Simply click **Start Lab** to access your dedicated Linux environment. The machine comes as bare metal with no pre-installed tools — Docker and other required components are installed during the lab.

> ⚠️ **Important Note:** All tasks in this lab are performed on a single Linux machine. We simulate a multi-node environment using Docker Swarm's single-node capabilities.

---

## 🛠️ Task 1: Environment Preparation and Docker Installation

![Task Stack](https://img.shields.io/badge/Stack-Docker%20Engine-2496ED?style=flat-square&logo=docker&logoColor=white) ![Task Stack](https://img.shields.io/badge/Stack-Ubuntu-E95420?style=flat-square&logo=ubuntu&logoColor=white)

> 🚦 **Sign-in Step:** Installing Docker Engine with the Compose and Buildx plugins, then laying out a clean working directory — the launchpad for the swarm we're about to spin up.

### 🧩 Subtask 1.1: Update System and Install Docker

```bash
# 🔄 Update the package repository
sudo apt update && sudo apt upgrade -y

# 📦 Install required packages for Docker installation
sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release

# 🔑 Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# ➕ Add Docker repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 🔄 Update package repository again
sudo apt update

# 🐳 Install Docker Engine
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 👤 Add current user to docker group to run Docker without sudo
sudo usermod -aG docker $USER

# ♻️ Apply group changes
newgrp docker
```

### 🧩 Subtask 1.2: Verify Docker Installation

```bash
# ✅ Check Docker version
docker --version

# 🔎 Verify Docker is running
sudo systemctl status docker

# 👋 Test Docker with hello-world container
docker run hello-world
```

### 🧩 Subtask 1.3: Create Working Directory

```bash
# 📁 Create a directory for our lab files
mkdir -p ~/docker-swarm-lab
cd ~/docker-swarm-lab

# 🗂️ Create subdirectories for organization
mkdir -p services configs logs
```

<!-- TODO: Confirm `docker run hello-world` works without sudo before moving on -->

---

## 🐝 Task 2: Initialize Docker Swarm

![Task Stack](https://img.shields.io/badge/Tool-docker%20swarm-1D63ED?style=flat-square&logo=docker&logoColor=white)

> 🚦 **Sign-in Step:** Turning a single Docker engine into a swarm manager — the moment orchestration primitives (services, stacks, overlay networks) become available.

### 🧩 Subtask 2.1: Initialize Swarm Mode

Docker Swarm mode transforms your Docker engine into a swarm manager. Even on a single machine, this enables orchestration capabilities.

```bash
# 🐝 Initialize Docker Swarm
docker swarm init

# The output will show something like:
# Swarm initialized: current node (node-id) is now a manager.
# To add a worker to this swarm, run the following command:
# docker swarm join --token SWMTKN-1-... <manager-ip>:2377
```

### 🧩 Subtask 2.2: Verify Swarm Status

```bash
# 🔎 Check swarm status
docker info | grep -A 10 "Swarm:"

# 📋 List nodes in the swarm
docker node ls

# 🔍 Get detailed information about the current node
docker node inspect self --pretty
```

### 🧩 Subtask 2.3: Understanding Swarm Components

Let's explore the key components of our newly created swarm:

```bash
# 🔐 View swarm configuration
docker swarm ca

# 📋 Check if any services are running (should be empty initially)
docker service ls

# 📋 Check for any existing stacks
docker stack ls
```

<!-- TODO: Run `docker node inspect self --pretty` and note the manager's Raft status -->

---

## 🧱 Task 3: Create and Deploy a Simple Multi-Container Service

![Task Stack](https://img.shields.io/badge/Service-Nginx-009639?style=flat-square&logo=nginx&logoColor=white) ![Task Stack](https://img.shields.io/badge/Service-Redis-DC382D?style=flat-square&logo=redis&logoColor=white) ![Task Stack](https://img.shields.io/badge/Network-Overlay-2496ED?style=flat-square&logo=docker&logoColor=white)

> 🚦 **Sign-in Step:** A two-service stack — Nginx and Redis on an overlay network — deployed with `docker stack deploy` instead of `docker compose up`, replicas and restart policies included.

### 🧩 Subtask 3.1: Create a Simple Web Application Stack

We'll create a multi-container application consisting of a web server and a database.

```bash
# 📁 Navigate to our services directory
cd ~/docker-swarm-lab/services

# 📝 Create a Docker Compose file for our stack
cat > web-stack.yml << 'EOF'
version: '3.8'

services:
  web:
    image: nginx:alpine
    ports:
      - "8080:80"
    volumes:
      - web-content:/usr/share/nginx/html
    deploy:
      replicas: 2
      restart_policy:
        condition: on-failure
        delay: 5s
        max_attempts: 3
      update_config:
        parallelism: 1
        delay: 10s
      placement:
        constraints:
          - node.role == manager
    networks:
      - webnet

  redis:
    image: redis:alpine
    deploy:
      replicas: 1
      restart_policy:
        condition: on-failure
      placement:
        constraints:
          - node.role == manager
    networks:
      - webnet
    volumes:
      - redis-data:/data

volumes:
  web-content:
  redis-data:

networks:
  webnet:
    driver: overlay
EOF
```

### 🧩 Subtask 3.2: Create Custom Web Content

```bash
# 📁 Create a custom HTML file for our web service
mkdir -p ~/docker-swarm-lab/web-content

cat > ~/docker-swarm-lab/web-content/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Docker Swarm Lab</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background-color: #f0f0f0; }
        .container { background-color: white; padding: 20px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h1 { color: #2196F3; }
        .info { background-color: #e3f2fd; padding: 15px; border-radius: 5px; margin: 10px 0; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Welcome to Docker Swarm Lab</h1>
        <div class="info">
            <h3>Service Information:</h3>
            <p><strong>Container ID:</strong> <span id="hostname"></span></p>
            <p><strong>Service:</strong> Web Frontend</p>
            <p><strong>Stack:</strong> web-stack</p>
            <p><strong>Lab:</strong> Docker Swarm Basics</p>
        </div>
        <p>This page is served by a containerized Nginx service running in Docker Swarm mode.</p>
        <p>Refresh the page to see load balancing between different container instances.</p>
    </div>
    <script>
        document.getElementById('hostname').textContent = window.location.hostname;
    </script>
</body>
</html>
EOF
```

### 🧩 Subtask 3.3: Deploy the Stack

```bash
# 🚀 Deploy the stack to Docker Swarm
docker stack deploy -c web-stack.yml webstack

# ✅ Verify the stack deployment
docker stack ls

# 📋 Check the services in our stack
docker stack services webstack

# 📋 Get detailed information about stack services
docker service ls
```

### 🧩 Subtask 3.4: Verify Service Deployment

```bash
# 🔎 Check the status of individual services
docker service ps webstack_web
docker service ps webstack_redis

# 🔍 Inspect the web service
docker service inspect webstack_web --pretty

# 📜 Check service logs
docker service logs webstack_web
docker service logs webstack_redis
```

<!-- TODO: Curl http://localhost:8080 and confirm the custom index.html renders -->

---

## 📈 Task 4: Scale Services in Docker Swarm

![Task Stack](https://img.shields.io/badge/Feature-Service%20Scaling-1D63ED?style=flat-square&logo=docker&logoColor=white)

> 🚦 **Sign-in Step:** Scaling replicas both with a one-off `docker service scale` and by redeploying the stack file — two paths to the same orchestration outcome — then watching load balance across them.

### 🧩 Subtask 4.1: Scale the Web Service

```bash
# 📈 Scale the web service to 4 replicas
docker service scale webstack_web=4

# ✅ Verify the scaling operation
docker service ls

# 📋 Check the running containers
docker service ps webstack_web

# 👀 Monitor the scaling process
watch -n 2 'docker service ps webstack_web'
# Press Ctrl+C to exit the watch command after observing the scaling
```

### 🧩 Subtask 4.2: Scale Using Stack Update

```bash
# 📁 Navigate back to services directory
cd ~/docker-swarm-lab/services

# 📝 Create an updated stack file with different replica counts
cat > web-stack-scaled.yml << 'EOF'
version: '3.8'

services:
  web:
    image: nginx:alpine
    ports:
      - "8080:80"
    volumes:
      - web-content:/usr/share/nginx/html
    deploy:
      replicas: 6
      restart_policy:
        condition: on-failure
        delay: 5s
        max_attempts: 3
      update_config:
        parallelism: 2
        delay: 10s
      placement:
        constraints:
          - node.role == manager
    networks:
      - webnet

  redis:
    image: redis:alpine
    deploy:
      replicas: 2
      restart_policy:
        condition: on-failure
      placement:
        constraints:
          - node.role == manager
    networks:
      - webnet
    volumes:
      - redis-data:/data

volumes:
  web-content:
  redis-data:

networks:
  webnet:
    driver: overlay
EOF

# ♻️ Update the stack with new configuration
docker stack deploy -c web-stack-scaled.yml webstack

# 👀 Monitor the update process
docker service ps webstack_web
docker service ps webstack_redis
```

### 🧩 Subtask 4.3: Test Load Balancing

```bash
# 🔁 Test the web service multiple times to see load balancing
for i in {1..10}; do
  echo "Request $i:"
  curl -s http://localhost:8080 | grep -o '<title>.*</title>'
  sleep 1
done

# 📋 Check which containers are handling requests
docker service ps webstack_web --format "table {{.Name}}\t{{.Node}}\t{{.CurrentState}}"
```

### 🧩 Subtask 4.4: Scale Down Services

```bash
# 📉 Scale down the web service
docker service scale webstack_web=2

# 📉 Scale down redis service
docker service scale webstack_redis=1

# ✅ Verify the scaling down operation
docker service ls
docker service ps webstack_web
docker service ps webstack_redis
```

<!-- TODO: Scale webstack_web to 8 and time how long it takes for all replicas to reach Running -->

---

## 🚀 Task 5: Advanced Service Management

![Task Stack](https://img.shields.io/badge/Feature-Rolling%20Updates-1D63ED?style=flat-square&logo=docker&logoColor=white) ![Task Stack](https://img.shields.io/badge/Feature-Placement%20Constraints-1D63ED?style=flat-square&logo=docker&logoColor=white)

> 🚦 **Sign-in Step:** Zero-downtime rolling updates, node-label-based placement constraints, and hard CPU/memory limits — the controls that separate a toy deployment from a production-shaped one.

### 🧩 Subtask 5.1: Rolling Updates

```bash
# 📝 Create a new version of our web service with updated content
cat > ~/docker-swarm-lab/web-content/index-v2.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Docker Swarm Lab - Version 2</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background-color: #e8f5e8; }
        .container { background-color: white; padding: 20px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h1 { color: #4CAF50; }
        .info { background-color: #f1f8e9; padding: 15px; border-radius: 5px; margin: 10px 0; }
        .version { background-color: #4CAF50; color: white; padding: 5px 10px; border-radius: 3px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Welcome to Docker Swarm Lab <span class="version">v2.0</span></h1>
        <div class="info">
            <h3>Service Information:</h3>
            <p><strong>Container ID:</strong> <span id="hostname"></span></p>
            <p><strong>Service:</strong> Web Frontend (Updated)</p>
            <p><strong>Stack:</strong> web-stack</p>
            <p><strong>Lab:</strong> Docker Swarm Basics</p>
            <p><strong>Version:</strong> 2.0 - Rolling Update Demo</p>
        </div>
        <p>This is the updated version of our web service, demonstrating rolling updates in Docker Swarm.</p>
        <p>The update was performed with zero downtime using Docker Swarm's rolling update feature.</p>
    </div>
    <script>
        document.getElementById('hostname').textContent = window.location.hostname;
    </script>
</body>
</html>
EOF

# ♻️ Update the service with a new image tag (simulating an update)
docker service update --image nginx:latest webstack_web

# 👀 Monitor the rolling update
watch -n 2 'docker service ps webstack_web'
# Press Ctrl+C to exit after observing the update process
```

### 🧩 Subtask 5.2: Service Constraints and Placement

```bash
# 🏷️ Add labels to our node for placement constraints
docker node update --label-add environment=production $(docker node ls -q)
docker node update --label-add datacenter=primary $(docker node ls -q)

# 🎯 Create a service with specific placement constraints
docker service create \
  --name constrained-service \
  --replicas 2 \
  --constraint 'node.labels.environment==production' \
  --constraint 'node.labels.datacenter==primary' \
  nginx:alpine

# ✅ Verify the service placement
docker service ps constrained-service
```

### 🧩 Subtask 5.3: Service Resource Limits

```bash
# 🧮 Create a service with resource limits
docker service create \
  --name resource-limited \
  --replicas 1 \
  --limit-cpu 0.5 \
  --limit-memory 128M \
  --reserve-cpu 0.25 \
  --reserve-memory 64M \
  nginx:alpine

# 🔍 Inspect the service to see resource constraints
docker service inspect resource-limited --pretty
```

<!-- TODO: Lower resource-limited's memory limit to 32M and observe what happens to the task -->

---

## 📊 Task 6: Monitoring and Troubleshooting

![Task Stack](https://img.shields.io/badge/Tool-docker%20stats-2496ED?style=flat-square&logo=docker&logoColor=white) ![Task Stack](https://img.shields.io/badge/Feature-Healthchecks-2ECC71?style=flat-square&logo=docker&logoColor=white)

> 🚦 **Sign-in Step:** Wrapping monitoring and log collection into reusable scripts, then adding a proper `HEALTHCHECK` to a fresh stack — the observability layer a swarm needs to be trustworthy.

### 🧩 Subtask 6.1: Service Monitoring

```bash
# 📊 Create a monitoring script
cat > ~/docker-swarm-lab/monitor-services.sh << 'EOF'
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
EOF

# 🔓 Make the script executable
chmod +x ~/docker-swarm-lab/monitor-services.sh

# ▶️ Run the monitoring script
./monitor-services.sh
```

### 🧩 Subtask 6.2: Log Management

```bash
# 📝 Create a log collection script
cat > ~/docker-swarm-lab/collect-logs.sh << 'EOF'
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
EOF

# 🔓 Make the script executable and run it
chmod +x ~/docker-swarm-lab/collect-logs.sh
./collect-logs.sh
```

### 🧩 Subtask 6.3: Health Checks

```bash
# 🩺 Create a service with health checks
cat > ~/docker-swarm-lab/services/health-check-stack.yml << 'EOF'
version: '3.8'

services:
  web-with-health:
    image: nginx:alpine
    ports:
      - "8081:80"
    deploy:
      replicas: 2
      restart_policy:
        condition: on-failure
    healthcheck:
      test: ["CMD", "wget", "--quiet", "--tries=1", "--spider", "http://localhost/"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
    networks:
      - healthnet

networks:
  healthnet:
    driver: overlay
EOF

# 🚀 Deploy the health check stack
docker stack deploy -c health-check-stack.yml healthstack

# 👀 Monitor health status
docker service ps healthstack_web-with-health
```

<!-- TODO: Force a health-check failure (e.g. rename the wget binary in a custom image) and watch Swarm reschedule the task -->

---

## 🧹 Task 7: Cleanup and Stack Management

![Task Stack](https://img.shields.io/badge/Focus-Resource%20Teardown-D93F3F?style=flat-square&logo=docker&logoColor=white)

> 🚦 **Sign-in Step:** Removing stacks and standalone services, pruning unused volumes/networks/images, and finally leaving swarm mode entirely to return to a plain Docker engine.

### 🧩 Subtask 7.1: Remove Services and Stacks

```bash
# 📋 List all stacks
docker stack ls

# 🗑️ Remove individual stacks
docker stack rm webstack
docker stack rm healthstack

# 🗑️ Remove individual services
docker service rm constrained-service
docker service rm resource-limited

# ✅ Verify removal
docker service ls
docker stack ls
```

### 🧩 Subtask 7.2: Clean Up Resources

```bash
# 🗑️ Remove unused volumes
docker volume prune -f

# 🗑️ Remove unused networks
docker network prune -f

# 🗑️ Remove unused images
docker image prune -f

# 📏 Check remaining resources
docker system df
```

### 🧩 Subtask 7.3: Leave Swarm Mode

```bash
# 🚪 Leave swarm mode (this will destroy the swarm)
docker swarm leave --force

# ✅ Verify swarm is disabled
docker info | grep -A 5 "Swarm:"
```

<!-- TODO: Re-run `docker swarm init` and confirm you get a fresh, empty swarm -->

---

## 🩹 Troubleshooting Common Issues

<details>
<summary>🔴 Issue 1: Service Not Starting</summary>

```bash
# 🔎 Check service status
docker service ps <service-name>

# 📜 Check service logs
docker service logs <service-name>

# 🔍 Inspect service configuration
docker service inspect <service-name> --pretty
```

</details>

<details>
<summary>🔴 Issue 2: Port Conflicts</summary>

```bash
# 🔎 Check which ports are in use
netstat -tlnp | grep :8080

# 🛠️ Use different ports in your stack files
# Modify the ports section in your YAML files
```

</details>

<details>
<summary>🔴 Issue 3: Resource Constraints</summary>

```bash
# 📏 Check system resources
free -h
df -h

# 📊 Monitor container resource usage
docker stats

# 🛠️ Adjust resource limits in service definitions
```

</details>

---

## 📌 Key Concepts Summary

| Concept | Definition |
|---|---|
| **Docker Swarm** | A native clustering and orchestration solution for Docker containers |
| **Stack** | A collection of services that make up an application in a distributed system |
| **Service** | A definition of tasks to execute on the manager or worker nodes |
| **Replica** | An instance of a service running on a swarm node |
| **Overlay Network** | A distributed network among multiple Docker daemon hosts |
| **Rolling Update** | A deployment strategy that updates services with zero downtime |

---

## 🏁 Conclusion

In this lab, you have successfully:

### ✅ Key Accomplishments

- 🐳 Installed and configured Docker on a Linux system and initialized a Docker Swarm cluster
- 🧱 Created and deployed multi-container applications using Docker Stack with YAML configuration files
- 📈 Scaled services dynamically both up and down using Docker Swarm's orchestration capabilities
- 🚀 Implemented advanced service management including rolling updates, placement constraints, and resource limits
- 📊 Monitored and troubleshot services using Docker's built-in tools and custom scripts
- ♻️ Managed the complete lifecycle of containerized applications in a swarm environment

### 🌍 Why This Matters

Docker Swarm provides a powerful yet simple orchestration platform that enables you to manage containerized applications at scale. The skills you've learned here are fundamental for:

- 🏭 **Production Deployments** — managing real-world applications with high availability requirements
- 🔁 **DevOps Practices** — implementing continuous deployment and infrastructure as code
- 📈 **Scalability** — handling varying loads by dynamically adjusting service replicas
- 🛡️ **Reliability** — ensuring applications remain available even when individual containers fail
- 🧮 **Resource Management** — optimizing resource utilization across your infrastructure

These Docker Swarm fundamentals prepare you for more advanced orchestration platforms like Kubernetes while providing a solid foundation in container orchestration concepts. The hands-on experience with service scaling, rolling updates, and monitoring will be valuable in any containerized environment.

---

<div align="center">

![Al Nafi](https://img.shields.io/badge/Al%20Nafi-Cybersecurity%20Training-1E3A8A?style=for-the-badge)

</div>
