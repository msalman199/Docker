# 🐳 Introduction to Docker — Hands-On Lab

<p align="center">
  <img src="https://img.shields.io/badge/Docker-Containerization-2496ED?style=for-the-badge&logo=docker&logoColor=white" alt="Docker">
  <img src="https://img.shields.io/badge/Linux-Administration-FCC624?style=for-the-badge&logo=linux&logoColor=black" alt="Linux">
  <img src="https://img.shields.io/badge/Ubuntu-Linux-E95420?style=for-the-badge&logo=ubuntu&logoColor=white" alt="Ubuntu">
  <img src="https://img.shields.io/badge/Docker%20CLI-Commands-2496ED?style=for-the-badge&logo=docker&logoColor=white" alt="Docker CLI">
  <img src="https://img.shields.io/badge/Nginx-Web%20Server-009639?style=for-the-badge&logo=nginx&logoColor=white" alt="Nginx">
</p>

<p align="center">
  <b>🚀 A hands-on introduction to Docker, containerization, images, containers, and container lifecycle management.</b>
</p>

---

## 🌟 Lab Overview

This lab provides a practical introduction to **Docker containerization** using a Linux-based cloud environment.

Throughout this exercise, Docker is installed and configured from the official repository, followed by hands-on practice with containers, images, networking, logs, resource monitoring, and container lifecycle operations.

> 🎯 **Main Goal:** Build a strong foundation in Docker and container-based application deployment.

---

# 🎯 Learning Objectives

By completing this lab, you will learn how to:

* 🐳 Understand Docker and containerization fundamentals
* 🛠️ Install Docker on a Linux system
* 📦 Understand Docker images and containers
* 🚀 Run Docker containers
* 🔎 Inspect containers and view logs
* 💻 Execute commands inside containers
* 🔄 Manage the container lifecycle
* 🌐 Configure container port mapping
* 📊 Monitor container resources
* 🧹 Clean up unused containers and images
* ⚙️ Understand Docker's basic workflow and terminology

---

# 🧰 Technologies & Tools

| Technology          | Purpose                            |
| ------------------- | ---------------------------------- |
| 🐳 **Docker**       | Containerization platform          |
| 🐧 **Linux**        | Host operating system              |
| 🟠 **Ubuntu**       | Linux distribution used in the lab |
| 🌐 **Nginx**        | Web server container               |
| 📦 **Docker Hub**   | Container image registry           |
| 🖥️ **Docker CLI**  | Container management               |
| 🔐 **GPG**          | Package authenticity verification  |
| 🌍 **cURL**         | Network and HTTP testing           |
| 📊 **Docker Stats** | Container resource monitoring      |

### 🏷️ Technology Badges

<p align="center">
  <img src="https://img.shields.io/badge/Docker-2496ED?style=flat-square&logo=docker&logoColor=white">
  <img src="https://img.shields.io/badge/Linux-FCC624?style=flat-square&logo=linux&logoColor=black">
  <img src="https://img.shields.io/badge/Ubuntu-E95420?style=flat-square&logo=ubuntu&logoColor=white">
  <img src="https://img.shields.io/badge/Nginx-009639?style=flat-square&logo=nginx&logoColor=white">
  <img src="https://img.shields.io/badge/Docker%20Hub-2496ED?style=flat-square&logo=docker&logoColor=white">
  <img src="https://img.shields.io/badge/Bash-121011?style=flat-square&logo=gnu-bash&logoColor=white">
</p>

---

# 📋 Prerequisites

Before starting the lab, you should have:

* 🐧 Basic Linux command-line knowledge
* 📁 Understanding of commands such as `cd`, `ls`, and `pwd`
* 📦 Basic knowledge of package management
* 🛠️ Familiarity with software installation
* 💻 Basic terminal/command-prompt experience

---

# ☁️ Lab Environment

The lab is performed on an **Al Nafi Cloud Linux machine**.

The environment consists of a single Linux machine where Docker and the required components are installed during the exercise.

> 💡 **Environment:** Al Nafi Cloud Linux Machine
> 💡 **Machines Required:** 1 Linux machine
> 💡 **Container Platform:** Docker

---

# 🐳 Task 1 — Install Docker

## ✨ Step 1.1 — Update System Packages

