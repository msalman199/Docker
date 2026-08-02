<div align="center">

# 🐳 Docker Architecture Overview

### Understanding the Docker Client-Server Model, Daemon, and Container Lifecycle

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white)
![Nginx](https://img.shields.io/badge/Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white)

![Level](https://img.shields.io/badge/Level-Beginner-blue?style=for-the-badge)
![Duration](https://img.shields.io/badge/Duration-90_min-orange?style=for-the-badge)
![Platform](https://img.shields.io/badge/Platform-Al_Nafi_Cloud_Labs-6A0DAD?style=for-the-badge)

</div>

---

## 📑 Table of Contents

- [🎯 Learning Objectives](#-learning-objectives)
- [📋 Prerequisites](#-prerequisites)
- [🖥️ Lab Environment Setup](#️-lab-environment-setup)
- [🔧 Task 1: Install and Explore Docker Architecture Components](#-task-1-install-and-explore-docker-architecture-components)
- [🚀 Task 2: Run Docker Containers in Different Modes](#-task-2-run-docker-containers-in-different-modes)
- [🔄 Task 3: Container Lifecycle Management Commands](#-task-3-container-lifecycle-management-commands)
- [🔍 Task 4: Docker Architecture Analysis](#-task-4-docker-architecture-analysis)
- [🛠️ Troubleshooting Common Issues](#️-troubleshooting-common-issues)
- [🧹 Lab Cleanup](#-lab-cleanup)
- [📚 Key Concepts](#-key-concepts)
- [✅ Conclusion](#-conclusion)

---

## 🎯 Learning Objectives

By the end of this lab, students will be able to:

| # | Objective |
|---|-----------|
| 1 | Understand the core components of Docker architecture including Docker Daemon and Docker CLI |
| 2 | Differentiate between interactive and detached container execution modes |
| 3 | Execute container lifecycle management commands effectively |
| 4 | Analyze the relationship between Docker client and server components |
| 5 | Manage container states using `start`, `stop`, and `exec` commands |
| 6 | Demonstrate practical knowledge of Docker's client-server architecture |

---

## 📋 Prerequisites

| Requirement | Details |
|---|---|
| 🐧 Linux CLI | Basic understanding of Linux command line operations |
| 💻 Terminal Usage | Familiarity with terminal/command prompt usage |
| 📦 Containerization | Basic knowledge of containerization concepts |
| ⚙️ Process Management | Understanding of process management in Linux |

---

## 🖥️ Lab Environment Setup

> **📝 Note:** Al Nafi provides Linux-based cloud machines for this lab. Simply click **Start Lab** to access your dedicated Linux machine. The provided machine is bare metal with no pre-installed tools, so you will install Docker during the lab exercises.

---

## 🔧 Task 1: Install and Explore Docker Architecture Components

![Docker](https://img.shields.io/badge/Docker_Engine-2496ED?style=flat-square&logo=docker&logoColor=white) ![APT](https://img.shields.io/badge/APT-E95420?style=flat-square&logo=ubuntu&logoColor=white) ![Systemd](https://img.shields.io/badge/systemd-000000?style=flat-square)

> 🔖 **Step Sign:** *You are laying the foundation — installing the engine (`dockerd`) and the steering wheel (`docker` CLI) that talks to it.*

### 🧩 Subtask 1.1: Install Docker on Linux Machine

First, we need to install Docker on our Linux machine.

```bash
# 📥 Update package index
sudo apt update

# 📦 Install required packages
sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release

# 🔑 Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# 📚 Set up the stable repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 📥 Update package index again
sudo apt update

# 🐳 Install Docker Engine
sudo apt install -y docker-ce docker-ce-cli containerd.io

# 👤 Add current user to docker group to run docker without sudo
sudo usermod -aG docker $USER

# 🔄 Apply group changes
newgrp docker
```

### 🔎 Subtask 1.2: Verify Docker Installation and Architecture

Verify that Docker is installed correctly and explore its architecture:

```bash
# 🏷️ Check Docker version
docker --version

# 📊 Display detailed Docker system information
docker system info

# ✅ Check Docker service status
sudo systemctl status docker

# 🔍 View Docker daemon process
ps aux | grep dockerd
```

### 🛰️ Subtask 1.3: Explore Docker Daemon (dockerd)

The Docker daemon is the persistent process that manages Docker containers.

```bash
# ✅ Check if Docker daemon is running
sudo systemctl is-active docker

# 📜 View Docker daemon logs
sudo journalctl -u docker.service --no-pager | tail -20

# ⚙️ Check Docker daemon configuration
sudo cat /etc/docker/daemon.json 2>/dev/null || echo "Default daemon configuration in use"

# TODO: Add your own custom Docker daemon configuration options here (e.g. log-driver, storage-driver)

# 🔌 View Docker daemon socket
ls -la /var/run/docker.sock
```

### 🖱️ Subtask 1.4: Explore Docker CLI (docker)

The Docker CLI is the primary interface for interacting with Docker.

```bash
# ❓ Display Docker CLI help
docker --help

# 📋 List available Docker commands
docker help

# 🏷️ Check Docker client configuration
docker version --format '{{.Client.Version}}'

# 📂 Display Docker CLI configuration location
echo $HOME/.docker
```

---

## 🚀 Task 2: Run Docker Containers in Different Modes

![Ubuntu](https://img.shields.io/badge/Ubuntu_Image-E95420?style=flat-square&logo=ubuntu&logoColor=white) ![Nginx](https://img.shields.io/badge/Nginx-009639?style=flat-square&logo=nginx&logoColor=white)

> 🔖 **Step Sign:** *Two doors, two experiences — one drops you inside the container's shell, the other lets it run quietly in the background.*

### 💬 Subtask 2.1: Run Container in Interactive Mode

Interactive mode allows you to interact with the container directly through the terminal.

```bash
# ⬇️ Pull Ubuntu image
docker pull ubuntu:latest

# ▶️ Run container in interactive mode
docker run -it ubuntu:latest /bin/bash
```

Once inside the container, execute these commands:

```bash
# 👤 Check current user
whoami

# 🐧 Check operating system
cat /etc/os-release

# 📋 List running processes
ps aux

# 📝 Create a test file
echo "Hello from interactive container" > /tmp/test.txt

# 📖 Read the file
cat /tmp/test.txt

# 🚪 Exit the container
exit
```

### 🌙 Subtask 2.2: Run Container in Detached Mode

Detached mode runs containers in the background.

```bash
# ▶️ Run nginx container in detached mode
docker run -d --name web-server -p 8080:80 nginx:latest

# ✅ Verify container is running
docker ps

# 📜 Check container logs
docker logs web-server

# 🌐 Test the web server
curl http://localhost:8080
```

### ⚖️ Subtask 2.3: Compare Interactive vs Detached Modes

```bash
# 💬 Run another interactive container (in a new terminal if needed)
docker run -it --name interactive-test ubuntu:latest /bin/bash
# Type 'exit' to leave

# 🌙 Run another detached container
docker run -d --name detached-test nginx:latest

# 📋 List all containers (running and stopped)
docker ps -a

# ⚖️ Compare the status of both containers
docker ps --filter "name=interactive-test"
docker ps --filter "name=detached-test"
```

---

## 🔄 Task 3: Container Lifecycle Management Commands

![Docker](https://img.shields.io/badge/Container_Lifecycle-2496ED?style=flat-square&logo=docker&logoColor=white) ![Nginx](https://img.shields.io/badge/Nginx-009639?style=flat-square&logo=nginx&logoColor=white)

> 🔖 **Step Sign:** *A container's life has stages — created, started, executed into, stopped. This is where you learn to drive all four.*

### ▶️ Subtask 3.1: Using `docker start` Command

The `docker start` command starts stopped containers.

```bash
# 🆕 Create a container that exits immediately
docker run --name lifecycle-test ubuntu:latest echo "Container created"

# 📋 Check container status
docker ps -a --filter "name=lifecycle-test"

# ▶️ Start the stopped container
docker start lifecycle-test

# 📎 Start container and attach to it
docker start -a lifecycle-test

# 💬 Start container in interactive mode
docker run --name interactive-lifecycle -it ubuntu:latest /bin/bash
# Exit the container by typing 'exit'

# 🔄 Restart the interactive container
docker start -ai interactive-lifecycle
# Exit again
```

### 🧑‍💻 Subtask 3.2: Using `docker exec` Command

The `docker exec` command runs commands in running containers.

```bash
# ▶️ Ensure nginx container is running
docker start web-server

# 📂 Execute command in running container
docker exec web-server ls -la /usr/share/nginx/html

# 💬 Execute interactive bash session in running container
docker exec -it web-server /bin/bash
```

Inside the nginx container, execute:

```bash
# 📋 Check nginx processes
ps aux | grep nginx

# ⚙️ View nginx configuration
cat /etc/nginx/nginx.conf | head -20

# 📝 Create custom index page
echo "<h1>Modified by docker exec</h1>" > /usr/share/nginx/html/index.html

# TODO: Customize this HTML page with your own container info (hostname, uptime, env vars)

# 🚪 Exit the container
exit
```

Verify the changes:

```bash
# 🌐 Test the modified web server
curl http://localhost:8080
```

### ⏹️ Subtask 3.3: Using `docker stop` Command

The `docker stop` command gracefully stops running containers.

```bash
# 📋 List running containers
docker ps

# ⏹️ Stop the web server container
docker stop web-server

# ✅ Verify container is stopped
docker ps
docker ps -a --filter "name=web-server"

# 🌙 Stop multiple containers
docker run -d --name test1 nginx:latest
docker run -d --name test2 nginx:latest

# ⏹️ Stop multiple containers at once
docker stop test1 test2

# 💥 Force stop a container (if needed)
docker run -d --name force-test nginx:latest
docker kill force-test
```

### 🎬 Subtask 3.4: Complete Lifecycle Management Demonstration

```bash
# 🆕 Create a comprehensive lifecycle test
docker run -d --name lifecycle-demo -p 9090:80 nginx:latest

# 📊 Check initial status
echo "=== Initial Status ==="
docker ps --filter "name=lifecycle-demo"

# ⏹️ Stop the container
echo "=== Stopping Container ==="
docker stop lifecycle-demo
docker ps -a --filter "name=lifecycle-demo"

# ▶️ Start the container again
echo "=== Starting Container ==="
docker start lifecycle-demo
docker ps --filter "name=lifecycle-demo"

# 🧑‍💻 Execute command in running container
echo "=== Executing Command ==="
docker exec lifecycle-demo nginx -t

# 📜 View container logs
echo "=== Container Logs ==="
docker logs lifecycle-demo --tail 10

# 🧹 Final cleanup
docker stop lifecycle-demo
docker rm lifecycle-demo
```

---

## 🔍 Task 4: Docker Architecture Analysis

![Docker API](https://img.shields.io/badge/Docker_API-2496ED?style=flat-square&logo=docker&logoColor=white) ![JSON](https://img.shields.io/badge/JSON-000000?style=flat-square&logo=json&logoColor=white)

> 🔖 **Step Sign:** *Peek behind the curtain — watch the client and daemon talk to each other in real time through events and the API.*

### 📡 Subtask 4.1: Analyze Docker Client-Server Communication

```bash
# 🔴 Show Docker system events in real-time (run in background)
docker events &
EVENTS_PID=$!

# ⚙️ Perform various Docker operations to generate events
docker run --name event-test ubuntu:latest echo "Testing events"
docker start event-test
docker stop event-test
docker rm event-test

# ⏹️ Stop events monitoring
kill $EVENTS_PID
```

### 🌐 Subtask 4.2: Examine Docker API Communication

```bash
# 🏷️ Check Docker API version
docker version --format '{{.Server.APIVersion}}'

# 📊 Display Docker system information in JSON format
docker system info --format '{{json .}}'

# 💾 Show Docker disk usage
docker system df

# 📈 Display detailed space usage
docker system df -v
```

### 📈 Subtask 4.3: Container Resource Analysis

```bash
# 🆕 Run a container with resource monitoring
docker run -d --name resource-test --memory=100m --cpus=0.5 nginx:latest

# 📊 Monitor container resource usage
docker stats resource-test --no-stream

# 🔍 Inspect container configuration
docker inspect resource-test | grep -A 10 -B 10 "Memory\|Cpu"

# 🧹 Clean up
docker stop resource-test
docker rm resource-test
```

---

## 🛠️ Troubleshooting Common Issues

<details>
<summary>🔴 Issue 1: Docker Daemon Not Running</summary>

```bash
# ✅ Check daemon status
sudo systemctl status docker

# ▶️ Start Docker daemon if stopped
sudo systemctl start docker

# 🔁 Enable Docker to start on boot
sudo systemctl enable docker
```

</details>

<details>
<summary>🔴 Issue 2: Permission Denied Errors</summary>

```bash
# 👤 Add user to docker group
sudo usermod -aG docker $USER

# 🔄 Apply group changes
newgrp docker

# ✅ Verify group membership
groups $USER
```

</details>

<details>
<summary>🔴 Issue 3: Container Port Conflicts</summary>

```bash
# 🔍 Check which ports are in use
netstat -tulpn | grep :8080

# 🔀 Use different port mapping
docker run -d -p 8081:80 nginx:latest
```

</details>

---

## 🧹 Lab Cleanup

Clean up all resources created during this lab:

```bash
# ⏹️ Stop all running containers
docker stop $(docker ps -q) 2>/dev/null || echo "No running containers"

# 🗑️ Remove all containers
docker rm $(docker ps -aq) 2>/dev/null || echo "No containers to remove"

# 🧽 Remove unused images
docker image prune -f

# 📊 Display final system status
docker system df
```

---

## 📚 Key Concepts

| Concept | Description |
|---|---|
| 🛰️ **Docker Daemon (`dockerd`)** | Persistent background process that manages images, containers, networks, and volumes |
| 🖱️ **Docker CLI (`docker`)** | Client-side command-line tool that sends instructions to the daemon over its socket/API |
| 🔌 **Docker Socket** | `/var/run/docker.sock` — the channel through which the CLI talks to the daemon |
| 💬 **Interactive Mode (`-it`)** | Attaches your terminal to the container for direct, live interaction |
| 🌙 **Detached Mode (`-d`)** | Runs the container in the background, freeing up the terminal |
| ▶️ **`docker start`** | Starts an existing, stopped container |
| 🧑‍💻 **`docker exec`** | Runs a new command inside an already-running container |
| ⏹️ **`docker stop` / `docker kill`** | Gracefully stops (`stop`) vs. force-terminates (`kill`) a running container |
| 📡 **Docker API** | REST interface the daemon exposes; the CLI is effectively an API client |
| 📊 **`docker system df` / `docker stats`** | Tools for inspecting disk usage and live resource consumption |

---

## ✅ Conclusion

### 🏆 Key Accomplishments

In this lab, you have successfully:

- ✅ Installed and configured Docker on a Linux machine from scratch
- ✅ Explored Docker architecture components including the Docker daemon (`dockerd`) and Docker CLI
- ✅ Demonstrated the difference between interactive and detached container modes, understanding when to use each approach
- ✅ Mastered container lifecycle management using `docker start`, `docker exec`, and `docker stop` commands
- ✅ Analyzed Docker's client-server architecture and how components communicate
- ✅ Gained hands-on experience with real-world container management scenarios

### 🌍 Real-World Applications

This knowledge is fundamental for anyone working with containerized applications. Understanding Docker architecture enables you to troubleshoot issues, optimize container performance, and make informed decisions about container deployment strategies. The skills learned in this lab form the foundation for more advanced Docker topics such as container orchestration, networking, and production deployments.

The practical experience gained through managing container lifecycles and understanding the underlying architecture will be invaluable as you progress to more complex containerization scenarios in enterprise environments.

---

<div align="center">

![Al Nafi](https://img.shields.io/badge/Al_Nafi-Cybersecurity_Training-6A0DAD?style=for-the-badge)

</div>
