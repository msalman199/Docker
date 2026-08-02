<div align="center">

# 🏗️ Efficient Dockerfile Creation

### Multi-Stage Builds, Image Optimization, and Security Hardening

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Node.js](https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=nodedotjs&logoColor=white)
![TypeScript](https://img.shields.io/badge/TypeScript-3178C6?style=for-the-badge&logo=typescript&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Flask](https://img.shields.io/badge/Flask-000000?style=for-the-badge&logo=flask&logoColor=white)
![Alpine](https://img.shields.io/badge/Alpine_Linux-0D597F?style=for-the-badge&logo=alpinelinux&logoColor=white)

![Level](https://img.shields.io/badge/Level-Intermediate-blue?style=for-the-badge)
![Duration](https://img.shields.io/badge/Duration-150_min-orange?style=for-the-badge)
![Platform](https://img.shields.io/badge/Platform-Al_Nafi_Cloud_Labs-6A0DAD?style=for-the-badge)

</div>

---

## 📑 Table of Contents

- [🎯 Objectives](#-objectives)
- [📋 Prerequisites](#-prerequisites)
- [🖥️ Lab Environment Setup](#️-lab-environment-setup)
- [🔧 Task 1: Build a Basic Dockerfile and Verify It Works](#-task-1-build-a-basic-dockerfile-and-verify-it-works)
- [🏗️ Task 2: Implement and Compare Multi-Stage Builds](#️-task-2-implement-and-compare-multi-stage-builds)
- [🔐 Task 3: Apply Production-Grade Best Practices and Security Hardening](#-task-3-apply-production-grade-best-practices-and-security-hardening)
- [📈 Expected Outcomes](#-expected-outcomes)
- [🛠️ Troubleshooting Common Issues](#️-troubleshooting-common-issues)
- [📚 Key Concepts](#-key-concepts)
- [✅ Conclusion](#-conclusion)

---

## 🎯 Objectives

By the end of this lab, you will be able to:

| # | Objective |
|---|-----------|
| 1 | Create and structure basic Dockerfiles for containerizing applications |
| 2 | Implement multi-stage builds to significantly reduce image sizes |
| 3 | Apply Dockerfile best practices for optimal performance and security |
| 4 | Build, tag, and test Docker images using command-line tools |
| 5 | Compare image sizes, layer counts, and security posture before and after optimization |

---

## 📋 Prerequisites

| Requirement | Details |
|---|---|
| 🐧 Linux CLI | Basic understanding of Linux command line operations |
| 📝 Text Editors | Familiarity with text editors (nano, vim, or similar) |
| 💻 App Development | Basic knowledge of application development concepts (Node.js, Python, or similar) |
| 📦 Containerization | Understanding of containerization fundamentals |

> **📝 Note:** This lab installs Docker Engine directly, so no prior Docker installation is required. All other tools (Node.js, Python, TypeScript) run **inside containers** — you do not need to install them on the host.

---

## 🖥️ Lab Environment Setup

> **📝 Note:** Al Nafi provides Linux-based cloud machines for this lab. Simply click **Start Lab** to access your dedicated Linux environment. The provided machine is bare metal with no pre-installed tools, so you will install Docker and other required tools during the lab exercises.

> **⚠️ Important Note:** All tasks in this lab will be performed on a single Linux machine. No additional virtual machines or remote hosts are required.

![Docker](https://img.shields.io/badge/Docker_Engine-2496ED?style=flat-square&logo=docker&logoColor=white) ![APT](https://img.shields.io/badge/APT-E95420?style=flat-square&logo=ubuntu&logoColor=white)

> 🔖 **Step Sign:** *Install the engine once, up front — every task after this runs entirely inside containers.*

Install Docker Engine before starting Task 1:

```bash
# 📥 Update the package index
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

# 👤 Add current user to docker group
sudo usermod -aG docker $USER

# 🔄 Apply group membership for this shell session
newgrp docker

# ✅ Verify installation
docker --version
docker run hello-world
```

You should see `Hello from Docker!` printed after the `hello-world` container runs. Create the lab working directory:

```bash
mkdir -p ~/docker-lab6/{simple-app,multi-stage-app,optimized-app,security-demo}
cd ~/docker-lab6
```

---

## 🔧 Task 1: Build a Basic Dockerfile and Verify It Works

![Node.js](https://img.shields.io/badge/Node.js-339933?style=flat-square&logo=nodedotjs&logoColor=white) ![Docker](https://img.shields.io/badge/Dockerfile-2496ED?style=flat-square&logo=docker&logoColor=white)

> 🔖 **Step Sign:** *Start naive on purpose — a full `node:18` image gives you an honest baseline to optimize against later.*

### 📦 Step 1.1: Create a Simple Node.js Application

```bash
cd ~/docker-lab6/simple-app
```

```javascript
// 🟢 app.js
const http = require('http');
const os = require('os');

const server = http.createServer((req, res) => {
    res.writeHead(200, { 'Content-Type': 'text/html' });
    res.end(`
        <h1>Simple Docker App</h1>
        <p>Hostname: ${os.hostname()}</p>
        <p>Platform: ${os.platform()}</p>
        <p>Architecture: ${os.arch()}</p>
        <p>Node.js Version: ${process.version}</p>
        <p>Current Time: ${new Date().toISOString()}</p>
    `);
});

const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
```

```json
{
  "name": "simple-docker-app",
  "version": "1.0.0",
  "description": "A simple Node.js app for Docker demonstration",
  "main": "app.js",
  "scripts": {
    "start": "node app.js"
  },
  "author": "Docker Lab Student",
  "license": "MIT"
}
```

### 🔨 Step 1.2: Write, Build, and Test the Basic Dockerfile

```dockerfile
# 🟢 Use official Node.js runtime as base image
FROM node:18

# 📂 Set working directory in container
WORKDIR /usr/src/app

# 📋 Copy package.json and package-lock.json (if available)
COPY package*.json ./

# 📦 Install app dependencies
RUN npm install

# 📋 Copy app source code
COPY . .

# 🔌 Expose port 3000
EXPOSE 3000

# TODO: Add your own HEALTHCHECK instruction here (see Task 2/3 for examples)

# ▶️ Define command to run the application
CMD ["npm", "start"]
```

```bash
# 🔨 Build the image
docker build -t simple-node-app:v1.0 .

# 📏 Check the image size
docker images simple-node-app:v1.0

# ▶️ Run and test the container
docker run -d -p 3000:3000 --name simple-app-container simple-node-app:v1.0
sleep 2
curl http://localhost:3000
docker logs simple-app-container

# ⏹️ Stop and remove the container
docker stop simple-app-container
docker rm simple-app-container
```

> **📦 Deliverable:** The output of `docker images simple-node-app:v1.0` showing an image built on `node:18` (typically 900MB–1.1GB), and a successful `curl` response containing the `<h1>Simple Docker App</h1>` heading with hostname, platform, and Node.js version details. Record this size — it is your baseline for comparison in Task 2.

---

## 🏗️ Task 2: Implement and Compare Multi-Stage Builds

![TypeScript](https://img.shields.io/badge/TypeScript-3178C6?style=flat-square&logo=typescript&logoColor=white) ![Alpine](https://img.shields.io/badge/Alpine-0D597F?style=flat-square&logo=alpinelinux&logoColor=white)

> 🔖 **Step Sign:** *Build tools and dev dependencies don't belong in production — multi-stage builds let you throw the whole compiler away after it's done its job.*

### 📝 Step 2.1: Create a TypeScript Application Requiring a Build Step

```bash
cd ~/docker-lab6/multi-stage-app
```

```typescript
// 📘 app.ts
interface ServerInfo {
    hostname: string;
    platform: string;
    architecture: string;
    nodeVersion: string;
    currentTime: string;
    uptime: number;
}

import * as http from 'http';
import * as os from 'os';

const server = http.createServer((req: http.IncomingMessage, res: http.ServerResponse) => {
    const serverInfo: ServerInfo = {
        hostname: os.hostname(),
        platform: os.platform(),
        architecture: os.arch(),
        nodeVersion: process.version,
        currentTime: new Date().toISOString(),
        uptime: Math.floor(process.uptime())
    };

    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify(serverInfo, null, 2));
});

const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
    console.log(`TypeScript server running on port ${PORT}`);
});
```

```json
{
  "name": "multi-stage-app",
  "version": "1.0.0",
  "description": "Multi-stage Docker build example",
  "main": "dist/app.js",
  "scripts": {
    "build": "tsc",
    "start": "node dist/app.js"
  },
  "devDependencies": {
    "typescript": "^5.0.0",
    "@types/node": "^18.0.0"
  },
  "author": "Docker Lab Student",
  "license": "MIT"
}
```

```json
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "outDir": "./dist",
    "rootDir": "./",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true
  },
  "include": ["*.ts"],
  "exclude": ["node_modules", "dist"]
}
```

Create an inefficient single-stage build for later comparison:

```dockerfile
# 🐢 Dockerfile.single-stage
FROM node:18

WORKDIR /usr/src/app

COPY package*.json ./
COPY tsconfig.json ./

# 📦 Install all dependencies (including dev dependencies) and never clean up
RUN npm install

COPY app.ts ./

RUN npm run build

EXPOSE 3000

CMD ["npm", "start"]
```

### 🚀 Step 2.2: Create the Optimized Multi-Stage Dockerfile

```dockerfile
# 🏗️ Build stage
FROM node:18-alpine AS builder

WORKDIR /usr/src/app

COPY package*.json ./
COPY tsconfig.json ./

# 📦 Install dependencies (including dev dependencies needed for building)
RUN npm install

COPY app.ts ./

RUN npm run build

# 🏃 Production stage
FROM node:18-alpine AS production

WORKDIR /usr/src/app

COPY package*.json ./

# 📦 Install only production dependencies
RUN npm install --only=production && npm cache clean --force

# 📋 Copy only the compiled output from the builder stage
COPY --from=builder /usr/src/app/dist ./dist

# 👤 Create non-root user for security
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

RUN chown -R nodejs:nodejs /usr/src/app

USER nodejs

EXPOSE 3000

# ❤️ Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD node -e "require('http').get('http://localhost:3000', (res) => { process.exit(res.statusCode === 200 ? 0 : 1) })"

CMD ["npm", "start"]
```

Build both images, compare sizes, and test the optimized container:

```bash
# 🔨 Build single-stage image
docker build -f Dockerfile.single-stage -t typescript-app:single-stage .

# 🔨 Build multi-stage image
docker build -t typescript-app:multi-stage .

# ⚖️ Compare image sizes
echo "=== Image Size Comparison ==="
docker images | grep typescript-app

# ▶️ Run the multi-stage container
docker run -d -p 3001:3000 --name multi-stage-container typescript-app:multi-stage

# ⏳ Wait for health check to pass, then test
sleep 5
curl http://localhost:3001
docker inspect multi-stage-container --format='{{.State.Health.Status}}'

# ✅ Confirm the container runs as a non-root user
docker exec multi-stage-container whoami

# 🧹 Clean up
docker stop multi-stage-container
docker rm multi-stage-container
```

> **📦 Deliverable:** A side-by-side size comparison from `docker images | grep typescript-app` showing `typescript-app:single-stage` (built on full `node:18`, includes dev dependencies and the TypeScript compiler, typically 950MB+) versus `typescript-app:multi-stage` (built on `node:18-alpine` with only the compiled `dist` folder and production dependencies, typically under 180MB). The `curl` output must show a JSON object with `hostname`, `platform`, `nodeVersion`, and `uptime` fields, the health status must report `healthy`, and `whoami` must return `nodejs` (not `root`).

---

## 🔐 Task 3: Apply Production-Grade Best Practices and Security Hardening

![Python](https://img.shields.io/badge/Python-3776AB?style=flat-square&logo=python&logoColor=white) ![Flask](https://img.shields.io/badge/Flask-000000?style=flat-square&logo=flask&logoColor=white) ![Gunicorn](https://img.shields.io/badge/Gunicorn-499848?style=flat-square&logo=gunicorn&logoColor=white)

> 🔖 **Step Sign:** *Correctness and small size aren't enough in production — lock the container down so a compromised process has almost nothing to work with.*

### 🐍 Step 3.1: Build an Optimized, Non-Root Python Flask Image

```bash
cd ~/docker-lab6/optimized-app
```

```python
# 🐍 app.py
from flask import Flask, jsonify
import os
import platform
import sys
from datetime import datetime

app = Flask(__name__)

@app.route('/')
def get_info():
    return jsonify({
        'message': 'Optimized Docker Application',
        'hostname': os.uname().nodename,
        'platform': platform.platform(),
        'python_version': sys.version,
        'current_time': datetime.now().isoformat(),
        'environment': os.environ.get('ENVIRONMENT', 'development')
    })

@app.route('/health')
def health_check():
    return jsonify({'status': 'healthy'}), 200

# TODO: Add a /metrics or /version route to extend this API

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=int(os.environ.get('PORT', 5000)))
```

```text
# 📄 requirements.txt
Flask==2.3.3
gunicorn==21.2.0
```

```text
# 🚫 .dockerignore
.git
.gitignore
README.md
*.md
__pycache__
*.pyc
*.pyo
.venv/
venv/
.coverage
*.log
.DS_Store
.vscode/
.idea/
```

Create the multi-stage, security-hardened production Dockerfile:

```dockerfile
# 🏗️ Build stage: install dependencies
FROM python:3.11-slim-bullseye AS dependencies

ENV PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

# 🏃 Production stage
FROM python:3.11-slim-bullseye AS production

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONHASHSEED=random \
    PATH="/home/appuser/.local/bin:$PATH" \
    ENVIRONMENT=production

# 👤 Create non-root user with explicit UID/GID
RUN groupadd --gid 1000 appuser && \
    useradd --uid 1000 --gid appuser --shell /bin/bash --create-home appuser

WORKDIR /app

# 📋 Copy installed Python packages from the build stage
COPY --from=dependencies --chown=appuser:appuser /root/.local /home/appuser/.local

# 📋 Copy application code
COPY --chown=appuser:appuser app.py .

USER appuser

EXPOSE 5000

# 🏷️ Metadata
LABEL maintainer="Docker Lab Student" \
      version="1.0" \
      description="Optimized Python Flask application"

# ❤️ Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:5000/health', timeout=5)"

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "2", "--timeout", "30", "app:app"]
```

```bash
# 🔨 Build the image
docker build -t flask-app:advanced .

# 📜 Verify layer count is minimized
docker history flask-app:advanced
```

### 🛡️ Step 3.2: Run with Hardened Runtime Security Options and Validate

```bash
# 🔒 Run with strict container security restrictions
docker run -d \
    --name flask-secure \
    --read-only \
    --tmpfs /tmp \
    --cap-drop ALL \
    --cap-add NET_BIND_SERVICE \
    --no-new-privileges \
    -p 5000:5000 \
    flask-app:advanced

# ⏳ Give the health check time to run
sleep 8

# 🌐 Test application endpoints
curl http://localhost:5000/
curl http://localhost:5000/health

# ✅ Verify the process runs as non-root
docker exec flask-secure whoami
docker exec flask-secure id

# ❤️ Verify the health check reports healthy
docker inspect flask-secure --format='{{.State.Health.Status}}'

# 🔒 Confirm the read-only filesystem blocks writes outside tmpfs
docker exec flask-secure sh -c "touch /test-file" 2>&1 || echo "Filesystem is read-only (expected)"

# 📊 Review resource usage
docker stats flask-secure --no-stream

# 🧹 Clean up
docker stop flask-secure
docker rm flask-secure
```

Finally, run a full comparison across every image built in this lab:

```bash
cd ~/docker-lab6

echo "=== Final Image Size Comparison ==="
docker images --format "table {{.Repository}}:{{.Tag}}\t{{.Size}}" | grep -E "(simple-node-app|typescript-app|flask-app)"

echo "=== Layer Counts ==="
for image in $(docker images --format "{{.Repository}}:{{.Tag}}" | grep -E "(simple-node-app|typescript-app|flask-app)"); do
    layers=$(docker history "$image" --quiet | wc -l)
    echo "$image: $layers layers"
done
```

> **📦 Deliverable:** The `docker inspect flask-secure --format='{{.State.Health.Status}}'` command must print `healthy`. The `whoami` output must be `appuser`, not `root`. The read-only filesystem test must print `Filesystem is read-only (expected)`. The final comparison table must show `flask-app:advanced` at roughly 150–190MB versus the ~1GB `simple-node-app:v1.0` baseline from Task 1, demonstrating the cumulative effect of slim base images, multi-stage builds, and dependency pruning.

---

## 📈 Expected Outcomes

- ✅ A working baseline Docker image (Task 1) and a documented, reproducible size/layer comparison between single-stage and multi-stage builds (Task 2) showing **at least a 5x reduction** in image size
- ✅ A production-ready, non-root, health-checked Flask image (Task 3) that runs successfully under restrictive runtime security flags (`--read-only`, `--cap-drop ALL`, `--no-new-privileges`)
- ✅ Command-line evidence (via `docker images`, `docker history`, and `docker inspect`) that you can independently verify optimization and security claims rather than taking them on faith

---

## 🛠️ Troubleshooting Common Issues

<details>
<summary>🔴 Build fails with permission errors during COPY --chown</summary>

Ensure the user and group referenced in `--chown` were created earlier in that same build stage with `groupadd`/`useradd` or `addgroup`/`adduser` before the `COPY` instruction runs.

</details>

<details>
<summary>🔴 Health check never becomes healthy</summary>

Confirm the `--start-period` gives the application enough time to bind to its port, and that the health check command (`curl`, `urllib.request`, or the Node.js `http.get` check) targets the correct port exposed by the container.

</details>

<details>
<summary>🔴 --read-only container fails to start</summary>

Applications that write temporary files (cache, logs, sockets) need a writable `tmpfs` mount, such as `--tmpfs /tmp`, even when the root filesystem is read-only.

</details>

<details>
<summary>🔴 Multi-stage COPY --from=builder fails</summary>

Verify the stage name in `FROM node:18-alpine AS builder` exactly matches the name referenced in `COPY --from=builder`, and that the source path inside the builder stage actually exists after the `RUN` build step completes.

</details>

---

## 📚 Key Concepts

| Concept | Description |
|---|---|
| 🏗️ **Multi-Stage Build** | Uses separate `FROM` stages so build tools and dev dependencies never ship in the final image |
| 🪶 **Alpine / Slim Base Images** | Minimal base images that dramatically cut image size compared to full distributions |
| 👤 **Non-Root User (`USER`)** | Running as a dedicated unprivileged user limits the blast radius of a container compromise |
| ❤️ **`HEALTHCHECK`** | Lets Docker (and orchestrators) know whether a container is actually serving traffic, not just running |
| 🔒 **`--read-only` / `--cap-drop ALL`** | Runtime flags that remove filesystem write access and Linux capabilities the process doesn't need |
| 🧅 **Layer Count (`docker history`)** | Fewer, well-ordered layers improve build caching and reduce image bloat |
| 🚫 **`.dockerignore`** | Keeps unnecessary files out of the build context, speeding up builds and shrinking images |

---

## ✅ Conclusion

In this lab you progressed from a naive, single-stage Dockerfile to a fully optimized, security-hardened, multi-stage production image, verifying every improvement with concrete command-line output rather than assumptions.

- ✅ Built a basic Node.js container and measured its baseline size
- ✅ Rebuilt a TypeScript application using a multi-stage Dockerfile to strip out build tools and dev dependencies, cutting the image size by roughly **80 percent** while adding a working health check
- ✅ Hardened a Python Flask application with a non-root user, minimal base image, dependency-only build stage, and restrictive runtime flags such as `--read-only` and `--cap-drop ALL`, confirming the container still functioned correctly under those constraints

Together these three tasks demonstrate the full Dockerfile optimization lifecycle: **functional correctness, layer and size efficiency, and runtime security**.

### 🌍 Next Steps

- 🔍 Scan your built images with a tool such as Trivy or Docker Scout to detect known vulnerabilities in base images and dependencies
- 🎼 Orchestrate these services together with Docker Compose
- ☸️ Explore how the same multi-stage, non-root patterns apply when deploying to Kubernetes

---

<div align="center">

![Al Nafi](https://img.shields.io/badge/Al_Nafi-Cybersecurity_Training-6A0DAD?style=for-the-badge)

</div>