First, update the package repository and upgrade existing packages.

```bash
sudo apt update
sudo apt upgrade -y
```

### 🔍 Why?

This ensures the system has the latest available packages and security updates before Docker installation.

---

## ✨ Step 1.2 — Install Required Dependencies

Install the packages required for accessing repositories securely.

```bash
sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release
```

### 📦 Important Components

* 🔐 `apt-transport-https` — Secure repository access
* 🛡️ `ca-certificates` — Certificate authority certificates
* 🌐 `curl` — Data transfer utility
* 🔑 `gnupg` — GPG security and verification
* 🐧 `lsb-release` — Linux distribution information

---

## ✨ Step 1.3 — Add Docker GPG Key

Add Docker's official GPG key.

```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```

🔐 This key is used to verify the authenticity of Docker packages.

---

## ✨ Step 1.4 — Configure Docker Repository

Add Docker's official repository.

```bash
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

---

## ✨ Step 1.5 — Install Docker Engine

Update the package index and install Docker.

```bash
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
```

### 🧩 Components Installed

| Component               | Purpose                       |
| ----------------------- | ----------------------------- |
| `docker-ce`             | Docker Community Edition      |
| `docker-ce-cli`         | Docker command-line interface |
| `containerd.io`         | Container runtime             |
| `docker-compose-plugin` | Docker Compose functionality  |

---

## ✨ Step 1.6 — Verify Docker Service

Check whether Docker is running.

```bash
sudo systemctl status docker
```

If Docker is not running:

```bash
sudo systemctl start docker
sudo systemctl enable docker
```

✅ Docker should now start automatically when the system boots.

---

## ✨ Step 1.7 — Configure Docker User Permissions

Add the current user to the Docker group.

```bash
sudo usermod -aG docker $USER
```

Apply the group change:

```bash
newgrp docker
```

🎯 After this configuration, Docker commands can be executed without `sudo`.

---

# 🚀 Task 2 — Run Your First Docker Container

## ✨ Step 2.1 — Run Hello World

Test the Docker installation:

```bash
docker run hello-world
```

### 🎉 Expected Result

Docker should display a message confirming that the Docker installation is working correctly.

---

## ✨ Step 2.2 — Understand the Docker Workflow

When running:

```bash
docker run hello-world
```

Docker performs several operations:

```text
🌐 Pull Image
     ↓
📦 Create Container
     ↓
🚀 Start Container
     ↓
📝 Display Output
     ↓
🛑 Container Exits
```

### 🔄 Docker Workflow

**Pull → Create → Start → Execute → Stop → Remove**

---

## ✨ Step 2.3 — Run an Interactive Ubuntu Container

Start an Ubuntu container interactively:

```bash
docker run -it ubuntu:latest /bin/bash
```

### 🔍 Command Breakdown

| Option          | Meaning                    |
| --------------- | -------------------------- |
| `-i`            | Interactive mode           |
| `-t`            | Allocate a pseudo-terminal |
| `ubuntu:latest` | Ubuntu image               |
| `/bin/bash`     | Start Bash shell           |

Inside the container:

```bash
ls
pwd
cat /etc/os-release
```

Exit the container:

```bash
exit
```

---

# 🛠️ Task 3 — Master Basic Docker Commands

## ✨ Step 3.1 — List Containers

View running containers:

```bash
docker ps
```

View all containers:

```bash
docker ps -a
```

### 📊 Important Columns

| Column       | Description                 |
| ------------ | --------------------------- |
| Container ID | Unique container identifier |
| Image        | Image used by the container |
| Command      | Command executed            |
| Created      | Container creation time     |
| Status       | Current container status    |
| Ports        | Port mappings               |
| Names        | Container name              |

---

## ✨ Step 3.2 — Run a Background Nginx Container

```bash
docker run -d --name my-nginx nginx:latest
```

### 🔍 Options

* `-d` → Detached/background mode
* `--name` → Assign a custom container name
* `nginx:latest` → Nginx Docker image

🎯 Container name:

```text
my-nginx
```

---

## ✨ Step 3.3 — Inspect Container Details

View detailed container information:

```bash
docker inspect my-nginx
```

View container logs:

```bash
docker logs my-nginx
```

🔎 These commands are useful for troubleshooting and understanding container configuration.

---

## ✨ Step 3.4 — Execute Commands Inside a Container

Enter the running Nginx container:

```bash
docker exec -it my-nginx /bin/bash
```

Explore Nginx:

```bash
ls /etc/nginx/
```

View the Nginx configuration:

```bash
cat /etc/nginx/nginx.conf
```

Exit:

```bash
exit
```

---

## ✨ Step 3.5 — Stop and Start Containers

Stop the container:

```bash
docker stop my-nginx
```

Verify:

```bash
docker ps
docker ps -a
```

Start it again:

```bash
docker start my-nginx
```

🔄 This demonstrates the container lifecycle without deleting the container.

---

## ✨ Step 3.6 — Remove a Container

Stop the container:

```bash
docker stop my-nginx
```

Remove it:

```bash
docker rm my-nginx
```

Verify:

```bash
docker ps -a
```

🧹 The container should no longer appear in the container list.

---

## ✨ Step 3.7 — Work With Docker Images

List downloaded images:

```bash
docker images
```

Remove an image:

```bash
docker rmi hello-world
```

Pull Alpine Linux:

```bash
docker pull alpine:latest
```

📦 Docker images are reusable templates from which containers are created.

---

# 🔄 Task 4 — Container Lifecycle Management

## ✨ Step 4.1 — Create Multiple Containers

Run two Nginx containers:

```bash
docker run -d --name web1 nginx:latest
docker run -d --name web2 nginx:latest
```

Run an Alpine container:

```bash
docker run -d --name database alpine:latest sleep 3600
```

### 🏗️ Lab Architecture

```text
              🐳 Docker Host
                    │
        ┌───────────┼───────────┐
        │           │           │
      🌐 web1      🌐 web2    🗄️ database
      Nginx        Nginx       Alpine
