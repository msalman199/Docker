# 🐳 Cross-Platform Builds with Docker

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge\&logo=docker\&logoColor=white)
![Docker Buildx](https://img.shields.io/badge/Docker%20Buildx-2496ED?style=for-the-badge\&logo=docker\&logoColor=white)
![QEMU](https://img.shields.io/badge/QEMU-FF6600?style=for-the-badge\&logo=qemu\&logoColor=white)
![Node.js](https://img.shields.io/badge/Node.js-18-339933?style=for-the-badge\&logo=node.js\&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-000000?style=for-the-badge\&logo=linux\&logoColor=white)
![Docker Hub](https://img.shields.io/badge/Docker%20Hub-2496ED?style=for-the-badge\&logo=docker\&logoColor=white)
![ARM64](https://img.shields.io/badge/Architecture-ARM64-green?style=for-the-badge)
![AMD64](https://img.shields.io/badge/Architecture-AMD64-blue?style=for-the-badge)

> 🚀 **Build once, run anywhere!**
>
> This lab demonstrates how to build, publish, inspect, and test **multi-architecture Docker images** for both **AMD64** and **ARM64** platforms using Docker Buildx and QEMU.

---

## 📌 Table of Contents

* [🎯 Overview](#-overview)
* [🎓 Learning Objectives](#-learning-objectives)
* [📋 Prerequisites](#-prerequisites)
* [🛠️ Lab Environment](#️-lab-environment)
* [🏗️ Architecture](#️-architecture)
* [⚙️ Task 1 - Set Up Buildx](#️-task-1---set-up-buildx-for-arm-and-amd64)
* [🏗️ Task 2 - Build Multi-Architecture Images](#️-task-2---build-docker-images-for-multiple-platforms)
* [☁️ Task 3 - Push Images to Docker Hub](#️-task-3---push-multi-architecture-images-to-docker-hub)
* [🔍 Task 4 - Verification and Testing](#-task-4---verification-and-testing)
* [⚡ Advanced Configuration](#-advanced-configuration)
* [🚨 Troubleshooting](#-troubleshooting)
* [🧹 Cleanup](#-cleanup)
* [📊 Key Commands](#-key-commands)
* [🎯 Real-World Use Cases](#-real-world-use-cases)
* [🏆 Conclusion](#-conclusion)

---

# 🎯 Overview

Modern applications may need to run on different CPU architectures.

The two most common architectures are:

* 🖥️ **AMD64 / x86_64** — Traditional servers, desktops, and many cloud instances
* 📱 **ARM64 / aarch64** — Apple Silicon, AWS Graviton, Raspberry Pi, IoT, and edge devices

Docker Buildx allows developers to create a **single Docker image tag containing multiple architecture-specific images**.

For example:

```text
cross-platform-demo:latest
        │
        ├── linux/amd64
        │
        └── linux/arm64
```

When a user runs:

```bash
docker pull cross-platform-demo:latest
```

Docker automatically selects the image appropriate for the host architecture.

---

# 🎓 Learning Objectives

By completing this lab, you will learn how to:

* 🐳 Understand multi-architecture Docker images
* ⚙️ Configure Docker Buildx
* 🏗️ Create custom Buildx builders
* 🖥️ Build images for AMD64
* 📱 Build images for ARM64
* 🔄 Use QEMU for architecture emulation
* 📦 Create multi-stage Dockerfiles
* ☁️ Push multi-platform images to Docker Hub
* 🔍 Inspect Docker image manifests
* 🧪 Test images on different architectures
* ⚡ Optimize Docker builds using cache mounts
* 🛠️ Troubleshoot Buildx and QEMU problems

---

# 📋 Prerequisites

Before starting this lab, you should have:

* Basic Docker knowledge
* Basic Linux command-line knowledge
* Understanding of Dockerfiles
* Familiarity with `docker build`
* Understanding of AMD64 and ARM64
* A Docker Hub account
* Basic knowledge of container registries

---

# 🛠️ Lab Environment

This lab uses the **Al Nafi cloud Linux environment**.

The provided machine is bare metal with no pre-installed tools, so Docker and other required utilities are installed during the lab.

### Required Components

| Component         | Purpose                  |
| ----------------- | ------------------------ |
| 🐳 Docker Engine  | Container runtime        |
| 🏗️ Docker Buildx | Multi-platform builds    |
| 🔄 QEMU           | Architecture emulation   |
| 📦 Docker Hub     | Image registry           |
| 🟢 Node.js        | Sample application       |
| 🌐 Express        | Web framework            |
| 🔎 jq             | JSON manifest inspection |
| 🐧 Linux          | Build environment        |

---

# 🏗️ Architecture

The lab demonstrates the following workflow:

```text
                   ┌──────────────────────┐
                   │   Node.js Application │
                   └──────────┬───────────┘
                              │
                              ▼
                   ┌──────────────────────┐
                   │      Dockerfile      │
                   └──────────┬───────────┘
                              │
                              ▼
                   ┌──────────────────────┐
                   │    Docker Buildx     │
                   └──────────┬───────────┘
                              │
                    ┌─────────┴─────────┐
                    │                   │
                    ▼                   ▼
              ┌───────────┐       ┌───────────┐
              │  AMD64    │       │   ARM64   │
              │ x86_64    │       │ aarch64   │
              └─────┬─────┘       └─────┬─────┘
                    │                   │
                    └─────────┬─────────┘
                              ▼
                    ┌──────────────────┐
                    │   Docker Hub     │
                    │ Multi-Arch Image │
                    └──────────────────┘
```

---

# ⚙️ Task 1 - Set Up Buildx for ARM and AMD64

## 🐳 1.1 Install Docker Engine

Update the package index:

```bash
sudo apt update
```

Install required packages:

```bash
sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release
```

Add Docker's official GPG key:

```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```

Configure the Docker repository:

```bash
echo "deb [arch=$(dpkg --print-architecture) \
signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

Update repositories:

```bash
sudo apt update
```

Install Docker:

```bash
sudo apt install -y docker-ce docker-ce-cli containerd.io
```

Add the current user to the Docker group:

```bash
sudo usermod -aG docker $USER
```

Apply the group changes:

```bash
newgrp docker
```

---

## 🔎 1.2 Verify Docker Installation

Check Docker:

```bash
docker --version
```

Test Docker:

```bash
docker run hello-world
```

Expected result:

```text
Hello from Docker!
Your installation appears to be working correctly.
```

---

## 🏗️ 1.3 Enable Docker Buildx

Check Buildx:

```bash
docker buildx version
```

List builders:

```bash
docker buildx ls
```

Create a dedicated multi-platform builder:

```bash
docker buildx create \
  --name multiarch-builder \
  --driver docker-container \
  --use
```

Bootstrap the builder:

```bash
docker buildx inspect --bootstrap
```

Verify supported platforms:

```bash
docker buildx inspect --bootstrap
```

You should see platforms such as:

```text
linux/amd64
linux/arm64
```

---

# 🔄 1.4 Install QEMU

QEMU enables architecture emulation when building ARM64 images on AMD64 systems.

Install QEMU:

```bash
sudo apt install -y qemu-user-static
```

Register QEMU interpreters:

```bash
docker run --rm --privileged \
multiarch/qemu-user-static \
--reset -p yes
```

Verify supported platforms:

```bash
docker buildx inspect --bootstrap
```

---

# 🏗️ Task 2 - Build Docker Images for Multiple Platforms

## 📁 2.1 Create the Sample Application

Create the project:

```bash
mkdir cross-platform-app
cd cross-platform-app
```

Create `package.json`:

```bash
cat > package.json << 'EOF'
{
  "name": "cross-platform-demo",
  "version": "1.0.0",
  "description": "Demo app for cross-platform Docker builds",
  "main": "server.js",
  "scripts": {
    "start": "node server.js"
  },
  "dependencies": {
    "express": "^4.18.2"
  }
}
EOF
```

Create `server.js`:

```bash
cat > server.js << 'EOF'
const express = require('express');
const os = require('os');

const app = express();
const PORT = process.env.PORT || 3000;

app.get('/', (req, res) => {
  res.json({
    message: 'Hello from Cross-Platform Docker!',
    platform: os.platform(),
    architecture: os.arch(),
    hostname: os.hostname(),
    uptime: os.uptime()
  });
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
  console.log(`Platform: ${os.platform()}`);
  console.log(`Architecture: ${os.arch()}`);
});
EOF
```

---

# 🐳 2.2 Create a Multi-Stage Dockerfile

Create the Dockerfile:

```bash
cat > Dockerfile << 'EOF'
FROM node:18-alpine AS builder

WORKDIR /app

COPY package*.json ./

RUN npm ci --only=production

FROM node:18-alpine AS production

RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

WORKDIR /app

COPY --from=builder /app/node_modules ./node_modules

COPY --chown=nodejs:nodejs . .

USER nodejs

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000', (res) => { process.exit(res.statusCode === 200 ? 0 : 1) })"

CMD ["npm", "start"]
EOF
```

### 🔐 Dockerfile Security Features

This Dockerfile includes:

* 🏗️ Multi-stage builds
* 👤 Non-root user
* ❤️ Health checks
* 📦 Alpine Linux base image
* ⚡ Production-only dependencies
* 📉 Reduced final image size

---

# 🧪 2.3 Build an AMD64 Image

Build the image:

```bash
docker buildx build \
  --platform linux/amd64 \
  -t cross-platform-demo:amd64 \
  --load .
```

Run it:

```bash
docker run -d \
  --name test-app \
  -p 3000:3000 \
  cross-platform-demo:amd64
```

Wait for the application:

```bash
sleep 5
```

Test the application:

```bash
curl http://localhost:3000
```

Example response:

```json
{
  "message": "Hello from Cross-Platform Docker!",
  "platform": "linux",
  "architecture": "x64"
}
```

Stop the container:

```bash
docker stop test-app
```

Remove it:

```bash
docker rm test-app
```

---

# 🌍 2.4 Build Multi-Architecture Images

Build for AMD64 and ARM64:

```bash
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t cross-platform-demo:multi \
  .
```

### ⚠️ Important

The `--load` option is generally intended for loading a **single-platform** image into the local Docker image store.

For multi-platform images, use a registry:

```bash
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t yourusername/cross-platform-demo:multi \
  --push .
```

---

# 🔍 2.5 Inspect Build Information

Check the builder:

```bash
docker buildx inspect
```

Check supported platforms:

```bash
docker buildx inspect --bootstrap | grep Platforms
```

Check build cache:

```bash
docker buildx du
```

---

# ☁️ Task 3 - Push Multi-Architecture Images to Docker Hub

## 🔐 3.1 Login to Docker Hub

```bash
docker login
```

Verify the login:

```bash
docker info | grep Username
```

---

# 🏷️ 3.2 Set Docker Hub Username

Replace `yourusername` with your Docker Hub username:

```bash
DOCKER_USERNAME="yourusername"
```

Build and push:

```bash
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t ${DOCKER_USERNAME}/cross-platform-demo:latest \
  -t ${DOCKER_USERNAME}/cross-platform-demo:v1.0 \
  --push .
```

---

# 🔎 3.3 Inspect the Multi-Architecture Manifest

Inspect the image:

```bash
docker buildx imagetools inspect \
${DOCKER_USERNAME}/cross-platform-demo:latest
```

For JSON output:

```bash
docker buildx imagetools inspect \
${DOCKER_USERNAME}/cross-platform-demo:latest \
--format "{{json .}}" | jq
```

If `jq` is missing:

```bash
sudo apt install -y jq
```

Then:

```bash
docker buildx imagetools inspect \
${DOCKER_USERNAME}/cross-platform-demo:latest \
--format "{{json .}}" | jq
```

---

# 🧪 3.4 Test AMD64 and ARM64 Images

### 🖥️ AMD64

```bash
docker pull \
  --platform linux/amd64 \
  ${DOCKER_USERNAME}/cross-platform-demo:latest
```

Test:

```bash
docker run --rm \
  --platform linux/amd64 \
  ${DOCKER_USERNAME}/cross-platform-demo:latest \
  node -e "console.log('Platform:', process.platform, 'Arch:', process.arch)"
```

Expected:

```text
Platform: linux Arch: x64
```

### 📱 ARM64

```bash
docker pull \
  --platform linux/arm64 \
  ${DOCKER_USERNAME}/cross-platform-demo:latest
```

Test:

```bash
docker run --rm \
  --platform linux/arm64 \
  ${DOCKER_USERNAME}/cross-platform-demo:latest \
  node -e "console.log('Platform:', process.platform, 'Arch:', process.arch)"
```

Expected:

```text
Platform: linux Arch: arm64
```

---

# 🏷️ 3.5 Create Additional Tags

Build and push multiple tags:

```bash
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t ${DOCKER_USERNAME}/cross-platform-demo:latest \
  -t ${DOCKER_USERNAME}/cross-platform-demo:stable \
  -t ${DOCKER_USERNAME}/cross-platform-demo:$(date +%Y%m%d) \
  --push .
```

Verify:

```bash
docker buildx imagetools inspect \
${DOCKER_USERNAME}/cross-platform-demo:stable
```

---

# 🔧 Advanced Configuration and Troubleshooting

## 🏗️ Builder Management

List builders:

```bash
docker buildx ls
```

Create an advanced builder:

```bash
docker buildx create \
  --name advanced-builder \
  --driver docker-container \
  --driver-opt network=host \
  --buildkitd-flags '--allow-insecure-entitlement security.insecure' \
  --use
```

Switch builders:

```bash
docker buildx use advanced-builder
```

Remove a builder:

```bash
docker buildx rm multiarch-builder
```

---

# ⚡ Build Optimization

Create an optimized Dockerfile:

```bash
cat > Dockerfile.optimized << 'EOF'
FROM node:18-alpine AS builder

WORKDIR /app

COPY package*.json ./

RUN --mount=type=cache,target=/root/.npm \
    npm ci --only=production

FROM node:18-alpine AS production

RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

WORKDIR /app

COPY --from=builder /app/node_modules ./node_modules
COPY --chown=nodejs:nodejs . .

USER nodejs

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000', (res) => { process.exit(res.statusCode === 200 ? 0 : 1) })"

CMD ["npm", "start"]
EOF
```

Build with the optimized Dockerfile:

```bash
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -f Dockerfile.optimized \
  -t ${DOCKER_USERNAME}/cross-platform-demo:optimized \
  --push .
```

### 🚀 Optimization Benefits

The cache mount:

```dockerfile
RUN --mount=type=cache,target=/root/.npm \
    npm ci --only=production
```

can improve subsequent builds by reusing the npm package cache.

---

# 🚨 Troubleshooting

## ❌ Issue 1: QEMU Not Working

Reinstall QEMU:

```bash
sudo apt remove -y qemu-user-static
sudo apt install -y qemu-user-static
```

Register it again:

```bash
docker run --rm --privileged \
multiarch/qemu-user-static \
--reset -p yes
```

---

## ❌ Issue 2: Builder Does Not Support Multiple Platforms

Remove the builder:

```bash
docker buildx rm multiarch-builder
```

Create it again:

```bash
docker buildx create \
  --name multiarch-builder \
  --driver docker-container \
  --use
```

Bootstrap:

```bash
docker buildx inspect --bootstrap
```

---

## ❌ Issue 3: Build Fails on One Architecture

Test each architecture independently:

```bash
docker buildx build \
  --platform linux/amd64 \
  -t test:amd64 \
  .
```

Then:

```bash
docker buildx build \
  --platform linux/arm64 \
  -t test:arm64 \
  .
```

This helps identify architecture-specific problems.

---

# 🔬 Verification and Testing

## 🧪 4.1 Create a Multi-Architecture Test Script

Create:

```bash
cat > test-multiarch.sh << 'EOF'
#!/bin/bash

DOCKER_USERNAME="yourusername"
IMAGE_NAME="${DOCKER_USERNAME}/cross-platform-demo:latest"

echo "Testing multi-architecture image: ${IMAGE_NAME}"

echo "Testing AMD64 platform..."

docker run --rm \
  --platform linux/amd64 \
  ${IMAGE_NAME} \
  node -e "
const os = require('os');
console.log('Platform:', os.platform());
console.log('Architecture:', os.arch());
console.log('Node version:', process.version);
"

echo ""

echo "Testing ARM64 platform..."

docker run --rm \
  --platform linux/arm64 \
  ${IMAGE_NAME} \
  node -e "
const os = require('os');
console.log('Platform:', os.platform());
console.log('Architecture:', os.arch());
console.log('Node version:', process.version);
"

echo ""
echo "Multi-architecture test completed!"
EOF
```

Make it executable:

```bash
chmod +x test-multiarch.sh
```

Replace the username:

```bash
sed -i 's/yourusername/your-actual-username/g' test-multiarch.sh
```

Run:

```bash
./test-multiarch.sh
```

---

# 🔍 4.2 Inspect the Manifest

Detailed inspection:

```bash
docker buildx imagetools inspect \
${DOCKER_USERNAME}/cross-platform-demo:latest \
--raw | jq
```

Check platform information:

```bash
docker buildx imagetools inspect \
${DOCKER_USERNAME}/cross-platform-demo:latest \
| grep -E "(MediaType|Platform|Size)"
```

Expected platforms should include:

```text
linux/amd64
linux/arm64
```

---

# 🧹 Cleanup

Remove test containers and unused Docker resources:

```bash
docker system prune -f
```

Remove builders:

```bash
docker buildx rm multiarch-builder
docker buildx rm advanced-builder
```

Remove the project:

```bash
cd ..
rm -rf cross-platform-app
```

Logout from Docker Hub:

```bash
docker logout
```

---

# 📊 Key Commands

| Command                            | Purpose                   |
| ---------------------------------- | ------------------------- |
| `docker buildx ls`                 | List builders             |
| `docker buildx create`             | Create a builder          |
| `docker buildx use`                | Switch builder            |
| `docker buildx inspect`            | Inspect builder           |
| `docker buildx du`                 | Inspect build cache       |
| `docker buildx build`              | Build images              |
| `docker buildx imagetools inspect` | Inspect manifests         |
| `docker login`                     | Login to registry         |
| `docker push`                      | Push images               |
| `docker pull`                      | Pull images               |
| `docker run --platform`            | Run specific architecture |
| `docker system prune`              | Clean unused resources    |

---

# 🧠 Important Concepts

## 🖥️ AMD64

AMD64 is commonly used by:

* Traditional servers
* Cloud virtual machines
* Desktop computers
* x86-based infrastructure

Example:

```text
linux/amd64
```

---

## 📱 ARM64

ARM64 is commonly used by:

* Apple Silicon Macs
* AWS Graviton
* Raspberry Pi
* Mobile devices
* IoT systems
* Edge computing devices

Example:

```text
linux/arm64
```

---

## 🏗️ Docker Buildx

Buildx extends Docker's build functionality and provides support for:

* Multi-platform builds
* Advanced BuildKit features
* Build caching
* Custom builders
* Parallel builds
* Registry-based builds

---

## 🔄 QEMU

QEMU provides CPU architecture emulation.

In this lab, it allows an AMD64 Linux machine to build and test ARM64 containers.

```text
AMD64 Host
    │
    ▼
   QEMU
    │
    ▼
ARM64 Container
```

---

## 📦 Multi-Architecture Manifest

A multi-platform Docker tag points to multiple architecture-specific image manifests.

```text
cross-platform-demo:latest
             │
       Multi-Platform
          Manifest
             │
      ┌──────┴──────┐
      ▼             ▼
   AMD64           ARM64
```

Docker selects the appropriate image automatically based on the platform.

---

# 🎯 Real-World Use Cases

Multi-platform Docker images are useful for:

### ☁️ Cloud Computing

Deploy the same application to:

* AWS Graviton
* x86 cloud instances
* Kubernetes clusters
* Hybrid cloud infrastructure

### 🍎 Apple Silicon Development

Developers using:

* Mac M1
* Mac M2
* Mac M3
* Mac M4

can use ARM64 images while maintaining compatibility with AMD64 environments.

### 🌐 Kubernetes

Multi-architecture images make it easier to run applications across heterogeneous Kubernetes clusters.

### 📡 Edge Computing

Applications can be packaged for:

* ARM-based edge devices
* IoT systems
* Raspberry Pi
* Industrial computing devices

### 💰 Cost Optimization

ARM-based cloud infrastructure can provide attractive price/performance characteristics, allowing organizations to deploy the same application across different CPU architectures.

---

# 🏆 Skills Demonstrated

By completing this lab, the following practical skills were demonstrated:

```text
🐳 Docker
🏗️ Docker Buildx
🔄 QEMU
🖥️ AMD64
📱 ARM64
📦 Multi-Stage Builds
☁️ Docker Hub
🔍 Image Manifest Inspection
⚡ Build Cache Optimization
🧪 Container Testing
🔐 Container Security
🐧 Linux Administration
```

---

# 📝 Conclusion

In this lab, we successfully implemented a complete **cross-platform Docker image workflow**.

### ✅ Completed Tasks

* 🐳 Installed Docker Engine
* 🏗️ Configured Docker Buildx
* 🔄 Configured QEMU emulation
* 🖥️ Built AMD64 images
* 📱 Built ARM64 images
* 🌍 Created multi-architecture images
* 📦 Created a multi-stage Dockerfile
* ☁️ Published images to Docker Hub
* 🔍 Inspected multi-platform manifests
* 🧪 Tested AMD64 and ARM64 containers
* ⚡ Implemented Docker build caching
* 🛠️ Troubleshot common Buildx problems
* 🧹 Cleaned up Docker resources

---

# 🚀 Why Cross-Platform Docker Matters

Modern infrastructure is increasingly heterogeneous.

Applications may need to run on:

```text
          Modern Infrastructure
                  │
      ┌───────────┼───────────┐
      ▼           ▼           ▼
   AMD64        ARM64       Edge/IoT
      │           │           │
      └───────────┼───────────┘
                  ▼
          Docker Containers
```

Multi-architecture Docker images allow teams to maintain **one image tag** while supporting multiple CPU architectures.

This provides:

* 🌍 Greater portability
* ⚡ Flexible deployments
* 💰 Potential infrastructure cost savings
* 🧩 Simplified image management
* ☁️ Better cloud compatibility
* 📱 ARM-based platform support
* 🚀 Easier CI/CD workflows

---

# ⭐ Lab Achievement

> 🎉 **Successfully completed the Cross-Platform Builds with Docker lab!**

This project demonstrates practical experience with **Docker, Buildx, QEMU, multi-stage Docker builds, Docker Hub, ARM64, AMD64, container testing, and cloud-native deployment concepts.**

---

## 👨‍💻 Author

**Hafiz Muhammad Salman**

**Cloud DevOps Engineer | Linux Administrator**

### 🛠️ Technologies

`Docker` • `Docker Buildx` • `QEMU` • `Linux` • `Node.js` • `Express` • `Docker Hub` • `ARM64` • `AMD64` • `BuildKit`

---

## ⭐ Support

If you found this project useful, consider giving the repository a ⭐ and sharing it with other Docker and DevOps learners.

**Keep Learning • Keep Building • Keep Automating 🚀**
