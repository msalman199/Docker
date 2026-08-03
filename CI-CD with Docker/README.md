# 🚀 Docker CI/CD Pipeline with GitHub Actions

![Docker](https://img.shields.io/badge/Docker-Containerization-2496ED?logo=docker&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub%20Actions-CI%2FCD-2088FF?logo=github-actions&logoColor=white)
![Node.js](https://img.shields.io/badge/Node.js-18-339933?logo=node.js&logoColor=white)
![Express](https://img.shields.io/badge/Express.js-4.18-000000?logo=express&logoColor=white)
![Docker Hub](https://img.shields.io/badge/Docker%20Hub-Registry-2496ED?logo=docker&logoColor=white)
![Git](https://img.shields.io/badge/Git-Version%20Control-F05032?logo=git&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-Cloud%20Environment-FCC624?logo=linux&logoColor=black)
![YAML](https://img.shields.io/badge/YAML-Workflow-000000?logo=yaml&logoColor=white)
![Trivy](https://img.shields.io/badge/Trivy-Security%20Scanning-1904DA?logo=aqua&logoColor=white)
![Docker Compose](https://img.shields.io/badge/Docker%20Compose-Orchestration-2496ED?logo=docker&logoColor=white)

> 🧑‍💻 **Hands-on DevOps Lab:** Build a complete Docker-based CI/CD pipeline that automatically tests code, builds container images, pushes them to Docker Hub, and prepares applications for staging and production deployment.

---

## 📌 Table of Contents

- [🎯 Project Overview](#-project-overview)
- [🎓 Learning Objectives](#-learning-objectives)
- [🧰 Technology Stack](#-technology-stack)
- [🏗️ Architecture](#️-architecture)
- [📋 Prerequisites](#-prerequisites)
- [⚙️ Task 1 — Environment Setup](#️-task-1--environment-setup)
- [🐙 Task 2 — GitHub Repository & Actions](#-task-2--github-repository--actions)
- [🐳 Task 3 — Docker Build & Docker Hub](#-task-3--docker-build--docker-hub)
- [🚀 Task 4 — CI/CD Deployment](#-task-4--cicd-deployment)
- [🔐 Task 5 — Security & Advanced Features](#-task-5--security--advanced-features)
- [🧪 Verification & Testing](#-verification--testing)
- [🛠️ Troubleshooting](#️-troubleshooting)
- [🧹 Cleanup](#-cleanup)
- [📁 Project Structure](#-project-structure)
- [🏆 Skills Demonstrated](#-skills-demonstrated)
- [✅ Conclusion](#-conclusion)

---

## 🎯 Project Overview

This lab demonstrates how to create a modern **Docker CI/CD pipeline** using **GitHub Actions**.

The pipeline follows the complete software delivery flow:

```text
👨‍💻 Developer
     │
     ▼
📦 Git Repository
     │
     ▼
⚙️ GitHub Actions
     │
     ├── 🧪 Test Application
     │
     ├── 🐳 Build Docker Image
     │
     ├── 🔐 Security Scanning
     │
     └── 📤 Push Image to Docker Hub
                 │
                 ▼
          🚀 Deployment
          ├── 🧪 Staging
          └── 🏭 Production
                 │
                 ▼
          📊 Monitoring
                 │
                 ▼
          🔄 Rollback if needed
```

The application is a lightweight **Node.js + Express** web service packaged as a Docker container.

---

## 🎓 Learning Objectives

By completing this lab, you will learn how to:

- ⚙️ Configure GitHub Actions for automated CI/CD.
- 🐳 Build Docker images automatically.
- 📤 Push Docker images to Docker Hub.
- 🚀 Automate deployment workflows.
- 🧪 Run application tests in CI.
- 🔐 Add container vulnerability scanning.
- 🌍 Support staging and production environments.
- 📊 Monitor running containers.
- 🔄 Perform application rollbacks.
- 📈 Run basic performance testing.
- 🧩 Use Docker Compose for local development.
- 🛡️ Apply practical Docker CI/CD best practices.

---

## 🧰 Technology Stack

| Technology | Purpose |
|---|---|
| 🐧 **Linux** | Lab and container host environment |
| 🐳 **Docker** | Containerization and image management |
| 🐙 **GitHub** | Source-code repository |
| ⚙️ **GitHub Actions** | CI/CD automation |
| 📦 **Docker Hub** | Container image registry |
| 🟢 **Node.js 18** | Application runtime |
| 🚂 **Express.js** | Web application framework |
| 📝 **YAML** | GitHub Actions configuration |
| 🔀 **Git** | Version control |
| 🧩 **Docker Compose** | Local/multi-environment container management |
| 🔐 **Trivy** | Container vulnerability scanning |
| 📊 **Apache Bench** | Performance testing |
| 🖥️ **GitHub CLI** | Repository and workflow management |

---

# ⚙️ Task 1 — Environment Setup

## 🔄 Step 1.1 — Update Linux and Install Tools

```bash
sudo apt update && sudo apt upgrade -y

sudo apt install -y curl wget git vim nano unzip
```

### 🏷️ Technologies

`Linux` `APT` `Git` `Curl` `Wget`

---

## 🐳 Step 1.2 — Install Docker

```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

sudo usermod -aG docker $USER

sudo systemctl start docker
sudo systemctl enable docker

docker --version
```

### ✨ Verification

```bash
docker --version
docker info
```

### 🏷️ Technologies

`Docker` `Linux` `systemd`

---

## 🐙 Step 1.3 — Install GitHub CLI

```bash
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
| sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
| sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

sudo apt update
sudo apt install gh -y

gh --version
```

### 🏷️ Technologies

`GitHub CLI` `GitHub` `APT`

---

## 🟢 Step 1.4 — Create Node.js Application

Create the project:

```bash
mkdir ~/docker-cicd-lab
cd ~/docker-cicd-lab
```

Create `package.json`:

```json
{
  "name": "docker-cicd-app",
  "version": "1.0.0",
  "description": "Sample app for Docker CI/CD lab",
  "main": "server.js",
  "scripts": {
    "start": "node server.js",
    "test": "echo \"Test passed\" && exit 0"
  },
  "dependencies": {
    "express": "^4.18.2"
  }
}
```

Create `server.js`:

```javascript
const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.get('/', (req, res) => {
  res.json({
    message: 'Hello from Docker CI/CD Lab!',
    version: '1.0.0',
    timestamp: new Date().toISOString()
  });
});

app.get('/health', (req, res) => {
  res.json({
    status: 'healthy',
    uptime: process.uptime()
  });
});

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
```

### 🏷️ Technologies

`Node.js` `Express.js` `JavaScript` `HTTP API`

---

## 🐳 Step 1.5 — Create Dockerfile

```dockerfile
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm install --only=production

COPY . .

EXPOSE 3000

USER node

CMD ["npm", "start"]
```

Create `.dockerignore`:

```text
node_modules
npm-debug.log
.git
.gitignore
README.md
.env
.nyc_output
coverage
```

### 🏷️ Technologies

`Dockerfile` `Node.js` `Alpine Linux` `Containerization`

---

# 🐙 Task 2 — GitHub Repository & Actions

## 🔀 Step 2.1 — Initialize Git

```bash
git init
git add .
git commit -m "Initial commit: Docker CI/CD lab application"
```

Authenticate:

```bash
gh auth login
```

Create and push the GitHub repository:

```bash
gh repo create docker-cicd-lab --public --source=. --remote=origin --push
```

### 🏷️ Technologies

`Git` `GitHub` `GitHub CLI`

---

## ⚙️ Step 2.2 — Create GitHub Actions Workflow

```bash
mkdir -p .github/workflows
```

Create:

```text
.github/workflows/docker-cicd.yml
```

The workflow performs:

```text
📥 Checkout
   ↓
🟢 Setup Node.js
   ↓
📦 Install Dependencies
   ↓
🧪 Run Tests
   ↓
🐳 Build Docker Image
   ↓
🔐 Login to Docker Hub
   ↓
📤 Push Image
   ↓
🚀 Deployment Preparation
```

The workflow uses:

- `actions/checkout@v4`
- `actions/setup-node@v4`
- `docker/setup-buildx-action@v3`
- `docker/login-action@v3`
- `docker/metadata-action@v5`
- `docker/build-push-action@v5`

### 🏷️ Technologies

`GitHub Actions` `Docker Buildx` `Docker Hub` `CI/CD`

---

## 🔐 Step 2.3 — Configure GitHub Secrets

Set the Docker Hub credentials:

```bash
read -p "Enter your Docker Hub username: " DOCKER_USERNAME
gh secret set DOCKER_USERNAME --body "$DOCKER_USERNAME"

echo "Enter your Docker Hub password or access token:"
read -s DOCKER_PASSWORD
gh secret set DOCKER_PASSWORD --body "$DOCKER_PASSWORD"
```

Verify:

```bash
gh secret list
```

> 🔒 **Security Note:** Never commit Docker Hub passwords, access tokens, API keys, or other credentials directly into Git.

### 🏷️ Technologies

`GitHub Secrets` `Docker Hub Authentication` `DevSecOps`

---

# 🐳 Task 3 — Docker Build & Docker Hub

## 🧪 Step 3.1 — Test Docker Build Locally

```bash
docker build -t docker-cicd-app:test .
```

Run the container:

```bash
docker run -d \
  --name test-app \
  -p 3000:3000 \
  docker-cicd-app:test
```

Test the application:

```bash
sleep 5

curl http://localhost:3000
curl http://localhost:3000/health
```

Clean up:

```bash
docker stop test-app
docker rm test-app
docker rmi docker-cicd-app:test
```

### 🏷️ Technologies

`Docker Build` `Docker Run` `Curl` `REST API`

---

## 🎛️ Step 3.2 — Manual Deployment Workflow

Create:

```text
.github/workflows/manual-deploy.yml
```

The workflow supports:

- 🧪 Staging deployment
- 🏭 Production deployment
- 🏷️ Custom Docker image tags
- 📥 Image pull and verification
- 🚀 Environment-specific deployment scripts

Trigger it from GitHub Actions using **Run workflow**.

### 🏷️ Technologies

`GitHub Actions` `workflow_dispatch` `Docker` `Staging` `Production`

---

## 🧩 Step 3.3 — Docker Compose

Create `docker-compose.yml` to simplify local development.

The configuration includes:

```text
app
 ├── Build from Dockerfile
 ├── Port 3000
 ├── Development environment
 ├── Volumes
 └── Health check

app-production
 ├── Docker Hub image
 ├── Port 3001
 ├── Production environment
 └── Health check
```

Run:

```bash
docker compose up -d
```

Check:

```bash
docker compose ps
```

Stop:

```bash
docker compose down
```

### 🏷️ Technologies

`Docker Compose` `Containers` `Health Checks` `Local Development`

---

# 🚀 Task 4 — CI/CD Deployment

## 📁 Step 4.1 — Production Deployment Script

Create:

```text
scripts/deploy-production.sh
```

The script:

1. 📥 Pulls the Docker image.
2. 🛑 Stops the existing container.
3. 🗑️ Removes the old container.
4. 🚀 Starts the new container.
5. ❤️ Checks container health.
6. 📊 Displays container status.

Run:

```bash
./scripts/deploy-production.sh your-docker-username latest
```

### 🏷️ Technologies

`Bash` `Docker` `Production Deployment` `Health Checks`

---

## 🧪 Step 4.2 — Staging Deployment

Create:

```text
scripts/deploy-staging.sh
```

Run:

```bash
./scripts/deploy-staging.sh your-docker-username latest
```

Test:

```bash
curl http://localhost:3001
curl http://localhost:3001/health
```

### 🏷️ Technologies

`Bash` `Docker` `Staging` `HTTP`

---

## 📊 Step 4.3 — Monitoring

Create:

```text
scripts/monitor.sh
```

Run:

```bash
./scripts/monitor.sh docker-cicd-app-staging
```

The script checks:

- 📦 Container status
- ❤️ Health status
- 💻 CPU usage
- 🧠 Memory usage
- 🌐 Network usage
- 📜 Recent logs
- 🔍 Container details

### 🏷️ Technologies

`Docker Stats` `Docker Logs` `Container Monitoring`

---

## 🔄 Step 4.4 — Rollback

Create:

```text
scripts/rollback.sh
```

Run:

```bash
./scripts/rollback.sh your-docker-username previous docker-cicd-app-production 80
```

Rollback process:

```text
🔴 Current Version
       ↓
📥 Pull Previous Image
       ↓
🛑 Stop Current Container
       ↓
🗑️ Remove Current Container
       ↓
🚀 Start Previous Image
       ↓
✅ Application Restored
```

### 🏷️ Technologies

`Docker` `Bash` `Rollback` `Release Management`

---

## 📤 Step 4.5 — Trigger the CI/CD Pipeline

```bash
git add .

git commit -m "Add comprehensive CI/CD pipeline with Docker integration"

git push origin main
```

Check workflow runs:

```bash
gh run list
```

Watch the latest run:

```bash
gh run watch
```

### 🏷️ Technologies

`Git` `GitHub Actions` `CI/CD Automation`

---

# 🔐 Task 5 — Security & Advanced Features

## 🛡️ Step 5.1 — Container Security Scanning

Create:

```text
.github/workflows/security-scan.yml
```

The workflow integrates **Trivy** for vulnerability scanning.

It also runs:

```bash
npm audit --audit-level moderate
```

Security workflow:

```text
📥 Checkout
   ↓
🔍 Trivy Container Scan
   ↓
📄 SARIF Report
   ↓
🛡️ GitHub Security Results
   ↓
📦 npm Audit
```

### 🏷️ Technologies

`Trivy` `GitHub Security` `SARIF` `npm Audit` `DevSecOps`

---

## 🌍 Step 5.2 — Multi-Environment Configuration

Create:

```text
config/environments/staging.env
config/environments/production.env
```

### 🧪 Staging

```text
NODE_ENV=staging
PORT=3000
LOG_LEVEL=debug
API_TIMEOUT=30000
CACHE_TTL=300
```

### 🏭 Production

```text
NODE_ENV=production
PORT=3000
LOG_LEVEL=info
API_TIMEOUT=10000
CACHE_TTL=3600
```

Compose files:

```text
docker-compose.staging.yml
docker-compose.prod.yml
```

### 🏷️ Technologies

`Docker Compose` `Environment Configuration` `Staging` `Production`

---

## 📈 Step 5.3 — Performance Testing

Create:

```text
scripts/performance-test.sh
```

Run:

```bash
./scripts/performance-test.sh http://localhost:3000 30s 10
```

The script uses **Apache Bench (`ab`)** to test:

- ⏱️ Request duration
- 👥 Concurrent connections
- 📊 Request handling
- ❤️ Health endpoint performance

### 🏷️ Technologies

`Apache Bench` `Performance Testing` `HTTP` `Bash`

---

# 🧪 Verification & Testing

## 🔄 Trigger Pipeline

```bash
echo "# Docker CI/CD Lab" > README.md

git add .
git commit -m "Update README and add advanced CI/CD features"
git push origin main
```

Check:

```bash
gh run list --limit 5
```

---

## 📦 Check Containers

```bash
docker ps
```

Test staging:

```bash
curl -s http://localhost:3001
curl -s http://localhost:3001/health
```

Test production:

```bash
curl -s http://localhost:8080
curl -s http://localhost:8080/health
```

---

# 🏗️ Project Structure

```text
docker-cicd-lab/
│
├── 📄 Dockerfile
├── 📄 .dockerignore
├── 📄 package.json
├── 📄 server.js
├── 📄 README.md
│
├── 🐙 .github/
│   └── workflows/
│       ├── docker-cicd.yml
│       ├── manual-deploy.yml
│       └── security-scan.yml
│
├── ⚙️ config/
│   └── environments/
│       ├── staging.env
│       └── production.env
│
├── 🐳 docker-compose.yml
├── 🐳 docker-compose.override.yml
├── 🐳 docker-compose.prod.yml
├── 🧪 docker-compose.staging.yml
│
└── 📁 scripts/
    ├── deploy-production.sh
    ├── deploy-staging.sh
    ├── monitor.sh
    ├── rollback.sh
    └── performance-test.sh
```

---

# 🔧 Troubleshooting

## ❌ Issue 1 — Docker Permission Denied

```bash
sudo usermod -aG docker $USER
newgrp docker
```

If required, log out and log back in.

---

## ❌ Issue 2 — GitHub Actions Failure

```bash
gh run list --limit 10
gh run view --log
gh secret list
```

Check:

- Workflow syntax
- Repository secrets
- Docker Hub credentials
- Branch configuration
- GitHub Actions logs

---

## ❌ Issue 3 — Docker Hub Push Failure

Test authentication:

```bash
docker login
```

Test Docker Hub:

```bash
docker pull hello-world

docker tag hello-world $DOCKER_USERNAME/test
docker push $DOCKER_USERNAME/test

docker rmi $DOCKER_USERNAME/test
```

---

## ❌ Issue 4 — Container Health Check Failure

Check logs:

```bash
docker logs docker-cicd-app-staging
```

Inspect health:

```bash
docker inspect docker-cicd-app-staging | grep -A 10 Health
```

Test endpoint:

```bash
curl -v http://localhost:3001/health
```

---

# 🧹 Cleanup

Stop containers:

```bash
docker stop $(docker ps -q --filter "name=docker-cicd-app") 2>/dev/null || true
```

Remove containers:

```bash
docker rm $(docker ps -aq --filter "name=docker-cicd-app") 2>/dev/null || true
```

Remove project images:

```bash
docker rmi $(docker images "$DOCKER_USERNAME/docker-cicd-app" -q) 2>/dev/null || true
```

Clean unused Docker resources:

```bash
docker system prune -f
```

---

# 🏆 Skills Demonstrated

### ☁️ DevOps & CI/CD
- GitHub Actions
- Automated testing
- Automated Docker builds
- Image publishing
- Deployment automation
- Manual deployment workflows

### 🐳 Containerization
- Dockerfile creation
- Docker image management
- Docker Compose
- Container health checks
- Multi-platform image builds

### 🔐 DevSecOps
- GitHub Secrets
- Trivy vulnerability scanning
- npm audit
- SARIF security reporting

### 🚀 Deployment Engineering
- Staging deployments
- Production deployments
- Environment-specific configuration
- Rollback automation
- Deployment verification

### 📊 Operations
- Container monitoring
- Docker logs
- Resource monitoring
- Health checks
- Performance testing

### 🧑‍💻 Automation
- Bash scripting
- GitHub CLI
- Git
- YAML-based pipeline configuration

---

# 🌟 CI/CD Best-Practice Flow

```text
             ┌──────────────────────┐
             │ 👨‍💻 Code Change      │
             └──────────┬───────────┘
                        │
                        ▼
             ┌──────────────────────┐
             │ 🔀 Git Push / PR     │
             └──────────┬───────────┘
                        │
                        ▼
             ┌──────────────────────┐
             │ ⚙️ GitHub Actions    │
             └──────────┬───────────┘
                        │
              ┌─────────┴─────────┐
              ▼                   ▼
       🧪 Automated Tests    🔐 Security Scan
              │                   │
              └─────────┬─────────┘
                        ▼
             ┌──────────────────────┐
             │ 🐳 Docker Build      │
             └──────────┬───────────┘
                        │
                        ▼
             ┌──────────────────────┐
             │ 📦 Docker Hub        │
             └──────────┬───────────┘
                        │
                        ▼
             ┌──────────────────────┐
             │ 🚀 Deployment        │
             └──────────┬───────────┘
                        │
               ┌────────┴────────┐
               ▼                 ▼
           🧪 Staging        🏭 Production
               │                 │
               └────────┬────────┘
                        ▼
                 📊 Monitoring
                        │
                        ▼
                  🔄 Rollback
```

---

# 🎯 Final Outcome

After completing this lab, you have a practical Docker CI/CD environment capable of:

- ✅ Automated testing
- ✅ Automated Docker image builds
- ✅ Docker Hub image publishing
- ✅ Staging and production deployment preparation
- ✅ Manual deployment workflows
- ✅ Security vulnerability scanning
- ✅ Environment-specific configuration
- ✅ Container health checks
- ✅ Monitoring and logging
- ✅ Rollback support
- ✅ Performance testing

---

# 🏁 Conclusion

This lab demonstrates how modern **DevOps and CI/CD practices** can transform a simple Node.js application into an automated container delivery workflow.

The final solution connects:

**Git → GitHub → GitHub Actions → Tests → Docker Build → Docker Hub → Deployment → Monitoring → Rollback**

This provides a strong foundation for building reliable, repeatable, and automated application delivery pipelines.

---

## 👨‍💻 Author

**Hafiz Muhammad Salman**

Cloud DevOps Engineer | Linux Administrator

---

## ⭐ If You Found This Useful

If this project helped you learn Docker CI/CD, consider giving the repository a ⭐ and sharing your learning journey with the DevOps community.

> 🚀 **Automate Everything. Containerize Everything. Deploy with Confidence.**