```

---

## ✨ Step 4.2 — Monitor Container Resources

Run:

```bash
docker stats
```

📊 This displays live resource usage information for running containers.

Press:

```text
Ctrl + C
```

to exit the statistics view.

---

# 🌐 Task 4.3 — Configure Port Mapping

Run an Nginx container with port mapping:

```bash
docker run -d --name web-server -p 8080:80 nginx:latest
```

### 🔌 Port Mapping

```text
Host Port          Container Port
    8080     ───►       80
```

Therefore:

```text
localhost:8080
       ↓
Docker Host
       ↓
Nginx Container :80
```

Test the web server:

```bash
curl http://localhost:8080
```

🎉 If Nginx is running correctly, you should receive an HTTP response.

---

# 🧹 Task 4.4 — Clean Up Containers

Stop all running containers:

```bash
docker stop $(docker ps -q)
```

Remove all containers:

```bash
docker rm $(docker ps -aq)
```

### 🔍 Command Explanation

```bash
$(docker ps -q)
```

Returns IDs of currently running containers.

```bash
$(docker ps -aq)
```

Returns IDs of all containers.

⚠️ **Warning:** The cleanup commands remove containers, so use them carefully.

---

# 🛠️ Troubleshooting

## ❌ Issue 1 — Permission Denied

### Problem

Docker commands return permission errors.

### ✅ Solution

```bash
sudo usermod -aG docker $USER
newgrp docker
```

---

## ❌ Issue 2 — Docker Service Not Running

### Problem

Docker commands fail because the Docker service is stopped.

### ✅ Solution

```bash
sudo systemctl start docker
sudo systemctl enable docker
```

Verify:

```bash
sudo systemctl status docker
```

---

## ❌ Issue 3 — Port Already in Use

### Problem

The selected host port is already being used.

### ✅ Solution

Use another host port:

```bash
docker run -d --name web-server -p 8081:80 nginx:latest
```

---

## ❌ Issue 4 — Image Pull Failure

### Problem

Docker cannot download an image from Docker Hub.

### ✅ Troubleshooting

Check connectivity:

```bash
ping docker.com
```

Check Docker information:

```bash
docker system info
```

---

# 🧠 Key Docker Concepts

## 📦 Containerization

Containerization is a lightweight virtualization approach that packages an application and its dependencies into a portable container.

### 🚀 Benefits

* ⚡ Lightweight
* 📦 Portable
* 🔄 Consistent environments
* 🛠️ Simplified deployment
* ☁️ Cloud-native friendly
* 🔗 Useful for microservices

---

# 🖼️ Docker Images vs Containers

| 🖼️ Docker Image                | 📦 Docker Container            |
| ------------------------------- | ------------------------------ |
| Read-only template              | Running instance               |
| Used to create containers       | Created from an image          |
| Stored locally or in registries | Executes application processes |
| Can create multiple containers  | Has its own lifecycle          |

### Simple Concept

```text
          🖼️ Docker Image
                 │
        ┌────────┼────────┐
        ↓        ↓        ↓
     📦 App1   📦 App2   📦 App3
   Container  Container  Container
