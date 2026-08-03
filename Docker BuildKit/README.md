<div align="center">

# ⚡ Docker BuildKit

### A Hands-On Al Nafi Lab for High-Performance Container Image Builds

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![BuildKit](https://img.shields.io/badge/BuildKit-1D63ED?style=for-the-badge&logo=docker&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![NodeJS](https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=node.js&logoColor=white)
![Go](https://img.shields.io/badge/Go-00ADD8?style=for-the-badge&logo=go&logoColor=white)
![Docker Compose](https://img.shields.io/badge/Docker%20Compose-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white)

**Difficulty:** Intermediate • **Estimated Time:** 120–150 minutes

</div>

---

## 📖 Table of Contents

- [🎯 Lab Objectives](#-lab-objectives)
- [✅ Prerequisites](#-prerequisites)
- [🖥️ Lab Environment](#️-lab-environment)
- [🛠️ Task 1: Install Docker and Enable BuildKit](#️-task-1-install-docker-and-enable-buildkit)
- [🧪 Task 2: Create Sample Applications for BuildKit Testing](#-task-2-create-sample-applications-for-buildkit-testing)
- [🗃️ Task 3: Explore BuildKit Cache Features](#️-task-3-explore-buildkit-cache-features)
- [🏗️ Task 4: Optimize Build Performance with Multi-Stage Builds](#️-task-4-optimize-build-performance-with-multi-stage-builds)
- [🚀 Task 5: Advanced BuildKit Features](#-task-5-advanced-buildkit-features)
- [🔬 Task 6: BuildKit Debugging and Inspection](#-task-6-buildkit-debugging-and-inspection)
- [🩺 Task 7: Troubleshooting and Best Practices](#-task-7-troubleshooting-and-best-practices)
- [✅ Verification and Testing](#-verification-and-testing)
- [📊 Performance Comparison](#-performance-comparison)
- [🧹 Cleanup](#-cleanup)
- [📌 Key Concepts](#-key-concepts)
- [🏁 Conclusion](#-conclusion)

---

## 🎯 Lab Objectives

By the end of this lab, you will be able to:

| # | Objective |
|---|-----------|
| 1 | Enable and configure Docker BuildKit for enhanced build capabilities |
| 2 | Utilize BuildKit features including build cache, parallel builds, and build secrets |
| 3 | Implement multi-stage builds for optimized container images |
| 4 | Apply cache optimization techniques to improve build performance |
| 5 | Compare traditional Docker builds with BuildKit-enhanced builds |
| 6 | Troubleshoot common BuildKit configuration issues |

## ✅ Prerequisites

Before starting this lab, you should have:

- ✔️ Basic understanding of Docker concepts and commands
- ✔️ Familiarity with Dockerfile syntax and structure
- ✔️ Knowledge of Linux command line operations
- ✔️ Understanding of container image layers and caching concepts
- ✔️ Experience with basic Docker build processes

## 🖥️ Lab Environment

> **☁️ Note:** Al Nafi provides Linux-based cloud machines for this lab. Simply click **Start Lab** to access your dedicated environment. The provided Linux machine is bare metal with no pre-installed tools — you will install Docker and other required tools during the lab exercises.

---

## 🛠️ Task 1: Install Docker and Enable BuildKit

![Task Stack](https://img.shields.io/badge/Stack-Docker%20Engine-2496ED?style=flat-square&logo=docker&logoColor=white) ![Task Stack](https://img.shields.io/badge/Stack-Ubuntu-E95420?style=flat-square&logo=ubuntu&logoColor=white)

> 🚦 **Sign-in Step:** Installing Docker and flipping the BuildKit switch — both globally via the daemon and per-session via an environment variable — so every build from here on runs on the new engine.

### 🧩 Subtask 1.1: Install Docker Engine

```bash
# 🔄 Update package index
sudo apt update

# 📦 Install required packages
sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release

# 🔑 Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# ➕ Add Docker repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 🔄 Update package index again
sudo apt update

# 🐳 Install Docker Engine
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin

# 👤 Add current user to docker group
sudo usermod -aG docker $USER

# ♻️ Apply group changes
newgrp docker

# ✅ Verify Docker installation
docker --version
```

### 🧩 Subtask 1.2: Enable BuildKit Globally

```bash
# 📁 Create Docker daemon configuration directory
sudo mkdir -p /etc/docker

# 📝 Create daemon.json configuration file
sudo tee /etc/docker/daemon.json > /dev/null <<EOF
{
  "features": {
    "buildkit": true
  }
}
EOF

# ♻️ Restart Docker service to apply changes
sudo systemctl restart docker

# ✅ Verify BuildKit is enabled
docker info | grep -i buildkit
```

### 🧩 Subtask 1.3: Enable BuildKit for Current Session

```bash
# ⚡ Set BuildKit environment variable
export DOCKER_BUILDKIT=1

# ✅ Verify the environment variable is set
echo $DOCKER_BUILDKIT

# 💾 Add to bashrc for persistent sessions
echo 'export DOCKER_BUILDKIT=1' >> ~/.bashrc
```

<!-- TODO: Confirm BuildKit stays enabled after opening a fresh terminal session -->

---

## 🧪 Task 2: Create Sample Applications for BuildKit Testing

![Task Stack](https://img.shields.io/badge/Stack-Node.js-339933?style=flat-square&logo=node.js&logoColor=white) ![Task Stack](https://img.shields.io/badge/Package-npm-CB3837?style=flat-square&logo=npm&logoColor=white)

> 🚦 **Sign-in Step:** Two Dockerfiles for the same Node.js app — one traditional, one BuildKit-optimized — to give the rest of the lab something concrete to compare.

### 🧩 Subtask 2.1: Create a Node.js Application

```bash
# 📁 Create project directory
mkdir -p ~/buildkit-lab/nodejs-app
cd ~/buildkit-lab/nodejs-app

# 📝 Create package.json
cat > package.json <<EOF
{
  "name": "buildkit-demo",
  "version": "1.0.0",
  "description": "Demo app for BuildKit testing",
  "main": "server.js",
  "scripts": {
    "start": "node server.js"
  },
  "dependencies": {
    "express": "^4.18.2",
    "lodash": "^4.17.21"
  }
}
EOF

# 📝 Create server.js
cat > server.js <<EOF
const express = require('express');
const _ = require('lodash');

const app = express();
const PORT = process.env.PORT || 3000;

app.get('/', (req, res) => {
  const data = _.shuffle([1, 2, 3, 4, 5]);
  res.json({
    message: 'Hello from BuildKit Demo!',
    shuffled: data,
    timestamp: new Date().toISOString()
  });
});

app.listen(PORT, () => {
  console.log(\`Server running on port \${PORT}\`);
});
EOF
```

### 🧩 Subtask 2.2: Create Traditional Dockerfile

```bash
# 📄 Create traditional Dockerfile
cat > Dockerfile.traditional <<EOF
FROM node:18-alpine

WORKDIR /app

COPY package.json ./
RUN npm install

COPY . .

EXPOSE 3000

CMD ["npm", "start"]
EOF
```

### 🧩 Subtask 2.3: Create BuildKit-Optimized Dockerfile

```bash
# ⚡ Create BuildKit-optimized Dockerfile
cat > Dockerfile <<EOF
# syntax=docker/dockerfile:1

FROM node:18-alpine AS base
WORKDIR /app

# Install dependencies in separate layer for better caching
FROM base AS deps
COPY package.json package-lock.json* ./
RUN --mount=type=cache,target=/root/.npm \
    npm ci --only=production

# Development dependencies
FROM base AS deps-dev
COPY package.json package-lock.json* ./
RUN --mount=type=cache,target=/root/.npm \
    npm ci

# Build stage (if needed for compilation)
FROM deps-dev AS build
COPY . .
# Add any build commands here if needed

# Production stage
FROM base AS production
COPY --from=deps /app/node_modules ./node_modules
COPY . .

EXPOSE 3000
CMD ["npm", "start"]
EOF
```

<!-- TODO: Add a `RUN npm test` line to the deps-dev stage and rebuild -->

---

## 🗃️ Task 3: Explore BuildKit Cache Features

![Task Stack](https://img.shields.io/badge/Feature-Cache%20Mounts-1D63ED?style=flat-square&logo=docker&logoColor=white) ![Task Stack](https://img.shields.io/badge/Feature-Build%20Secrets-1D63ED?style=flat-square&logo=docker&logoColor=white)

> 🚦 **Sign-in Step:** The heart of BuildKit — persistent cache mounts for package managers, bind mounts for lightweight dev builds, and secret mounts that never touch a layer.

### 🧩 Subtask 3.1: Build with Cache Mount

```bash
# ⏱️ Build with cache mount (first build)
time docker build -t buildkit-demo:cache .

# ✏️ Modify server.js slightly
sed -i 's/Hello from BuildKit Demo!/Hello from BuildKit Demo - Updated!/' server.js

# ⏱️ Build again to see cache benefits
time docker build -t buildkit-demo:cache-v2 .

# ⚖️ Compare with traditional build
time docker build -f Dockerfile.traditional -t buildkit-demo:traditional .
```

### 🧩 Subtask 3.2: Use Bind Mount for Development

```bash
# 📄 Create development Dockerfile
cat > Dockerfile.dev <<EOF
# syntax=docker/dockerfile:1

FROM node:18-alpine

WORKDIR /app

# Use bind mount for package.json and install dependencies
RUN --mount=type=bind,source=package.json,target=package.json \
    --mount=type=cache,target=/root/.npm \
    npm install

# Copy application code
COPY . .

EXPOSE 3000
CMD ["npm", "start"]
EOF

# 🔨 Build development image
docker build -f Dockerfile.dev -t buildkit-demo:dev .
```

### 🧩 Subtask 3.3: Implement Build Secrets

```bash
# 🔐 Create a secret file
echo "my-secret-api-key-12345" > api-key.txt

# 📄 Create Dockerfile with secrets
cat > Dockerfile.secrets <<EOF
# syntax=docker/dockerfile:1

FROM node:18-alpine

WORKDIR /app

# Use secret during build without exposing it in layers
RUN --mount=type=secret,id=api_key \
    API_KEY=\$(cat /run/secrets/api_key) && \
    echo "Using API key for configuration..." && \
    echo "API_KEY_LENGTH=\${#API_KEY}" > .env

COPY package.json ./
RUN npm install

COPY . .

EXPOSE 3000
CMD ["npm", "start"]
EOF

# 🔨 Build with secret
docker build --secret id=api_key,src=./api-key.txt -f Dockerfile.secrets -t buildkit-demo:secrets .

# 🔍 Verify secret is not in image layers
docker history buildkit-demo:secrets
```

<!-- TODO: Inspect buildkit-demo:secrets with `docker history --no-trunc` and confirm api-key.txt's contents never appear -->

---

## 🏗️ Task 4: Optimize Build Performance with Multi-Stage Builds

![Task Stack](https://img.shields.io/badge/Stack-Go-00ADD8?style=flat-square&logo=go&logoColor=white) ![Task Stack](https://img.shields.io/badge/Base%20Image-Alpine-0D597F?style=flat-square&logo=alpinelinux&logoColor=white)

> 🚦 **Sign-in Step:** A Go application compiled in a heavyweight builder stage, then copied into a minimal Alpine runtime — the classic multi-stage pattern for tiny production images.

### 🧩 Subtask 4.1: Create Multi-Stage Build for Go Application

```bash
# 📁 Create Go application directory
mkdir -p ~/buildkit-lab/go-app
cd ~/buildkit-lab/go-app

# 📝 Create main.go
cat > main.go <<EOF
package main

import (
    "fmt"
    "log"
    "net/http"
    "time"
)

func handler(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "Hello from Go BuildKit Demo! Time: %s", time.Now().Format(time.RFC3339))
}

func main() {
    http.HandleFunc("/", handler)
    log.Println("Server starting on :8080")
    log.Fatal(http.ListenAndServe(":8080", nil))
}
EOF

# 📝 Create go.mod
cat > go.mod <<EOF
module buildkit-go-demo

go 1.21
EOF
```

### 🧩 Subtask 4.2: Create Optimized Multi-Stage Dockerfile

```bash
# 🏗️ Create multi-stage Dockerfile for Go
cat > Dockerfile <<EOF
# syntax=docker/dockerfile:1

# Build stage
FROM golang:1.21-alpine AS builder

WORKDIR /app

# Copy go mod files
COPY go.mod go.sum* ./

# Download dependencies with cache mount
RUN --mount=type=cache,target=/go/pkg/mod \
    go mod download

# Copy source code
COPY . .

# Build binary with cache mount
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    CGO_ENABLED=0 GOOS=linux go build -o main .

# Production stage
FROM alpine:latest

# Install ca-certificates for HTTPS requests
RUN apk --no-cache add ca-certificates

WORKDIR /root/

# Copy binary from builder stage
COPY --from=builder /app/main .

EXPOSE 8080

CMD ["./main"]
EOF

# 🔨 Build the Go application
docker build -t buildkit-go-demo .

# 📏 Check image size
docker images buildkit-go-demo
```

### 🧩 Subtask 4.3: Compare Build Performance

```bash
# 🧾 Create build performance test script
cat > test-build-performance.sh <<'EOF'
#!/bin/bash

echo "=== Build Performance Comparison ==="

# Test traditional build
echo "Testing traditional Docker build..."
cd ~/buildkit-lab/nodejs-app
export DOCKER_BUILDKIT=0
time docker build -f Dockerfile.traditional -t perf-test:traditional . 2>&1 | grep real

# Test BuildKit build
echo "Testing BuildKit build..."
export DOCKER_BUILDKIT=1
time docker build -t perf-test:buildkit . 2>&1 | grep real

# Test with cache (second build)
echo "Testing BuildKit with cache (second build)..."
time docker build -t perf-test:buildkit-cached . 2>&1 | grep real

echo "=== Performance test completed ==="
EOF

# ▶️ Make script executable and run
chmod +x test-build-performance.sh
./test-build-performance.sh
```

<!-- TODO: Add a third comparison row for a rebuild after only touching a comment line -->

---

## 🚀 Task 5: Advanced BuildKit Features

![Task Stack](https://img.shields.io/badge/Feature-Parallel%20Stages-1D63ED?style=flat-square&logo=docker&logoColor=white) ![Task Stack](https://img.shields.io/badge/Orchestration-Docker%20Compose-2496ED?style=flat-square&logo=docker&logoColor=white)

> 🚦 **Sign-in Step:** Independent build stages running side by side, Compose wired up for BuildKit, and cache exported to disk so it can travel between machines.

### 🧩 Subtask 5.1: Parallel Builds with BuildKit

```bash
# 🧩 Create complex multi-stage Dockerfile with parallel stages
cd ~/buildkit-lab/nodejs-app

cat > Dockerfile.parallel <<EOF
# syntax=docker/dockerfile:1

FROM node:18-alpine AS base
WORKDIR /app

# Stage 1: Install production dependencies
FROM base AS prod-deps
COPY package.json package-lock.json* ./
RUN --mount=type=cache,target=/root/.npm \
    npm ci --only=production

# Stage 2: Install all dependencies (runs in parallel with prod-deps)
FROM base AS all-deps
COPY package.json package-lock.json* ./
RUN --mount=type=cache,target=/root/.npm \
    npm ci

# Stage 3: Run tests (depends on all-deps)
FROM all-deps AS test
COPY . .
RUN npm test || echo "Tests would run here"

# Stage 4: Build application (depends on all-deps, runs parallel with test)
FROM all-deps AS build
COPY . .
RUN echo "Build process would run here"

# Final stage: Production image
FROM base AS production
COPY --from=prod-deps /app/node_modules ./node_modules
COPY --from=build /app .

EXPOSE 3000
CMD ["npm", "start"]
EOF

# 🔨 Build with parallel stages
docker build -f Dockerfile.parallel -t buildkit-demo:parallel .
```

### 🧩 Subtask 5.2: Use BuildKit with Docker Compose

```bash
# 📝 Create docker-compose.yml
cat > docker-compose.yml <<EOF
version: '3.8'

services:
  web:
    build:
      context: .
      dockerfile: Dockerfile
      args:
        BUILDKIT_INLINE_CACHE: 1
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production

  go-app:
    build:
      context: ../go-app
      dockerfile: Dockerfile
    ports:
      - "8080:8080"

networks:
  default:
    name: buildkit-network
EOF

# 🔨 Build services with BuildKit
DOCKER_BUILDKIT=1 docker-compose build

# ▶️ Start services
docker-compose up -d

# 🌐 Test services
curl http://localhost:3000
curl http://localhost:8080

# 🛑 Stop services
docker-compose down
```

### 🧩 Subtask 5.3: Export Build Cache

```bash
# 💾 Build with cache export
docker build \
  --cache-to type=local,dest=/tmp/buildkit-cache \
  --cache-from type=local,src=/tmp/buildkit-cache \
  -t buildkit-demo:cached .

# 📂 List cache contents
ls -la /tmp/buildkit-cache/

# 🔨 Build another image using the exported cache
cd ~/buildkit-lab/go-app
docker build \
  --cache-from type=local,src=/tmp/buildkit-cache \
  -t buildkit-go-demo:cached .
```

<!-- TODO: Delete the local image and rebuild from the exported cache only, then time the difference -->

---

## 🔬 Task 6: BuildKit Debugging and Inspection

![Task Stack](https://img.shields.io/badge/Tool-docker%20buildx-2496ED?style=flat-square&logo=docker&logoColor=white) ![Task Stack](https://img.shields.io/badge/Format-JSON-000000?style=flat-square&logo=json&logoColor=white)

> 🚦 **Sign-in Step:** Turning on verbose build output, standing up a `buildx` builder, and capturing structured metadata for every build.

### 🧩 Subtask 6.1: Enable BuildKit Debug Output

```bash
# 🔍 Build with debug output
BUILDKIT_PROGRESS=plain docker build -t buildkit-demo:debug .

# 🧰 Use buildx for more detailed output
docker buildx build --progress=plain -t buildkit-demo:buildx .
```

### 🧩 Subtask 6.2: Inspect Build History

```bash
# 📥 Install buildx if not available
docker buildx version || {
  mkdir -p ~/.docker/cli-plugins
  curl -L https://github.com/docker/buildx/releases/latest/download/buildx-v0.11.2.linux-amd64 -o ~/.docker/cli-plugins/docker-buildx
  chmod +x ~/.docker/cli-plugins/docker-buildx
}

# 🏗️ Create and use buildx builder
docker buildx create --name mybuilder --use
docker buildx inspect --bootstrap

# 📝 Build with detailed metadata
docker buildx build \
  --metadata-file /tmp/build-metadata.json \
  --progress=plain \
  -t buildkit-demo:metadata .

# 🔎 Examine metadata
cat /tmp/build-metadata.json | python3 -m json.tool
```

### 🧩 Subtask 6.3: Monitor Build Performance

```bash
# 📊 Create build monitoring script
cat > monitor-build.sh <<'EOF'
#!/bin/bash

BUILD_START=$(date +%s)
echo "Starting build at $(date)"

# Monitor system resources during build
(
  while true; do
    echo "$(date): CPU: $(top -bn1 | grep "Cpu(s)" | awk '{print $2}'), Memory: $(free -h | grep Mem | awk '{print $3"/"$2}')"
    sleep 2
  done
) &
MONITOR_PID=$!

# Run the build
docker build -t buildkit-demo:monitored .

# Stop monitoring
kill $MONITOR_PID 2>/dev/null

BUILD_END=$(date +%s)
BUILD_TIME=$((BUILD_END - BUILD_START))
echo "Build completed in ${BUILD_TIME} seconds"
EOF

# ▶️ Make executable and run
chmod +x monitor-build.sh
./monitor-build.sh
```

<!-- TODO: Add memory-peak tracking (not just a live sample) to monitor-build.sh -->

---

## 🩺 Task 7: Troubleshooting and Best Practices

![Task Stack](https://img.shields.io/badge/Focus-Cache%20Invalidation-D93F3F?style=flat-square&logo=docker&logoColor=white) ![Task Stack](https://img.shields.io/badge/Focus-Garbage%20Collection-1D63ED?style=flat-square&logo=docker&logoColor=white)

> 🚦 **Sign-in Step:** Diagnosing the single most common Dockerfile mistake — a `COPY . .` placed before dependency installs — and tuning BuildKit's cache garbage collector.

### 🧩 Subtask 7.1: Common BuildKit Issues

```bash
# 🐌 Create problematic Dockerfile
cat > Dockerfile.problematic <<EOF
FROM node:18-alpine

WORKDIR /app

# This will cause cache invalidation on every build
COPY . .
RUN npm install

EXPOSE 3000
CMD ["npm", "start"]
EOF

# 🔨 Build and identify the issue
docker build -f Dockerfile.problematic -t buildkit-demo:problematic .

# ✅ Create fixed version
cat > Dockerfile.fixed <<EOF
# syntax=docker/dockerfile:1

FROM node:18-alpine

WORKDIR /app

# Copy package files first for better caching
COPY package.json package-lock.json* ./

# Install dependencies with cache mount
RUN --mount=type=cache,target=/root/.npm \
    npm ci

# Copy application code last
COPY . .

EXPOSE 3000
CMD ["npm", "start"]
EOF

# 🔨 Build fixed version
docker build -f Dockerfile.fixed -t buildkit-demo:fixed .
```

### 🧩 Subtask 7.2: BuildKit Configuration Optimization

```bash
# ⚙️ Create optimized BuildKit configuration
sudo tee /etc/docker/daemon.json > /dev/null <<EOF
{
  "features": {
    "buildkit": true
  },
  "builder": {
    "gc": {
      "enabled": true,
      "defaultKeepStorage": "20GB",
      "policy": [
        {
          "keepStorage": "10GB",
          "filter": ["unused-for=2160h"]
        },
        {
          "keepStorage": "50GB",
          "filter": ["unused-for=168h"]
        }
      ]
    }
  }
}
EOF

# ♻️ Restart Docker to apply configuration
sudo systemctl restart docker

# ✅ Verify configuration
docker system df
docker builder prune --help
```

### 🧩 Subtask 7.3: Clean Up BuildKit Cache

```bash
# 📏 Check current disk usage
docker system df

# 🧹 Clean up build cache
docker builder prune

# 🕒 Clean up with specific filters
docker builder prune --filter until=24h

# ⚠️ Clean up everything (use with caution)
docker builder prune -a

# 📏 Check disk usage after cleanup
docker system df
```

<!-- TODO: Time a build against Dockerfile.problematic after changing just a comment, and compare to Dockerfile.fixed -->

---

## ✅ Verification and Testing

![Task Stack](https://img.shields.io/badge/Type-Smoke%20Tests-2ECC71?style=flat-square&logo=checkmarx&logoColor=white)

> 🚦 **Sign-in Step:** A five-point smoke test confirming BuildKit itself, cache mounts, multi-stage builds, secrets, and `buildx` are all working end to end.

### 🧩 Test BuildKit Features

```bash
# 🧪 Create comprehensive test script
cat > verify-buildkit.sh <<'EOF'
#!/bin/bash

echo "=== BuildKit Verification Tests ==="

# Test 1: Verify BuildKit is enabled
echo "Test 1: Checking BuildKit status..."
if docker info | grep -q "BuildKit"; then
    echo "✓ BuildKit is enabled"
else
    echo "✗ BuildKit is not enabled"
fi

# Test 2: Test cache mount functionality
echo "Test 2: Testing cache mount..."
cd ~/buildkit-lab/nodejs-app
if docker build -q -t test-cache . > /dev/null 2>&1; then
    echo "✓ Cache mount build successful"
else
    echo "✗ Cache mount build failed"
fi

# Test 3: Test multi-stage build
echo "Test 3: Testing multi-stage build..."
cd ~/buildkit-lab/go-app
if docker build -q -t test-multistage . > /dev/null 2>&1; then
    echo "✓ Multi-stage build successful"
else
    echo "✗ Multi-stage build failed"
fi

# Test 4: Test secret mount
echo "Test 4: Testing secret mount..."
cd ~/buildkit-lab/nodejs-app
if [ -f api-key.txt ] && docker build --secret id=api_key,src=./api-key.txt -f Dockerfile.secrets -q -t test-secrets . > /dev/null 2>&1; then
    echo "✓ Secret mount build successful"
else
    echo "✗ Secret mount build failed"
fi

# Test 5: Test buildx functionality
echo "Test 5: Testing buildx..."
if docker buildx version > /dev/null 2>&1; then
    echo "✓ Buildx is available"
else
    echo "✗ Buildx is not available"
fi

echo "=== Verification completed ==="
EOF

# ▶️ Run verification tests
chmod +x verify-buildkit.sh
./verify-buildkit.sh
```

<!-- TODO: Add a 6th test that asserts buildkit-go-demo's image size is under 20MB -->

---

## 📊 Performance Comparison

![Task Stack](https://img.shields.io/badge/Metric-Build%20Time-F39C12?style=flat-square&logo=speedtest&logoColor=white)

> 🚦 **Sign-in Step:** The payoff step — traditional build vs. cold BuildKit build vs. warm cached BuildKit build, all timed back to back.

```bash
# 🏁 Create final performance test
cat > final-performance-test.sh <<'EOF'
#!/bin/bash

echo "=== Final Performance Comparison ==="

cd ~/buildkit-lab/nodejs-app

# Clean up existing images
docker rmi -f $(docker images -q buildkit-demo:*) 2>/dev/null || true

echo "Building with traditional Docker (BUILDKIT=0)..."
export DOCKER_BUILDKIT=0
time docker build -f Dockerfile.traditional -t buildkit-demo:traditional-final . > /dev/null 2>&1

echo "Building with BuildKit (BUILDKIT=1)..."
export DOCKER_BUILDKIT=1
time docker build -t buildkit-demo:buildkit-final . > /dev/null 2>&1

echo "Rebuilding with BuildKit (should use cache)..."
time docker build -t buildkit-demo:buildkit-cached-final . > /dev/null 2>&1

echo "=== Image sizes ==="
docker images | grep buildkit-demo

echo "=== Performance test completed ==="
EOF

chmod +x final-performance-test.sh
./final-performance-test.sh
```

<!-- TODO: Log all three timings into a CSV like Task 5's monitor-build.sh pattern -->

---

## 🧹 Cleanup

```bash
# 🛑 Stop and remove containers
docker stop $(docker ps -aq) 2>/dev/null || true
docker rm $(docker ps -aq) 2>/dev/null || true

# 🗑️ Remove images
docker rmi $(docker images -q buildkit-demo:*) 2>/dev/null || true
docker rmi $(docker images -q buildkit-go-demo:*) 2>/dev/null || true
docker rmi $(docker images -q perf-test:*) 2>/dev/null || true
docker rmi $(docker images -q test-*) 2>/dev/null || true

# 🧹 Clean up build cache
docker builder prune -f

# 🗂️ Remove project directories
rm -rf ~/buildkit-lab

# 🧽 Remove temporary files
rm -f /tmp/build-metadata.json
rm -rf /tmp/buildkit-cache

echo "Cleanup completed successfully!"
```

---

## 📌 Key Concepts

| Concept | Purpose |
|---|---|
| `DOCKER_BUILDKIT=1` / `daemon.json` | Two ways to activate BuildKit — per-session or globally |
| `--mount=type=cache` | Persistent package-manager cache surviving across builds |
| `--mount=type=bind` | Lightweight, read-only source mounts for dev-only builds |
| `--mount=type=secret` | Build-time secrets that never land in an image layer |
| Multi-stage builds | Separate build-time and runtime images to shrink final size |
| Parallel stages | Independent stages built concurrently for faster pipelines |
| `--cache-to` / `--cache-from` | Exportable, shareable build cache across machines/CI runners |
| `docker builder prune` / GC policy | Cache lifecycle management to control disk usage |

---

## 🏁 Conclusion

In this comprehensive lab, you explored Docker BuildKit and its advanced features for efficient container builds.

### ✅ Key Accomplishments

- ⚡ **BuildKit Configuration** — enabled BuildKit both globally through Docker daemon configuration and per-session via environment variables
- 🗃️ **Cache Optimization** — implemented cache mounts for package managers, bind mounts for development workflows, and cache export/import to significantly improve build performance
- 🔐 **Build Secrets Management** — securely handled build-time secrets using BuildKit's secret mount feature, keeping sensitive information out of image layers
- 🏗️ **Multi-Stage Builds** — created optimized multi-stage builds for both Node.js and Go applications, minimizing final image size while maintaining build efficiency
- 🚀 **Parallel Processing** — explored BuildKit's ability to execute parallel build stages, reducing overall build time for complex applications
- 📊 **Performance Analysis** — conducted comprehensive comparisons between traditional Docker builds and BuildKit-enhanced builds, quantifying build-speed and cache-utilization improvements
- 🔬 **Advanced Features** — used BuildKit's debugging capabilities, metadata export, and Docker Compose integration for production-ready workflows
- 🩺 **Best Practices** — identified common Dockerfile pitfalls and applied BuildKit best-practice fixes for optimal performance

### 🌍 Real-World Applications

The skills developed in this lab are essential for modern containerized application development, where build efficiency directly impacts development velocity and CI/CD pipeline performance. BuildKit's advanced features enable faster iteration cycles, reduced resource consumption, and more secure build processes, making it an indispensable tool for professional Docker workflows.

These BuildKit techniques translate directly into real-world scenarios — local development, continuous integration pipelines, or production deployments — where every second and every megabyte saved during a build compounds across a team's entire release cadence.

---

<div align="center">

![Al Nafi](https://img.shields.io/badge/Al%20Nafi-Cybersecurity%20Training-1E3A8A?style=for-the-badge)

</div>
