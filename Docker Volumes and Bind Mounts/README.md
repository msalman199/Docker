<div align="center">

# 💾 Docker Volumes and Bind Mounts

### Persisting, Sharing, and Managing Data in Containerized Applications

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white)

![Level](https://img.shields.io/badge/Level-Beginner--Intermediate-blue?style=for-the-badge)
![Duration](https://img.shields.io/badge/Duration-120_min-orange?style=for-the-badge)
![Platform](https://img.shields.io/badge/Platform-Al_Nafi_Cloud_Labs-6A0DAD?style=for-the-badge)

</div>

---

## 📑 Table of Contents

- [🎯 Learning Objectives](#-learning-objectives)
- [📋 Prerequisites](#-prerequisites)
- [🖥️ Lab Environment Setup](#️-lab-environment-setup)
- [🔧 Task 1: Install Docker on the Linux Machine](#-task-1-install-docker-on-the-linux-machine)
- [🗄️ Task 2: Understanding Docker Storage Options](#️-task-2-understanding-docker-storage-options)
- [📦 Task 3: Working with Docker Volumes](#-task-3-working-with-docker-volumes)
- [🔗 Task 4: Working with Bind Mounts](#-task-4-working-with-bind-mounts)
- [🧰 Task 5: Advanced Volume Operations](#-task-5-advanced-volume-operations)
- [🔄 Task 6: Data Persistence Verification](#-task-6-data-persistence-verification)
- [🧹 Task 7: Cleanup and Best Practices](#-task-7-cleanup-and-best-practices)
- [🛠️ Troubleshooting Common Issues](#️-troubleshooting-common-issues)
- [✅ Lab Verification](#-lab-verification)
- [📚 Key Concepts](#-key-concepts)
- [🏁 Conclusion](#-conclusion)

---

## 🎯 Learning Objectives

By the end of this lab, you will be able to:

| # | Objective |
|---|-----------|
| 1 | Understand the difference between Docker volumes and bind mounts |
| 2 | Create and manage Docker volumes using command-line tools |
| 3 | Implement bind mounts to connect host directories with containers |
| 4 | Verify data persistence across container lifecycle operations |
| 5 | Apply best practices for data management in containerized applications |
| 6 | Troubleshoot common volume and bind mount issues |

---

## 📋 Prerequisites

| Requirement | Details |
|---|---|
| 🐧 Linux CLI | Basic understanding of Linux command line operations |
| 🐳 Docker Basics | Familiarity with Docker containers and basic Docker commands |
| 🗂️ File Systems | Knowledge of file system concepts and directory structures |
| 🔄 Container Lifecycle | Understanding of container lifecycle (create, start, stop, remove) |

---

## 🖥️ Lab Environment Setup

> **📝 Note:** Al Nafi provides Linux-based cloud machines for this lab. Simply click **Start Lab** to access your dedicated Linux environment. The provided machine is bare metal with no pre-installed tools, so you will install Docker and other required tools during the lab exercises.

---

## 🔧 Task 1: Install Docker on the Linux Machine

![Docker](https://img.shields.io/badge/Docker_Engine-2496ED?style=flat-square&logo=docker&logoColor=white) ![APT](https://img.shields.io/badge/APT-E95420?style=flat-square&logo=ubuntu&logoColor=white) ![Systemd](https://img.shields.io/badge/systemd-000000?style=flat-square)

> 🔖 **Step Sign:** *Get the engine installed and verified first — data persistence means nothing without a running Docker daemon underneath it.*

### 🔄 Subtask 1.1: Update the System Package Manager

First, update your system's package manager to ensure you have the latest package information:

```bash
sudo apt update
sudo apt upgrade -y
```

### 📦 Subtask 1.2: Install Required Dependencies

Install the necessary packages for Docker installation:

```bash
sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release
```

### 🔑 Subtask 1.3: Add Docker's Official GPG Key

Add Docker's official GPG key to verify package authenticity:

```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```

### 📚 Subtask 1.4: Set Up Docker Repository

Add the Docker repository to your system:

```bash
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

### 🐳 Subtask 1.5: Install Docker Engine

Update the package database and install Docker:

```bash
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io
```

### ▶️ Subtask 1.6: Start and Enable Docker Service

Start the Docker service and enable it to start automatically on boot:

```bash
sudo systemctl start docker
sudo systemctl enable docker
```

### 👤 Subtask 1.7: Add User to Docker Group

Add your current user to the docker group to run Docker commands without `sudo`:

```bash
sudo usermod -aG docker $USER
```

> **📝 Note:** You may need to log out and log back in for this change to take effect, or use the following command:

```bash
newgrp docker
```

### ✅ Subtask 1.8: Verify Docker Installation

Verify that Docker is installed and running correctly:

```bash
docker --version
docker run hello-world
```

---

## 🗄️ Task 2: Understanding Docker Storage Options

![Docker](https://img.shields.io/badge/Docker_Storage-2496ED?style=flat-square&logo=docker&logoColor=white)

> 🔖 **Step Sign:** *Before creating anything, see what Docker already tracks — a clean baseline makes every change you make afterward obvious.*

### 📁 Subtask 2.1: Create Working Directories

Create directories on your host system for organizing lab files:

```bash
mkdir -p ~/docker-lab/volumes
mkdir -p ~/docker-lab/bind-mounts
mkdir -p ~/docker-lab/host-data
cd ~/docker-lab
```

### 🔍 Subtask 2.2: Examine Current Docker Storage

Check existing Docker storage components:

```bash
docker volume ls
docker system df
```

---

## 📦 Task 3: Working with Docker Volumes

![Docker](https://img.shields.io/badge/Docker_Volumes-2496ED?style=flat-square&logo=docker&logoColor=white) ![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=flat-square&logo=ubuntu&logoColor=white)

> 🔖 **Step Sign:** *Docker-managed storage — create it, write to it, destroy the container, and watch the data outlive it.*

### 🆕 Subtask 3.1: Create a Named Volume

Create your first Docker volume using the `docker volume create` command:

```bash
docker volume create my-data-volume
```

Verify the volume was created:

```bash
docker volume ls
docker volume inspect my-data-volume
```

### 📥 Subtask 3.2: Use Volume in a Container

Run a container that uses the created volume:

```bash
docker run -it --name volume-test-1 -v my-data-volume:/data ubuntu:20.04 bash
```

Inside the container, create some test data:

```bash
echo "This is persistent data from container 1" > /data/test-file.txt
echo "Volume test data" > /data/volume-data.txt
ls -la /data/
cat /data/test-file.txt
exit
```

### ♻️ Subtask 3.3: Verify Data Persistence

Remove the first container and create a new one using the same volume:

```bash
docker rm volume-test-1
docker run -it --name volume-test-2 -v my-data-volume:/data ubuntu:20.04 bash
```

Inside the new container, verify the data persists:

```bash
ls -la /data/
cat /data/test-file.txt
cat /data/volume-data.txt
echo "Data from container 2" >> /data/test-file.txt
cat /data/test-file.txt
exit
```

### 🗂️ Subtask 3.4: Create Multiple Volumes

Create additional volumes for different purposes:

```bash
docker volume create app-logs
docker volume create app-config
docker volume create database-data
```

List all volumes:

```bash
docker volume ls
```

### 🧩 Subtask 3.5: Use Multiple Volumes in One Container

Run a container with multiple volume mounts:

```bash
docker run -it --name multi-volume-test \
  -v app-logs:/var/log/app \
  -v app-config:/etc/app \
  -v database-data:/var/lib/database \
  ubuntu:20.04 bash
```

Inside the container, create data in different mounted volumes:

```bash
echo "Application started at $(date)" > /var/log/app/app.log
echo "config_value=production" > /etc/app/config.ini
echo "database_version=1.0" > /var/lib/database/version.txt

# ✅ Verify all files
ls -la /var/log/app/
ls -la /etc/app/
ls -la /var/lib/database/
exit
```

---

## 🔗 Task 4: Working with Bind Mounts

![Docker](https://img.shields.io/badge/Bind_Mounts-2496ED?style=flat-square&logo=docker&logoColor=white) ![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=flat-square&logo=ubuntu&logoColor=white)

> 🔖 **Step Sign:** *Unlike volumes, bind mounts give the host and container a direct, live window into the same files.*

### 📁 Subtask 4.1: Prepare Host Directory

Create and populate a directory on the host system:

```bash
cd ~/docker-lab/host-data
echo "This file exists on the host" > host-file.txt
echo "Shared configuration data" > config.conf
mkdir logs
echo "Initial log entry" > logs/application.log
```

### 🔗 Subtask 4.2: Create Bind Mount

Run a container with a bind mount connecting the host directory:

```bash
docker run -it --name bind-mount-test \
  -v ~/docker-lab/host-data:/app/data \
  ubuntu:20.04 bash
```

Inside the container, examine the mounted data:

```bash
ls -la /app/data/
cat /app/data/host-file.txt
cat /app/data/config.conf

# ✏️ Modify existing file and create new file
echo "Modified from container" >> /app/data/host-file.txt
echo "Container created this file" > /app/data/container-file.txt
echo "New log entry from container" >> /app/data/logs/application.log
exit
```

### 🔍 Subtask 4.3: Verify Bind Mount Changes on Host

Check the host directory to see changes made from the container:

```bash
cd ~/docker-lab/host-data
ls -la
cat host-file.txt
cat container-file.txt
cat logs/application.log
```

### ⏱️ Subtask 4.4: Demonstrate Real-time Synchronization

Open a new terminal session (or use `screen`/`tmux`) and start monitoring the host directory:

```bash
# 👀 In terminal 1 - monitor changes
cd ~/docker-lab/host-data
watch -n 1 'ls -la && echo "--- File Contents ---" && cat host-file.txt 2>/dev/null'
```

In the main terminal, run a container and make changes:

```bash
# ▶️ In terminal 2 - make changes
docker run -it --name realtime-test \
  -v ~/docker-lab/host-data:/app/data \
  ubuntu:20.04 bash
```

Inside the container:

```bash
# ⏳ Add timestamp entries every few seconds
for i in {1..5}; do
  echo "Entry $i at $(date)" >> /app/data/host-file.txt
  sleep 3
done
exit
```

Stop the `watch` command in terminal 1 with `Ctrl+C`.

---

## 🧰 Task 5: Advanced Volume Operations

![Docker](https://img.shields.io/badge/Backup_%26_Restore-2496ED?style=flat-square&logo=docker&logoColor=white) ![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=flat-square&logo=ubuntu&logoColor=white)

> 🔖 **Step Sign:** *Beyond basic mounting — back up a volume to a tarball, restore it into a fresh volume, and lock a mount down to read-only.*

### 💽 Subtask 5.1: Volume Backup and Restore

Create a container to backup volume data:

```bash
docker run --rm \
  -v my-data-volume:/source \
  -v ~/docker-lab/volumes:/backup \
  ubuntu:20.04 \
  tar czf /backup/my-data-backup.tar.gz -C /source .
```

Verify the backup was created:

```bash
ls -la ~/docker-lab/volumes/
```

Create a new volume and restore the backup:

```bash
docker volume create restored-volume

docker run --rm \
  -v restored-volume:/target \
  -v ~/docker-lab/volumes:/backup \
  ubuntu:20.04 \
  tar xzf /backup/my-data-backup.tar.gz -C /target
```

Verify the restored data:

```bash
docker run --rm -v restored-volume:/data ubuntu:20.04 ls -la /data
docker run --rm -v restored-volume:/data ubuntu:20.04 cat /data/test-file.txt
```

### 🔎 Subtask 5.2: Volume Inspection and Management

Get detailed information about volumes:

```bash
docker volume inspect my-data-volume
docker volume inspect restored-volume
```

Check volume usage:

```bash
docker system df -v
```

### 🔒 Subtask 5.3: Read-Only Mounts

Demonstrate read-only volume mounts:

```bash
# 🔒 Create read-only bind mount
docker run -it --name readonly-test \
  -v ~/docker-lab/host-data:/app/data:ro \
  ubuntu:20.04 bash
```

Inside the container, try to modify files (this should fail):

```bash
ls -la /app/data/
cat /app/data/host-file.txt

# ❌ This should fail with permission denied
echo "This should fail" >> /app/data/host-file.txt

# ❌ This should also fail
touch /app/data/new-file.txt
exit
```

---

## 🔄 Task 6: Data Persistence Verification

![Docker](https://img.shields.io/badge/Persistence-2496ED?style=flat-square&logo=docker&logoColor=white)

> 🔖 **Step Sign:** *The real proof — stop it, start it, delete it, recreate it. If the data survives all four, the volume is doing its job.*

### 🗄️ Subtask 6.1: Container Lifecycle Testing

Create a database-like scenario to test persistence:

```bash
# ▶️ Start a container with volume
docker run -d --name persistence-test \
  -v database-data:/var/lib/data \
  ubuntu:20.04 \
  bash -c 'while true; do echo "$(date): Database running" >> /var/lib/data/db.log; sleep 5; done'
```

Let it run for a moment, then check the logs:

```bash
sleep 15
docker exec persistence-test cat /var/lib/data/db.log
```

### 🔁 Subtask 6.2: Stop and Restart Container

Stop the container and restart it:

```bash
docker stop persistence-test
docker start persistence-test
sleep 10
docker exec persistence-test cat /var/lib/data/db.log
```

### 🆕 Subtask 6.3: Remove and Recreate Container

Remove the container completely and create a new one with the same volume:

```bash
docker stop persistence-test
docker rm persistence-test

# 🆕 Create new container with same volume
docker run -d --name new-persistence-test \
  -v database-data:/var/lib/data \
  ubuntu:20.04 \
  bash -c 'echo "$(date): New container started" >> /var/lib/data/db.log; cat /var/lib/data/db.log'
```

Check that old data persists:

```bash
docker logs new-persistence-test
```

---

## 🧹 Task 7: Cleanup and Best Practices

![Docker](https://img.shields.io/badge/Cleanup-2496ED?style=flat-square&logo=docker&logoColor=white)

> 🔖 **Step Sign:** *Wrap up responsibly — clear out test containers and volumes, then write down the rules you just learned so future-you remembers them.*

### 🧽 Subtask 7.1: Clean Up Containers

Stop and remove all test containers:

```bash
docker stop $(docker ps -aq) 2>/dev/null || true
docker rm $(docker ps -aq) 2>/dev/null || true
```

### 🗑️ Subtask 7.2: Volume Management

List all volumes and their usage:

```bash
docker volume ls
docker system df -v
```

Remove unused volumes (be careful with this command):

```bash
# 🎯 Remove specific volumes
docker volume rm restored-volume

# ⚠️ Remove all unused volumes (use with caution)
docker volume prune -f
```

### 📝 Subtask 7.3: Best Practices Summary

Create a summary file documenting best practices:

```bash
cat > ~/docker-lab/volume-best-practices.md << 'EOF'
# Docker Volume Best Practices

## When to Use Volumes vs Bind Mounts

### Use Volumes When:
- Data needs to persist beyond container lifecycle
- Multiple containers need to share data
- You want Docker to manage the storage location
- Working with databases or application data
- Need better performance on Docker Desktop

### Use Bind Mounts When:
- You need to share configuration files from host
- Development environments where you edit files on host
- You need full control over the host directory structure
- Sharing source code during development

## Security Considerations
- Use read-only mounts when containers only need to read data
- Be careful with bind mounts as they can access host filesystem
- Regularly backup important volume data
- Use named volumes instead of anonymous volumes for important data

## Performance Tips
- Volumes generally perform better than bind mounts
- Avoid mounting large directories unnecessarily
- Use .dockerignore to exclude unnecessary files in build context
EOF

# TODO: Add your own team-specific volume-naming convention to this file

cat ~/docker-lab/volume-best-practices.md
```

---

## 🛠️ Troubleshooting Common Issues

<details>
<summary>🔴 Issue 1: Permission Denied Errors</summary>

If you encounter permission issues with bind mounts:

```bash
# Check file ownership
ls -la ~/docker-lab/host-data/

# Fix ownership if needed
sudo chown -R $USER:$USER ~/docker-lab/host-data/
```

</details>

<details>
<summary>🔴 Issue 2: Volume Not Found</summary>

If Docker cannot find a volume:

```bash
# List all volumes
docker volume ls

# Inspect specific volume
docker volume inspect volume-name

# Recreate if necessary
docker volume create volume-name
```

</details>

<details>
<summary>🔴 Issue 3: Container Cannot Write to Volume</summary>

Check if the volume is mounted as read-only:

```bash
# Remove :ro flag if present
docker run -v volume-name:/path container-name

# Instead of
docker run -v volume-name:/path:ro container-name
```

</details>

<details>
<summary>🔴 Issue 4: Disk Space Issues</summary>

Monitor Docker disk usage:

```bash
docker system df
docker system df -v

# Clean up if needed
docker system prune -f
docker volume prune -f
```

</details>

---

## ✅ Lab Verification

Ensure you have completed all tasks by verifying:

- [ ] **Docker Installation:** Docker is installed and running
  ```bash
  docker --version
  docker info
  ```
- [ ] **Volume Creation:** Named volumes were created successfully
  ```bash
  docker volume ls | grep -E "(my-data-volume|app-logs|app-config|database-data)"
  ```
- [ ] **Data Persistence:** Data persists across container restarts
  ```bash
  docker run --rm -v my-data-volume:/data ubuntu:20.04 ls -la /data
  ```
- [ ] **Bind Mounts:** Host directory changes are reflected in containers
  ```bash
  ls -la ~/docker-lab/host-data/
  ```
- [ ] **Cleanup:** Unnecessary containers and volumes are removed
  ```bash
  docker ps -a
  docker volume ls
  ```

---

## 📚 Key Concepts

| Concept | Description |
|---|---|
| 📦 **Named Volumes** | Docker-managed storage, independent of any single container's lifecycle |
| 🔗 **Bind Mounts** | Direct mapping of a host directory/file into a container — host and container see the same files live |
| 🔒 **Read-Only Mounts (`:ro`)** | Restrict a container to reading mounted data without modifying it |
| ♻️ **Data Persistence** | Volumes/mounts let data outlive container stop, restart, or removal |
| 💽 **Backup & Restore** | `tar` through a throwaway container is a simple, portable way to snapshot volume data |
| 🧰 **`docker system df -v`** | Shows detailed disk usage per image, container, and volume |

---

## 🏁 Conclusion

In this comprehensive lab, you have successfully learned how to work with Docker volumes and bind mounts. You accomplished the following key objectives:

### 🏆 Technical Skills Gained

- ✅ Created and managed Docker volumes using command-line tools
- ✅ Implemented bind mounts to connect host directories with containers
- ✅ Verified data persistence across container lifecycle operations
- ✅ Performed backup and restore operations on volume data
- ✅ Applied security best practices with read-only mounts

### 🌍 Practical Applications

- 📦 Understanding when to use volumes versus bind mounts
- 🗄️ Managing persistent data for database containers
- 🔗 Sharing configuration files between host and containers
- ⏱️ Implementing development workflows with real-time file synchronization

### 💡 Why This Matters

Data persistence is crucial in containerized applications. Without proper volume management, all data would be lost when containers are removed. The skills you learned enable you to:

- 🏗️ Build robust, production-ready containerized applications
- 💽 Implement proper data backup and recovery strategies
- 🖥️ Create development environments that integrate seamlessly with your host system
- 🔐 Ensure data integrity and availability in containerized services

These foundational concepts are essential for anyone working with Docker in development, testing, or production environments. The ability to properly manage persistent data is what transforms containers from simple, ephemeral processes into powerful, stateful applications that can handle real-world workloads.

---

<div align="center">

![Al Nafi](https://img.shields.io/badge/Al_Nafi-Cybersecurity_Training-6A0DAD?style=for-the-badge)

</div>
