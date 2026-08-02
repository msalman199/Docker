<div align="center">

# 📦 Docker Images and Containers

### Building, Inspecting, and Managing Custom Docker Images and Container Lifecycles

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Go](https://img.shields.io/badge/Go-00ADD8?style=for-the-badge&logo=go&logoColor=white)
![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![Alpine](https://img.shields.io/badge/Alpine_Linux-0D597F?style=for-the-badge&logo=alpinelinux&logoColor=white)

![Level](https://img.shields.io/badge/Level-Beginner--Intermediate-blue?style=for-the-badge)
![Duration](https://img.shields.io/badge/Duration-120_min-orange?style=for-the-badge)
![Platform](https://img.shields.io/badge/Platform-Al_Nafi_Cloud_Labs-6A0DAD?style=for-the-badge)

</div>

---

## 📑 Table of Contents

- [🎯 Learning Objectives](#-learning-objectives)
- [📋 Prerequisites](#-prerequisites)
- [🖥️ Lab Environment](#️-lab-environment)
- [🔧 Task 1: Environment Setup and Docker Installation](#-task-1-environment-setup-and-docker-installation)
- [🔍 Task 2: Inspect Images with docker images](#-task-2-inspect-images-with-docker-images)
- [🏗️ Task 3: Create Custom Images Using a Dockerfile](#️-task-3-create-custom-images-using-a-dockerfile)
- [🚀 Task 4: Run Containers from Custom Images](#-task-4-run-containers-from-custom-images)
- [🧬 Task 5: Experiment with docker commit and docker diff](#-task-5-experiment-with-docker-commit-and-docker-diff)
- [🔄 Task 6: Container Lifecycle Management](#-task-6-container-lifecycle-management)
- [🛠️ Troubleshooting Tips](#️-troubleshooting-tips)
- [📚 Key Concepts Mastered](#-key-concepts-mastered)
- [✅ Conclusion](#-conclusion)

---

## 🎯 Learning Objectives

By the end of this lab, students will be able to:

| # | Objective |
|---|-----------|
| 1 | Understand the difference between Docker images and containers |
| 2 | Inspect and analyze Docker images using command-line tools |
| 3 | Create custom Docker images using Dockerfiles |
| 4 | Build and run containers from custom images |
| 5 | Use `docker commit` to create images from running containers |
| 6 | Analyze container changes using `docker diff` |
| 7 | Manage Docker images and containers effectively |

---

## 📋 Prerequisites

| Requirement | Details |
|---|---|
| 🐧 Linux CLI | Basic understanding of Linux command line operations |
| 📝 Text Editors | Familiarity with text editors (nano, vim, or similar) |
| 📦 Containerization | Basic knowledge of containerization concepts |
| 🗂️ File Systems | Understanding of file systems and directory structures |

---

## 🖥️ Lab Environment

> **📝 Note:** Al Nafi provides Linux-based cloud machines for this lab. Simply click **Start Lab** to access your dedicated Linux machine. The provided machine is bare metal with no pre-installed tools, so you will install Docker and other required tools during the lab exercises.

---

## 🔧 Task 1: Environment Setup and Docker Installation

![Docker](https://img.shields.io/badge/Docker_Engine-2496ED?style=flat-square&logo=docker&logoColor=white) ![APT](https://img.shields.io/badge/APT-E95420?style=flat-square&logo=ubuntu&logoColor=white) ![Systemd](https://img.shields.io/badge/systemd-000000?style=flat-square)

> 🔖 **Step Sign:** *First, get the engine running — everything else in this lab depends on a healthy Docker installation.*

### ⚙️ Subtask 1.1: Update System and Install Docker

First, we need to install Docker on our Linux machine.

```bash
# 📥 Update package index
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
# 🏷️ Check Docker version
docker --version

# 🎉 Test Docker installation
sudo docker run hello-world
```

> **📝 Note:** You may need to log out and log back in for group changes to take effect, or use `newgrp docker` to refresh group membership.

---

## 🔍 Task 2: Inspect Images with docker images

![Docker](https://img.shields.io/badge/Docker_Images-2496ED?style=flat-square&logo=docker&logoColor=white) ![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=flat-square&logo=ubuntu&logoColor=white) ![Nginx](https://img.shields.io/badge/Nginx-009639?style=flat-square&logo=nginx&logoColor=white) ![Python](https://img.shields.io/badge/Python-3776AB?style=flat-square&logo=python&logoColor=white) ![Alpine](https://img.shields.io/badge/Alpine-0D597F?style=flat-square&logo=alpinelinux&logoColor=white)

> 🔖 **Step Sign:** *Images are the read-only blueprints — before you build your own, learn to read the ones that already exist.*

### ⬇️ Subtask 2.1: Pull Sample Images

Let's start by pulling some sample images to work with:

```bash
# 🐧 Pull different versions of Ubuntu images
docker pull ubuntu:20.04
docker pull ubuntu:22.04
docker pull ubuntu:latest

# 📦 Pull other popular images
docker pull nginx:latest
docker pull python:3.9-slim
docker pull alpine:latest
```

### 📋 Subtask 2.2: List and Inspect Images

```bash
# 📋 List all images
docker images

# 🔎 List images with more details
docker images --no-trunc

# 🆔 List only image IDs
docker images -q

# 🔍 Filter images by repository
docker images ubuntu

# 📊 Show image sizes in human readable format
docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"
```

### 🔬 Subtask 2.3: Detailed Image Inspection

```bash
# 🔍 Inspect a specific image in detail
docker inspect ubuntu:20.04

# 🎯 Get specific information using format
docker inspect --format='{{.Architecture}}' ubuntu:20.04
docker inspect --format='{{.Os}}' ubuntu:20.04
docker inspect --format='{{.Size}}' ubuntu:20.04

# 📜 View image history (layers)
docker history ubuntu:20.04

# 📜 Show image layers in detail
docker history --no-trunc ubuntu:20.04
```

### 📈 Subtask 2.4: Image Analysis Exercise

Create a script to analyze image information:

```bash
# 📝 Create analysis script
cat > analyze_images.sh << 'EOF'
#!/bin/bash

echo "=== Docker Image Analysis ==="
echo

for image in $(docker images --format "{{.Repository}}:{{.Tag}}" | grep -v "<none>"); do
    echo "Image: $image"
    echo "  Size: $(docker images --format "{{.Size}}" $image)"
    echo "  Created: $(docker inspect --format='{{.Created}}' $image)"
    echo "  Architecture: $(docker inspect --format='{{.Architecture}}' $image)"
    echo "  Layers: $(docker history $image --quiet | wc -l)"
    echo "---"
done
EOF

# ⚙️ Make script executable and run it
chmod +x analyze_images.sh
./analyze_images.sh
```

---

## 🏗️ Task 3: Create Custom Images Using a Dockerfile

![Docker](https://img.shields.io/badge/Dockerfile-2496ED?style=flat-square&logo=docker&logoColor=white) ![Python](https://img.shields.io/badge/Python-3776AB?style=flat-square&logo=python&logoColor=white) ![Go](https://img.shields.io/badge/Go-00ADD8?style=flat-square&logo=go&logoColor=white) ![Alpine](https://img.shields.io/badge/Alpine-0D597F?style=flat-square&logo=alpinelinux&logoColor=white)

> 🔖 **Step Sign:** *This is where you go from consumer to builder — writing the recipe that turns source code into a runnable image.*

### 🌐 Subtask 3.1: Create a Simple Web Application

First, let's create a simple web application:

```bash
# 📁 Create project directory
mkdir -p ~/docker-lab/webapp
cd ~/docker-lab/webapp
```

```html
<!-- 📝 Create a simple HTML file -->
<!DOCTYPE html>
<html>
<head>
    <title>My Custom Docker App</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background-color: #f0f0f0; }
        .container { background-color: white; padding: 20px; border-radius: 10px; }
        h1 { color: #333; }
        .info { background-color: #e7f3ff; padding: 10px; border-radius: 5px; margin: 10px 0; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Welcome to My Custom Docker Application</h1>
        <div class="info">
            <p><strong>Container ID:</strong> <span id="hostname"></span></p>
            <p><strong>Current Time:</strong> <span id="time"></span></p>
            <p><strong>Lab:</strong> Docker Images and Containers</p>
        </div>
        <p>This application is running inside a Docker container built from a custom image!</p>
    </div>

    <script>
        document.getElementById('hostname').textContent = window.location.hostname;
        document.getElementById('time').textContent = new Date().toLocaleString();
    </script>
</body>
</html>
```

```python
# 🐍 Create a simple Python web server script
#!/usr/bin/env python3
import http.server
import socketserver
import os
from datetime import datetime

class CustomHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/':
            self.path = '/index.html'
        elif self.path == '/health':
            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.end_headers()
            response = f'{{"status": "healthy", "timestamp": "{datetime.now().isoformat()}", "hostname": "{os.uname().nodename}"}}'
            self.wfile.write(response.encode())
            return
        return http.server.SimpleHTTPRequestHandler.do_GET(self)

# TODO: Customize PORT or add more routes (e.g. /version, /metrics) to this handler

PORT = int(os.environ.get('PORT', 8080))
Handler = CustomHandler

with socketserver.TCPServer(("", PORT), Handler) as httpd:
    print(f"Server running at http://localhost:{PORT}")
    print(f"Health check available at http://localhost:{PORT}/health")
    httpd.serve_forever()
```

```bash
chmod +x app.py
```

### 📄 Subtask 3.2: Create Your First Dockerfile

```dockerfile
# 🐍 Use Python slim image as base
FROM python:3.9-slim

# 🏷️ Set metadata
LABEL maintainer="student@example.com"
LABEL description="Custom web application for Docker lab"
LABEL version="1.0"

# TODO: Update the maintainer label with your own name/email

# 📂 Set working directory
WORKDIR /app

# 📋 Copy application files
COPY index.html .
COPY app.py .

# 👤 Create a non-root user for security
RUN groupadd -r appuser && useradd -r -g appuser appuser
RUN chown -R appuser:appuser /app
USER appuser

# 🔌 Expose port
EXPOSE 8080

# 🌎 Set environment variables
ENV PORT=8080
ENV PYTHONUNBUFFERED=1

# ❤️ Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD python3 -c "import urllib.request; urllib.request.urlopen('http://localhost:8080/health')"

# ▶️ Run the application
CMD ["python3", "app.py"]
```

### 🔨 Subtask 3.3: Build Your Custom Image

```bash
# 🏗️ Build the image with a tag
docker build -t my-webapp:v1.0 .

# 🏷️ Build with additional tags
docker build -t my-webapp:latest -t my-webapp:v1.0 .

# 📜 View build history
docker history my-webapp:v1.0

# 🔍 Inspect the custom image
docker inspect my-webapp:v1.0
```

### 🧱 Subtask 3.4: Create a Multi-Stage Dockerfile

Let's create a more advanced Dockerfile using multi-stage builds:

```bash
# 📁 Create a new directory for multi-stage example
mkdir -p ~/docker-lab/multistage
cd ~/docker-lab/multistage
```

```go
// 🐹 Create a simple Go application
package main

import (
    "fmt"
    "log"
    "net/http"
    "os"
    "time"
)

func main() {
    port := os.Getenv("PORT")
    if port == "" {
        port = "8080"
    }

    http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
        hostname, _ := os.Hostname()
        fmt.Fprintf(w, `
<!DOCTYPE html>
<html>
<head><title>Multi-Stage Docker Build</title></head>
<body>
    <h1>Multi-Stage Build Example</h1>
    <p>Hostname: %s</p>
    <p>Time: %s</p>
    <p>This is a Go application built using multi-stage Docker build!</p>
</body>
</html>`, hostname, time.Now().Format(time.RFC3339))
    })

    http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
        w.Header().Set("Content-Type", "application/json")
        fmt.Fprintf(w, `{"status":"healthy","timestamp":"%s"}`, time.Now().Format(time.RFC3339))
    })

    log.Printf("Server starting on port %s", port)
    log.Fatal(http.ListenAndServe(":"+port, nil))
}
```

```dockerfile
# 🏗️ Build stage
FROM golang:1.19-alpine AS builder

WORKDIR /app
COPY main.go .

# 🔨 Build the application
RUN go build -o webapp main.go

# 🏃 Runtime stage
FROM alpine:latest

# 🔐 Install ca-certificates for HTTPS
RUN apk --no-cache add ca-certificates

WORKDIR /root/

# 📋 Copy the binary from builder stage
COPY --from=builder /app/webapp .

# 🔌 Expose port
EXPOSE 8080

# ▶️ Run the application
CMD ["./webapp"]
```

```bash
# 🔨 Build the multi-stage image
docker build -t my-go-webapp:v1.0 .

# 📊 Compare image sizes
echo "=== Image Size Comparison ==="
docker images | grep -E "(my-webapp|my-go-webapp|golang|python)"
```

---

## 🚀 Task 4: Run Containers from Custom Images

![Docker](https://img.shields.io/badge/Docker_Run-2496ED?style=flat-square&logo=docker&logoColor=white) ![Networking](https://img.shields.io/badge/Container_Networking-4EAA25?style=flat-square)

> 🔖 **Step Sign:** *Take your custom images out for a spin — with ports, volumes, resource limits, and real networking between containers.*

### ▶️ Subtask 4.1: Run Basic Containers

```bash
# 🐍 Run the Python web application
docker run -d --name webapp-container -p 8080:8080 my-webapp:v1.0

# 🐹 Run the Go web application on different port
docker run -d --name go-webapp-container -p 8081:8080 my-go-webapp:v1.0

# 📋 Check running containers
docker ps

# 🌐 Test the applications
curl http://localhost:8080
curl http://localhost:8081
curl http://localhost:8080/health
curl http://localhost:8081/health
```

### ⚙️ Subtask 4.2: Run Containers with Different Configurations

```bash
# 🌎 Run container with environment variables
docker run -d --name webapp-custom-port -p 8082:9000 -e PORT=9000 my-webapp:v1.0

# 💾 Run container with volume mount
mkdir -p ~/docker-lab/logs
docker run -d --name webapp-with-logs -p 8083:8080 -v ~/docker-lab/logs:/app/logs my-webapp:v1.0

# 📏 Run container with resource limits
docker run -d --name webapp-limited --memory=128m --cpus=0.5 -p 8084:8080 my-webapp:v1.0

# 💬 Run container in interactive mode
docker run -it --name webapp-interactive my-webapp:v1.0 /bin/bash
```

### 📊 Subtask 4.3: Monitor Container Performance

```bash
# 📜 View container logs
docker logs webapp-container
docker logs --follow webapp-container

# 📈 Monitor container stats
docker stats webapp-container

# 🔍 Inspect running container
docker inspect webapp-container

# 🧑‍💻 Execute commands in running container
docker exec webapp-container ps aux
docker exec webapp-container df -h
docker exec -it webapp-container /bin/bash
```

### 🌐 Subtask 4.4: Container Networking

```bash
# 🆕 Create a custom network
docker network create webapp-network

# 🔌 Run containers on custom network
docker run -d --name webapp-net --network webapp-network my-webapp:v1.0
docker run -d --name go-webapp-net --network webapp-network my-go-webapp:v1.0

# 📡 Test network connectivity
docker exec webapp-net ping go-webapp-net
docker exec go-webapp-net nslookup webapp-net

# 📋 List networks
docker network ls

# 🔍 Inspect network
docker network inspect webapp-network
```

---

## 🧬 Task 5: Experiment with docker commit and docker diff

![Docker](https://img.shields.io/badge/docker_commit-2496ED?style=flat-square&logo=docker&logoColor=white) ![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=flat-square&logo=ubuntu&logoColor=white)

> 🔖 **Step Sign:** *Two roads to the same image — hand-modify a running container and snapshot it, then compare that against writing it as code.*

### ✏️ Subtask 5.1: Make Changes to a Running Container

```bash
# ▶️ Start a base Ubuntu container
docker run -it --name ubuntu-modified ubuntu:20.04 /bin/bash
```

Inside the container, execute these commands:

```bash
# 📥 Update package list
apt update

# 📦 Install some packages
apt install -y curl wget vim htop

# 📝 Create some files
echo "This is a custom file" > /custom-file.txt
mkdir /custom-directory
echo "Configuration data" > /custom-directory/config.txt

# 📜 Create a simple script
cat > /usr/local/bin/hello.sh << 'EOF'
#!/bin/bash
echo "Hello from modified container!"
echo "Current time: $(date)"
echo "Hostname: $(hostname)"
EOF

chmod +x /usr/local/bin/hello.sh

# 🚪 Exit the container
exit
```

### 🔬 Subtask 5.2: Use docker diff to See Changes

```bash
# 🔍 View changes made to the container
docker diff ubuntu-modified

# 📊 Analyze the output
echo "=== Analyzing Container Changes ==="
echo "A = Added files/directories"
echo "C = Changed files/directories"
echo "D = Deleted files/directories"
echo

# 🔢 Count changes by type
echo "Added files: $(docker diff ubuntu-modified | grep '^A' | wc -l)"
echo "Changed files: $(docker diff ubuntu-modified | grep '^C' | wc -l)"
echo "Deleted files: $(docker diff ubuntu-modified | grep '^D' | wc -l)"

# 🎯 Show only custom changes (filter out system changes)
echo "=== Custom Changes ==="
docker diff ubuntu-modified | grep -E "(custom|hello\.sh)"
```

### 📸 Subtask 5.3: Create Image Using docker commit

```bash
# 📸 Commit the container to create a new image
docker commit ubuntu-modified my-custom-ubuntu:v1.0

# 🏷️ Add metadata during commit
docker commit -m "Added development tools and custom scripts" -a "Student Lab" ubuntu-modified my-custom-ubuntu:v1.1

# 📋 List images to see the new ones
docker images | grep my-custom-ubuntu

# 📊 Compare image sizes
echo "=== Image Size Comparison ==="
docker images ubuntu:20.04
docker images my-custom-ubuntu
```

### 🧪 Subtask 5.4: Test the Committed Image

```bash
# ▶️ Run container from committed image
docker run -it --name test-committed my-custom-ubuntu:v1.1 /bin/bash
```

Inside the new container:

```bash
# ✅ Test installed packages
curl --version
vim --version
htop --version

# 📖 Test custom files
cat /custom-file.txt
ls -la /custom-directory/
cat /custom-directory/config.txt

# 🎬 Test custom script
/usr/local/bin/hello.sh

# 🚪 Exit container
exit
```

### ⚖️ Subtask 5.5: Compare Dockerfile vs docker commit

Create a Dockerfile that produces the same result:

```bash
# 📁 Create directory for comparison
mkdir -p ~/docker-lab/dockerfile-comparison
cd ~/docker-lab/dockerfile-comparison
```

```dockerfile
FROM ubuntu:20.04

# 📥 Update and install packages
RUN apt update && apt install -y curl wget vim htop

# 📝 Create custom files
RUN echo "This is a custom file" > /custom-file.txt
RUN mkdir /custom-directory
RUN echo "Configuration data" > /custom-directory/config.txt

# 📜 Create custom script
RUN cat > /usr/local/bin/hello.sh << 'SCRIPT'
#!/bin/bash
echo "Hello from modified container!"
echo "Current time: $(date)"
echo "Hostname: $(hostname)"
SCRIPT

RUN chmod +x /usr/local/bin/hello.sh

# ▶️ Set default command
CMD ["/bin/bash"]
```

```bash
# 🔨 Build image from Dockerfile
docker build -t my-custom-ubuntu-dockerfile:v1.0 .

# ⚖️ Compare the two approaches
echo "=== Comparison: docker commit vs Dockerfile ==="
echo "Committed image size: $(docker images --format "{{.Size}}" my-custom-ubuntu:v1.1)"
echo "Dockerfile image size: $(docker images --format "{{.Size}}" my-custom-ubuntu-dockerfile:v1.0)"

# 📚 Compare layers
echo "=== Layer Comparison ==="
echo "Committed image layers:"
docker history my-custom-ubuntu:v1.1 --quiet | wc -l
echo "Dockerfile image layers:"
docker history my-custom-ubuntu-dockerfile:v1.0 --quiet | wc -l
```

### 🕵️ Subtask 5.6: Advanced docker diff Analysis

```bash
# 📝 Create a script to analyze container changes
cat > analyze_changes.sh << 'EOF'
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
EOF

# ⚙️ Make executable
chmod +x analyze_changes.sh

# ▶️ Use the script
./analyze_changes.sh ubuntu-modified
```

---

## 🔄 Task 6: Container Lifecycle Management

![Docker](https://img.shields.io/badge/Lifecycle_Mgmt-2496ED?style=flat-square&logo=docker&logoColor=white)

> 🔖 **Step Sign:** *Full circle — create, pause, restart, monitor, and finally clean up. This is container hygiene in practice.*

### 🔁 Subtask 6.1: Container States and Management

```bash
# 🆕 Create containers in different states
docker run -d --name running-container my-webapp:v1.0
docker run --name stopped-container my-webapp:v1.0 echo "This container will stop"
docker create --name created-container my-webapp:v1.0

# 📋 Check container states
docker ps -a

# ▶️ Start stopped container
docker start stopped-container

# ⏸️ Pause and unpause container
docker pause running-container
docker ps
docker unpause running-container

# 🔄 Stop and restart containers
docker stop running-container
docker restart running-container
```

### 📊 Subtask 6.2: Container Resource Usage

```bash
# 📈 Monitor resource usage
docker stats --no-stream

# 🔍 Get detailed container information
docker inspect running-container | grep -A 10 "State"

# 🧵 Check container processes
docker top running-container

# 💾 View container filesystem usage
docker exec running-container df -h
```

### 🧹 Subtask 6.3: Cleanup Operations

```bash
# 🗑️ Remove stopped containers
docker container prune

# 🧽 Remove unused images
docker image prune

# 🧹 Remove everything unused
docker system prune

# 💥 Force remove specific containers
docker rm -f $(docker ps -aq --filter "name=webapp")

# 🗑️ Remove specific images
docker rmi my-custom-ubuntu:v1.0 my-custom-ubuntu:v1.1
```

---

## 🛠️ Troubleshooting Tips

<details>
<summary>🔴 Issue 1: Permission Denied</summary>

```bash
# If you get permission denied errors
sudo usermod -aG docker $USER
newgrp docker
# Or restart your session
```

</details>

<details>
<summary>🔴 Issue 2: Port Already in Use</summary>

```bash
# Check what's using the port
sudo netstat -tulpn | grep :8080
# Use different port
docker run -p 8085:8080 my-webapp:v1.0
```

</details>

<details>
<summary>🔴 Issue 3: Container Won't Start</summary>

```bash
# Check container logs
docker logs container-name
# Run in interactive mode to debug
docker run -it my-webapp:v1.0 /bin/bash
```

</details>

<details>
<summary>🔴 Issue 4: Image Build Fails</summary>

```bash
# Build with verbose output
docker build --no-cache -t my-webapp:debug .
# Check Dockerfile syntax
docker build --dry-run .
```

</details>

<details>
<summary>🔴 Issue 5: Out of Disk Space</summary>

```bash
# Clean up Docker system
docker system prune -a
# Check disk usage
docker system df
```

</details>

---

## 📚 Key Concepts Mastered

| Concept | Description |
|---|---|
| 📦 **Docker Images vs Containers** | Images are read-only templates while containers are running instances |
| 🧅 **Image Layers** | How Docker uses a layered filesystem for efficient storage and sharing |
| 📄 **Dockerfile Best Practices** | Multi-stage builds, security considerations, and optimization techniques |
| 🌐 **Container Networking** | Custom networks and inter-container communication |
| 📏 **Resource Management** | CPU and memory limits, monitoring, and optimization |
| 🔍 **Change Tracking** | Using `docker diff` to understand container modifications |
| ⚖️ **Image Creation Methods** | Comparing the Dockerfile approach vs. `docker commit` for reproducibility |

---

## ✅ Conclusion

### 🏆 Key Accomplishments

In this comprehensive lab, you have successfully:

- ✅ Installed and configured Docker on a Linux system from scratch
- ✅ Inspected Docker images using various commands and learned to analyze image properties, layers, and metadata
- ✅ Created custom Docker images using Dockerfiles with both single-stage and multi-stage builds
- ✅ Built and ran containers from custom images with different configurations, networking, and resource constraints
- ✅ Experimented with `docker commit` to create images from modified containers and compared this approach with Dockerfile-based builds
- ✅ Used `docker diff` to analyze changes made to containers and understand the filesystem modifications
- ✅ Managed container lifecycles including starting, stopping, pausing, and monitoring containers
- ✅ Implemented best practices for container security, resource management, and cleanup operations

### 🌍 Real-World Applications

Understanding Docker images and containers is fundamental to modern application deployment and DevOps practices. The skills you've learned enable you to:

- 📦 Package applications consistently across different environments
- 🔁 Create reproducible deployments using infrastructure as code principles
- 📏 Optimize resource usage through proper container configuration
- 🐞 Debug and troubleshoot containerized applications effectively
- 🔐 Implement security best practices in containerized environments

These capabilities are essential for cloud-native development, microservices architecture, and modern software delivery pipelines. The hands-on experience with both Dockerfile creation and container modification provides you with flexible approaches to image management in real-world scenarios.

---

<div align="center">

![Al Nafi](https://img.shields.io/badge/Al_Nafi-Cybersecurity_Training-6A0DAD?style=for-the-badge)

</div>