```

---

# 🔄 Docker Container Lifecycle

```text
🌐 PULL
  ↓
📦 CREATE
  ↓
🚀 START
  ↓
▶️ RUN
  ↓
🛑 STOP
  ↓
🗑️ REMOVE
```

### Essential Commands

| Operation       | Command          |
| --------------- | ---------------- |
| Pull image      | `docker pull`    |
| Create/Run      | `docker run`     |
| List containers | `docker ps`      |
| Inspect         | `docker inspect` |
| Logs            | `docker logs`    |
| Execute         | `docker exec`    |
| Stop            | `docker stop`    |
| Start           | `docker start`   |
| Remove          | `docker rm`      |
| List images     | `docker images`  |
| Remove image    | `docker rmi`     |
| Monitor         | `docker stats`   |

---

# 🏆 Lab Completion

By completing this lab, the following practical skills were developed:

* ✅ Installed Docker using the official repository method
* ✅ Configured Docker on Linux
* ✅ Verified Docker with the `hello-world` image
* ✅ Ran interactive Ubuntu containers
* ✅ Worked with Docker images
* ✅ Created and managed containers
* ✅ Started and stopped containers
* ✅ Executed commands inside containers
* ✅ Inspected containers
* ✅ Viewed container logs
* ✅ Monitored container resources
* ✅ Configured port mapping
* ✅ Worked with Nginx containers
* ✅ Practiced container cleanup
* ✅ Learned Docker container lifecycle management

---

# 🚀 Why Docker Matters

Docker is an important technology in modern:

* ☁️ Cloud Computing
* ⚙️ DevOps
* 🔄 CI/CD
* 🧩 Microservices
* ☸️ Kubernetes
* 🏗️ Cloud-Native Development
* 🚀 Application Deployment

Docker allows applications and their dependencies to be packaged into consistent environments, making deployment easier across development, testing, and production systems.

---

# 🔮 Next Steps

After completing this introductory Docker lab, the next areas to explore are:

### 🐳 1. Dockerfiles

Learn how to build custom Docker images.

```text
Application
     ↓
Dockerfile
     ↓
Docker Build
     ↓
Custom Image
     ↓
Container
```

### 🧩 2. Docker Compose

Learn how to manage multi-container applications.

### ☸️ 3. Kubernetes

Use Kubernetes to orchestrate and manage containers at scale.

### 🔄 4. CI/CD Integration

Integrate Docker with automated deployment pipelines.

### 🏗️ 5. Advanced Containerization

Explore:

* Multi-stage builds
* Docker networking
* Docker volumes
* Container security
* Image optimization
* Private registries
* Docker Compose
* Kubernetes orchestration

---

# 📚 Skills Gained

<p align="center">

`🐳 Docker` • `🐧 Linux` • `📦 Containers` • `🖼️ Images` • `🌐 Networking` • `📊 Monitoring` • `⚙️ CLI` • `🚀 DevOps`

</p>

---

# 🎯 Final Takeaway

> **"Learn Docker today, build cloud-native applications tomorrow."** 🚀

This lab provides the foundation required to move from traditional application deployment toward modern **containerized, automated, and cloud-native environments**.

---

## ⭐ Acknowledgment

This hands-on lab was completed in the **Al Nafi Cloud training environment** and provides practical experience with Docker and Linux-based containerization.

---

<p align="center">

### 🐳 Keep Learning • Keep Building • Keep Automating 🚀

**Docker | Linux | DevOps | Cloud | Kubernetes**

</p>

<p align="center">
  <b>✨ Happy Containerizing! ✨</b>
</p>
