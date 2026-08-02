<div align="center">

# 🌐 Docker Networking

### Bridge, Host, and Overlay Networks — Container Communication and Port Exposure

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Docker Swarm](https://img.shields.io/badge/Docker_Swarm-1E5DA8?style=for-the-badge&logo=docker&logoColor=white)
![Nginx](https://img.shields.io/badge/Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)
![Redis](https://img.shields.io/badge/Redis-DC382D?style=for-the-badge&logo=redis&logoColor=white)
![Flask](https://img.shields.io/badge/Flask-000000?style=for-the-badge&logo=flask&logoColor=white)

![Level](https://img.shields.io/badge/Level-Intermediate-blue?style=for-the-badge)
![Duration](https://img.shields.io/badge/Duration-150_min-orange?style=for-the-badge)
![Platform](https://img.shields.io/badge/Platform-Al_Nafi_Cloud_Labs-6A0DAD?style=for-the-badge)

</div>

---

## 📑 Table of Contents

- [🎯 Learning Objectives](#-learning-objectives)
- [📋 Prerequisites](#-prerequisites)
- [🖥️ Lab Environment Setup](#️-lab-environment-setup)
- [🔧 Task 1: Environment Preparation and Docker Installation](#-task-1-environment-preparation-and-docker-installation)
- [🔍 Task 2: Exploring Docker Network Types](#-task-2-exploring-docker-network-types)
- [🌉 Task 3: Working with Bridge Networks](#-task-3-working-with-bridge-networks)
- [🖧 Task 4: Host Network Configuration](#-task-4-host-network-configuration)
- [🕸️ Task 5: Overlay Network Setup](#️-task-5-overlay-network-setup)
- [🔌 Task 6: Port Exposure and External Access](#-task-6-port-exposure-and-external-access)
- [📡 Task 7: Advanced Container Communication](#-task-7-advanced-container-communication)
- [🔒 Task 8: Network Security and Isolation](#-task-8-network-security-and-isolation)
- [🛠️ Troubleshooting Common Issues](#️-troubleshooting-common-issues)
- [📚 Key Concepts](#-key-concepts)
- [✅ Conclusion](#-conclusion)

---

## 🎯 Learning Objectives

By the end of this lab, students will be able to:

| # | Objective |
|---|-----------|
| 1 | Understand different Docker network types and their use cases |
| 2 | Create and manage containers on bridge, host, and overlay networks |
| 3 | Configure port mapping for external access to containerized applications |
| 4 | Implement container-to-container communication using DNS-based resolution |
| 5 | Troubleshoot common Docker networking issues |
| 6 | Apply networking best practices for containerized applications |

---

## 📋 Prerequisites

| Requirement | Details |
|---|---|
| 🐧 Linux CLI | Basic understanding of Linux command line operations |
| 🐳 Docker Fundamentals | Familiarity with Docker fundamentals (containers, images, basic commands) |
| 🌐 Networking Concepts | Knowledge of networking concepts (IP addresses, ports, DNS) |
| 🖥️ Web Applications | Understanding of web applications and HTTP protocols |

---

## 🖥️ Lab Environment Setup

> **📝 Al Nafi Cloud Machine:** This lab uses Al Nafi's Linux-based cloud machines. Simply click **Start Lab** to access your dedicated Linux environment. The provided machine is bare metal with no pre-installed tools, so you will install Docker and other required tools during the lab.

> **⚠️ Important Note:** All tasks in this lab will be performed on a single Linux machine. No additional machines or remote hosts are required.

---

## 🔧 Task 1: Environment Preparation and Docker Installation

![Docker](https://img.shields.io/badge/Docker_Engine-2496ED?style=flat-square&logo=docker&logoColor=white) ![Compose](https://img.shields.io/badge/Docker_Compose-2496ED?style=flat-square&logo=docker&logoColor=white)

> 🔖 **Step Sign:** *Before you can network containers together, you need the engine and its companion tooling installed and verified.*

### ⚙️ Subtask 1.1: Install Docker

First, we need to install Docker on our Linux machine.

```bash
# 📥 Update the package index
sudo apt update

# 📦 Install required packages
sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release

# 🔑 Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# 📚 Add Docker repository
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 📥 Update package index again
sudo apt update

# 🐳 Install Docker Engine
sudo apt install -y docker-ce docker-ce-cli containerd.io

# 👤 Add current user to docker group
sudo usermod -aG docker $USER

# ▶️ Start and enable Docker service
sudo systemctl start docker
sudo systemctl enable docker
```

### ✅ Subtask 1.2: Verify Docker Installation

```bash
# 🔄 Log out and log back in, or use newgrp to apply group changes
newgrp docker

# 🏷️ Verify Docker installation
docker --version
docker info

# 🎉 Test Docker with hello-world container
docker run hello-world
```

### 🧰 Subtask 1.3: Install Additional Tools

```bash
# 🌐 Install network utilities for testing
sudo apt install -y net-tools curl wget

# 🔗 Install Docker Compose (for overlay network demonstration)
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# ✅ Verify installation
docker-compose --version
```

---

## 🔍 Task 2: Exploring Docker Network Types

![Docker](https://img.shields.io/badge/Bridge_Network-2496ED?style=flat-square&logo=docker&logoColor=white)

> 🔖 **Step Sign:** *Docker ships with default networks out of the box — inspect them first, then build your own on top.*

### 🌉 Subtask 2.1: Understanding Default Networks

Docker creates several default networks. Let's explore them:

```bash
# 📋 List all Docker networks
docker network ls

# 🔍 Inspect the default bridge network
docker network inspect bridge

# 🖧 Check network configuration on the host
ip addr show docker0
```

> 💡 **Key Concept:** The bridge network is Docker's default network driver. Containers on the same bridge network can communicate with each other using IP addresses.

### 🆕 Subtask 2.2: Create Custom Bridge Network

```bash
# 🆕 Create a custom bridge network
docker network create --driver bridge my-bridge-network

# 🔍 Inspect the custom network
docker network inspect my-bridge-network

# 📋 List networks to see the new network
docker network ls
```

---

## 🌉 Task 3: Working with Bridge Networks

![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=flat-square&logo=mysql&logoColor=white) ![Nginx](https://img.shields.io/badge/Nginx-009639?style=flat-square&logo=nginx&logoColor=white)

> 🔖 **Step Sign:** *Two containers, one custom network — this is where Docker's built-in DNS starts doing the real work.*

### 🚀 Subtask 3.1: Deploy Containers on Bridge Network

Let's create a simple web application scenario with a web server and a database:

```bash
# 🆕 Create a custom bridge network for our application
docker network create --driver bridge app-network

# 🗄️ Run a MySQL database container
docker run -d \
  --name mysql-db \
  --network app-network \
  -e MYSQL_ROOT_PASSWORD=rootpassword \
  -e MYSQL_DATABASE=testdb \
  -e MYSQL_USER=testuser \
  -e MYSQL_PASSWORD=testpass \
  mysql:8.0

# 🌐 Run a simple web application (nginx) container
docker run -d \
  --name web-app \
  --network app-network \
  -p 8080:80 \
  nginx:latest

# ✅ Verify containers are running
docker ps
```

### 📡 Subtask 3.2: Test Container-to-Container Communication

```bash
# 🏓 Test communication from web-app to mysql-db using container name
docker exec -it web-app ping mysql-db

# 📦 Install mysql client in the web-app container for testing
docker exec -it web-app apt update
docker exec -it web-app apt install -y mysql-client

# 🔌 Test database connection using DNS name
docker exec -it web-app mysql -h mysql-db -u testuser -ptestpass -e "SHOW DATABASES;"
```

> 💡 **Key Concept:** Containers on the same custom bridge network can communicate using container names as hostnames through Docker's built-in DNS resolution.

### 🔬 Subtask 3.3: Inspect Network Details

```bash
# 🔍 Check which containers are connected to the network
docker network inspect app-network

# ⚙️ View container network settings
docker inspect web-app | grep -A 20 "NetworkSettings"

# 🔌 Check port mappings
docker port web-app
```

---

## 🖧 Task 4: Host Network Configuration

![Docker](https://img.shields.io/badge/Host_Network-2496ED?style=flat-square&logo=docker&logoColor=white)

> 🔖 **Step Sign:** *No isolation, no port mapping — the container borrows the host's network stack directly.*

### 🚀 Subtask 4.1: Deploy Container with Host Network

The host network removes network isolation between the container and the Docker host.

```bash
# ▶️ Run a container using host network
docker run -d \
  --name host-web \
  --network host \
  nginx:latest

# 🌐 Check if the container is accessible directly on host ports
curl http://localhost:80

# ⚖️ Compare with bridge network container
curl http://localhost:8080
```

### 🔬 Subtask 4.2: Analyze Host Network Behavior

```bash
# 🔍 Inspect host network
docker network inspect host

# 🧵 Check container processes and ports
docker exec -it host-web netstat -tlnp

# ⚖️ Compare with bridge network container
docker exec -it web-app netstat -tlnp
```

> **⚠️ Important Note:** In host network mode, the container shares the host's network stack. Port mapping (`-p`) is not needed and not allowed.

---

## 🕸️ Task 5: Overlay Network Setup

![Docker Swarm](https://img.shields.io/badge/Docker_Swarm-1E5DA8?style=flat-square&logo=docker&logoColor=white) ![Alpine](https://img.shields.io/badge/Alpine-0D597F?style=flat-square&logo=alpinelinux&logoColor=white)

> 🔖 **Step Sign:** *Scale beyond a single host — overlay networks are the fabric that lets Swarm services talk across nodes.*

### 🐝 Subtask 5.1: Initialize Docker Swarm

Overlay networks require Docker Swarm mode:

```bash
# 🐝 Initialize Docker Swarm (single-node cluster)
docker swarm init

# ✅ Verify swarm status
docker node ls

# 📋 Check available networks (overlay networks will appear)
docker network ls
```

### 🆕 Subtask 5.2: Create Overlay Network

```bash
# 🆕 Create an overlay network
docker network create \
  --driver overlay \
  --attachable \
  my-overlay-network

# 🔍 Inspect the overlay network
docker network inspect my-overlay-network

# 📋 List all networks
docker network ls
```

### 🚀 Subtask 5.3: Deploy Services on Overlay Network

```bash
# 🌐 Create a service using the overlay network
docker service create \
  --name overlay-web \
  --network my-overlay-network \
  --publish 9090:80 \
  --replicas 2 \
  nginx:latest

# 🏔️ Create another service for testing communication
docker service create \
  --name overlay-app \
  --network my-overlay-network \
  --replicas 1 \
  alpine:latest \
  sleep 3600

# ✅ Check service status
docker service ls
docker service ps overlay-web
docker service ps overlay-app
```

### 📡 Subtask 5.4: Test Overlay Network Communication

```bash
# 🆔 Get container IDs for overlay-app service
CONTAINER_ID=$(docker ps --filter "name=overlay-app" --format "{{.ID}}")

# 🏓 Test communication between services using service names
docker exec -it $CONTAINER_ID ping overlay-web

# 📦 Install curl for HTTP testing
docker exec -it $CONTAINER_ID apk add --no-cache curl

# 🌐 Test HTTP communication
docker exec -it $CONTAINER_ID curl http://overlay-web:80
```

---

## 🔌 Task 6: Port Exposure and External Access

![Docker](https://img.shields.io/badge/Port_Mapping-2496ED?style=flat-square&logo=docker&logoColor=white) ![Nginx](https://img.shields.io/badge/Nginx-009639?style=flat-square&logo=nginx&logoColor=white)

> 🔖 **Step Sign:** *From a single mapped port to dynamic assignment — every way traffic gets from the outside world into a container.*

### 🔎 Subtask 6.1: Understanding Port Mapping

```bash
# 📝 Create a simple web server with custom content
mkdir -p /tmp/webdata
echo "<h1>Hello from Docker Container!</h1><p>Container: $(hostname)</p>" > /tmp/webdata/index.html

# ▶️ Run container with port mapping
docker run -d \
  --name port-demo \
  --network bridge \
  -p 8081:80 \
  -v /tmp/webdata:/usr/share/nginx/html \
  nginx:latest

# 🌐 Test external access
curl http://localhost:8081

# 🔌 Check port mapping details
docker port port-demo
netstat -tlnp | grep 8081
```

### 🔀 Subtask 6.2: Multiple Port Mappings

```bash
# ▶️ Run a container with multiple port mappings
docker run -d \
  --name multi-port-app \
  -p 8082:80 \
  -p 8443:443 \
  -p 9000:9000 \
  nginx:latest

# ✅ Verify all port mappings
docker port multi-port-app

# 🌐 Test accessibility
curl http://localhost:8082
```

### 🎲 Subtask 6.3: Dynamic Port Assignment

```bash
# ▶️ Run container with dynamic port assignment
docker run -d \
  --name dynamic-port \
  -P \
  nginx:latest

# 🔌 Check assigned ports
docker port dynamic-port

# 🎯 Get the assigned port and test
ASSIGNED_PORT=$(docker port dynamic-port 80 | cut -d: -f2)
curl http://localhost:$ASSIGNED_PORT
```

---

## 📡 Task 7: Advanced Container Communication

![Flask](https://img.shields.io/badge/Flask-000000?style=flat-square&logo=flask&logoColor=white) ![Redis](https://img.shields.io/badge/Redis-DC382D?style=flat-square&logo=redis&logoColor=white) ![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=flat-square&logo=postgresql&logoColor=white)

> 🔖 **Step Sign:** *A real application stack — cache, database, and web app, all finding each other purely by name.*

### 🏗️ Subtask 7.1: Multi-Container Application Setup

Let's create a complete application stack with DNS-based communication:

```bash
# 🆕 Create application network
docker network create --driver bridge fullstack-network

# 🔴 Deploy Redis cache
docker run -d \
  --name redis-cache \
  --network fullstack-network \
  redis:alpine

# 🐘 Deploy PostgreSQL database
docker run -d \
  --name postgres-db \
  --network fullstack-network \
  -e POSTGRES_DB=appdb \
  -e POSTGRES_USER=appuser \
  -e POSTGRES_PASSWORD=apppass \
  postgres:13
```

```python
# 🐍 Deploy a simple Python web application
from flask import Flask, jsonify
import redis
import psycopg2
import os

app = Flask(__name__)

@app.route('/')
def hello():
    return jsonify({
        "message": "Hello from Flask!",
        "redis_status": test_redis(),
        "postgres_status": test_postgres()
    })

def test_redis():
    try:
        r = redis.Redis(host='redis-cache', port=6379, decode_responses=True)
        r.set('test', 'connection_ok')
        return r.get('test')
    except Exception as e:
        return f"Error: {str(e)}"

def test_postgres():
    try:
        conn = psycopg2.connect(
            host='postgres-db',
            database='appdb',
            user='appuser',
            password='apppass'
        )
        cur = conn.cursor()
        cur.execute('SELECT version()')
        version = cur.fetchone()[0]
        conn.close()
        return "Connected successfully"
    except Exception as e:
        return f"Error: {str(e)}"

# TODO: Add a /health route for container health checks, similar to Task 3 in prior labs

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
```

```bash
# 💾 Save the app above as /tmp/app.py before continuing
```

```dockerfile
# 🐍 Create Dockerfile for the Python app
FROM python:3.9-slim
WORKDIR /app
RUN pip install flask redis psycopg2-binary
COPY app.py .
EXPOSE 5000
CMD ["python", "app.py"]
```

```bash
# 🔨 Build the application image
docker build -t flask-app /tmp/

# 🚀 Deploy the Flask application
docker run -d \
  --name flask-web \
  --network fullstack-network \
  -p 5000:5000 \
  flask-app
```

### 🧪 Subtask 7.2: Test Multi-Container Communication

```bash
# ⏳ Wait for containers to start
sleep 10

# 🌐 Test the application
curl http://localhost:5000

# 📜 Check container logs
docker logs flask-web

# 🏓 Test individual service connectivity
docker exec -it flask-web ping redis-cache
docker exec -it flask-web ping postgres-db
```

### 🕵️ Subtask 7.3: Network Troubleshooting

```bash
# 🔍 Check network connectivity details
docker network inspect fullstack-network

# 🌐 Test DNS resolution from within containers
docker exec -it flask-web nslookup redis-cache
docker exec -it flask-web nslookup postgres-db

# 🧵 Check listening ports in containers
docker exec -it redis-cache netstat -tlnp
docker exec -it postgres-db netstat -tlnp
```

---

## 🔒 Task 8: Network Security and Isolation

![Docker](https://img.shields.io/badge/Network_Isolation-2496ED?style=flat-square&logo=docker&logoColor=white) ![Alpine](https://img.shields.io/badge/Alpine-0D597F?style=flat-square&logo=alpinelinux&logoColor=white)

> 🔖 **Step Sign:** *Isolation is a feature, not a bug — prove it by watching two containers fail to reach each other until you connect them.*

### 🧱 Subtask 8.1: Network Isolation Testing

```bash
# 🆕 Create two isolated networks
docker network create isolated-network-1
docker network create isolated-network-2

# 🚀 Deploy containers on different networks
docker run -d --name app1 --network isolated-network-1 alpine:latest sleep 3600
docker run -d --name app2 --network isolated-network-2 alpine:latest sleep 3600

# ❌ Test isolation (this should fail)
docker exec -it app1 ping app2

# 🔗 Connect app1 to the second network
docker network connect isolated-network-2 app1

# ✅ Now test communication (this should work)
docker exec -it app1 ping app2
```

### 🧹 Subtask 8.2: Network Cleanup and Management

```bash
# 📋 List all containers and their networks
docker ps --format "table {{.Names}}\t{{.Networks}}"

# ⏹️ Remove containers
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)

# 🗑️ Remove custom networks
docker network rm isolated-network-1 isolated-network-2 fullstack-network app-network my-bridge-network

# 🧹 Clean up Docker Swarm (if needed)
docker service rm overlay-web overlay-app
docker network rm my-overlay-network
docker swarm leave --force

# ✅ Verify cleanup
docker network ls
```

---

## 🛠️ Troubleshooting Common Issues

<details>
<summary>🔴 Issue 1: Container Cannot Resolve DNS Names</summary>

**Problem:** Container cannot ping other containers by name.

**Solution:**

```bash
# Check if containers are on the same network
docker network inspect <network-name>

# Ensure using custom bridge network (not default bridge)
docker network create my-network
docker run --network my-network <image>
```

</details>

<details>
<summary>🔴 Issue 2: Port Already in Use</summary>

**Problem:** Error binding port when starting container.

**Solution:**

```bash
# Check what's using the port
sudo netstat -tlnp | grep <port-number>

# Use a different port or stop the conflicting service
docker run -p <different-port>:80 <image>
```

</details>

<details>
<summary>🔴 Issue 3: Overlay Network Not Working</summary>

**Problem:** Services cannot communicate on overlay network.

**Solution:**

```bash
# Ensure Docker Swarm is initialized
docker swarm init

# Make overlay network attachable
docker network create --driver overlay --attachable <network-name>
```

</details>

---

## 📚 Key Concepts

| Concept | Description |
|---|---|
| 🌉 **Bridge Network** | Docker's default network driver; containers communicate via IP or (on custom bridges) container-name DNS |
| 🖧 **Host Network** | Removes network isolation — the container shares the host's network stack directly, no port mapping |
| 🕸️ **Overlay Network** | Spans multiple Docker hosts via Swarm, enabling multi-node service communication |
| 🔌 **Port Mapping (`-p` / `-P`)** | Exposes container ports to the host, either explicitly or via dynamic assignment |
| 📡 **DNS-Based Service Discovery** | Custom networks let containers resolve each other by name, not just IP |
| 🔒 **Network Isolation** | Containers on different networks can't reach each other unless explicitly connected |
| 🐝 **Docker Swarm** | Orchestration mode required to create and use overlay networks |

---

## ✅ Conclusion

### 🏆 What You Accomplished

In this comprehensive Docker networking lab, you have successfully:

- ✅ Installed and configured Docker on a Linux system from scratch
- ✅ Explored different network types: bridge, host, and overlay networks
- ✅ Created custom bridge networks for container isolation and communication
- ✅ Implemented port mapping for external access to containerized applications
- ✅ Set up container-to-container communication using DNS-based resolution
- ✅ Deployed multi-container applications with proper network architecture
- ✅ Configured overlay networks using Docker Swarm for distributed applications
- ✅ Applied network security principles through isolation and controlled connectivity

### 🌍 Why This Matters

Docker networking is fundamental to building scalable, secure containerized applications. The skills you've learned enable you to:

- 🏗️ Design robust microservices architectures where services communicate reliably
- 🔐 Implement proper security boundaries between application components
- 📈 Scale applications across multiple hosts using overlay networks
- 🐞 Troubleshoot connectivity issues in containerized environments
- ⚙️ Apply DevOps best practices for container orchestration and deployment

### 🚀 Real-World Applications

These networking concepts are essential for:

- 🧩 Microservices deployments in production environments
- ☸️ Container orchestration with Kubernetes and Docker Swarm
- 🔁 CI/CD pipelines that require isolated testing environments
- ☁️ Cloud-native application development with proper service discovery
- 🏢 Enterprise container strategies with security and compliance requirements

The hands-on experience gained in this lab provides a solid foundation for advanced container orchestration platforms and cloud-native development practices.

---

<div align="center">

![Al Nafi](https://img.shields.io/badge/Al_Nafi-Cybersecurity_Training-6A0DAD?style=for-the-badge)

</div>
