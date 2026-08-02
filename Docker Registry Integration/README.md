# 🐳 Docker Registry Integration 

<p align="center">
  <img src="https://img.shields.io/badge/Docker-Containerization-2496ED?style=for-the-badge&logo=docker&logoColor=white" alt="Docker">
  <img src="https://img.shields.io/badge/Docker%20Hub-Registry-0db7ed?style=for-the-badge&logo=docker&logoColor=white" alt="Docker Hub">
  <img src="https://img.shields.io/badge/Linux-Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white" alt="Linux">
  <img src="https://img.shields.io/badge/NGINX-Web%20Server-009639?style=for-the-badge&logo=nginx&logoColor=white" alt="NGINX">
  <img src="https://img.shields.io/badge/Bash-Scripting-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white" alt="Bash">
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Registry-Public%20%26%20Private-purple?style=for-the-badge">
  <img src="https://img.shields.io/badge/Authentication-HTPasswd-orange?style=for-the-badge">
  <img src="https://img.shields.io/badge/Monitoring-Enabled-success?style=for-the-badge">
  <img src="https://img.shields.io/badge/Status-Completed-brightgreen?style=for-the-badge">
</p>

---

## 🚀 About This Lab

This project demonstrates **Docker Registry Integration**, covering the complete lifecycle of container images across **Docker Hub** and a **local private Docker Registry**.

The lab starts by preparing a Linux environment and installing Docker, then creates a sample NGINX-based application and publishes it to Docker Hub. A local private registry is subsequently deployed, configured, secured with authentication, and used for image storage and distribution.

The project also includes scripts for:

* 📊 Registry monitoring
* 🔍 Troubleshooting
* 🔐 Security checking
* ⚡ Performance comparison
* 🧹 Registry maintenance
* 📋 Lab reporting
* 🗑️ Resource cleanup

---

# 🎯 Lab Objectives

By completing this project, you will learn how to:

* 🐳 Install and configure Docker
* 👤 Create and configure a Docker Hub account
* 📦 Build custom Docker images
* ☁️ Push images to Docker Hub
* 📥 Pull images from Docker Hub
* 🏢 Configure a local private Docker Registry
* 🔄 Push and pull images from a private registry
* 🏷️ Manage image tags and versions
* 🔐 Configure registry authentication
* 📊 Monitor registry operations
* 🛠️ Troubleshoot common registry problems
* 🔒 Apply basic registry security practices
* ⚡ Compare public and private registry performance

---

# 🧰 Technologies Used

| Technology             | Purpose                               |
| ---------------------- | ------------------------------------- |
| 🐳 **Docker**          | Containerization and image management |
| ☁️ **Docker Hub**      | Public container image registry       |
| 🏢 **Docker Registry** | Local private image registry          |
| 🐧 **Ubuntu/Linux**    | Lab operating environment             |
| 🌐 **NGINX**           | Web server for sample application     |
| 💻 **Bash**            | Automation and maintenance scripts    |
| 🔐 **HTPasswd**        | Registry authentication               |
| 📝 **HTML/CSS**        | Sample web application                |
| 🔧 **cURL**            | Registry API testing                  |
| 🐍 **Python**          | JSON output formatting                |
| ⚙️ **systemd**         | Docker service management             |

---

# 📋 Prerequisites

Before starting, you should have:

* 🐧 Basic Linux command-line knowledge
* 🐳 Basic Docker knowledge
* 📦 Understanding of Docker images and containers
* 📝 Familiarity with Dockerfiles
* 🌐 Basic networking knowledge
* ✏️ Experience with `nano`, `vim`, or similar editors

> 💡 **Lab Environment:** The lab uses Linux-based cloud machines provided by **Al Nafi**. The environment starts without the required tools, so Docker and supporting packages are installed during the lab.

---

# 🏗️ Lab Architecture

```text
                         ┌──────────────────────┐
                         │      Docker Hub      │
                         │   Public Registry    │
                         └──────────┬───────────┘
                                    │
                              Push / Pull
                                    │
                                    ▼
┌────────────────────────────────────────────────────────────┐
│                     Linux Lab Machine                      │
│                                                            │
│  ┌───────────────┐       ┌─────────────────────────────┐  │
│  │ Docker Engine │──────▶│ Sample NGINX Application    │  │
│  └───────┬───────┘       └─────────────────────────────┘  │
│          │                                                 │
│          │ Push / Pull                                     │
│          ▼                                                 │
│  ┌──────────────────────────────────────────────────────┐  │
│  │       Local Private Docker Registry :5000            │  │
│  │                                                      │  │
│  │  🔐 Authentication                                   │  │
│  │  📦 Image Storage                                    │  │
│  │  🏷️ Versioned Images                                 │  │
│  └──────────────────────────────────────────────────────┘  │
└────────────────────────────────────────────────────────────┘
```

---

# 🛠️ Task 1 — Environment Preparation & Docker Installation

## 🔹 1.1 Update System

```bash
sudo apt update

sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release
```

### 🔐 Add Docker GPG Key

```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```

### 📦 Add Docker Repository

```bash
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

### 🐳 Install Docker

```bash
sudo apt update

sudo apt install -y docker-ce docker-ce-cli containerd.io
```

### 👤 Add User to Docker Group

```bash
sudo usermod -aG docker $USER
```

### ▶️ Start Docker

```bash
sudo systemctl start docker
sudo systemctl enable docker
```

> ✅ **Checkpoint:** Docker Engine is now installed and enabled as a system service.

---

# 🔍 Task 1.2 — Verify Docker

Apply the Docker group changes:

```bash
newgrp docker
```

Check Docker:

```bash
docker --version
```

Run the test container:

```bash
docker run hello-world
```

### 🎯 Expected Result

You should receive the Docker **Hello World** confirmation message.

---

# 🌐 Task 1.3 — Create Sample Application

Create the project directory:

```bash
mkdir ~/docker-registry-lab
cd ~/docker-registry-lab
```

Create the application:

```bash
cat > index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Docker Registry Lab</title>
</head>
<body>
    <h1>Welcome to Docker Registry Lab</h1>
    <p>Lab: Docker Registry Integration</p>
    <p>Version: 1.0</p>
    <p>Status: Running in Container</p>
</body>
</html>
EOF
```

Create the Dockerfile:

```dockerfile
FROM nginx:alpine

COPY index.html /usr/share/nginx/html/index.html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```

---

# 🏗️ Task 1.4 — Build Docker Image

Build the image:

```bash
docker build -t registry-lab-app:v1.0 .
```

Verify:

```bash
docker images
```

Run the application:

```bash
docker run -d \
  -p 8080:80 \
  --name test-app \
  registry-lab-app:v1.0
```

Test:

```bash
curl http://localhost:8080
```

Cleanup:

```bash
docker stop test-app
docker rm test-app
```

### 🎉 Checkpoint

```text
✅ Docker installed
✅ Docker verified
✅ Application created
✅ Dockerfile created
✅ Image built
✅ Container tested
```

---

# ☁️ Task 2 — Docker Hub Integration

## 🔹 2.1 Create Docker Hub Account

Visit Docker Hub and create an account.

Required information:

* 👤 Username
* 📧 Email
* 🔑 Password
* 📩 Email verification if required

---

# 🔐 Task 2.2 — Login to Docker Hub

```bash
docker login
```

Enter your Docker Hub credentials.

Expected result:

```text
Login Succeeded
```

---

# 🏷️ Task 2.3 — Tag Image

Replace `yourusername` with your Docker Hub username:

```bash
docker tag registry-lab-app:v1.0 \
yourusername/registry-lab-app:v1.0
```

Create the latest tag:

```bash
docker tag registry-lab-app:v1.0 \
yourusername/registry-lab-app:latest
```

Verify:

```bash
docker images | grep registry-lab-app
```

---

# 📤 Task 2.4 — Push to Docker Hub

```bash
docker push yourusername/registry-lab-app:v1.0
docker push yourusername/registry-lab-app:latest
```

### 🚀 Registry Flow

```text
Local Docker Image
       │
       │ docker push
       ▼
┌─────────────────┐
│   Docker Hub    │
│ Public Registry │
└─────────────────┘
```

---

# 📥 Task 2.5 — Pull from Docker Hub

Remove local images:

```bash
docker rmi yourusername/registry-lab-app:v1.0
docker rmi yourusername/registry-lab-app:latest
docker rmi registry-lab-app:v1.0
```

Pull the image:

```bash
docker pull yourusername/registry-lab-app:latest
```

Run it:

```bash
docker run -d \
  -p 8080:80 \
  --name hub-test \
  yourusername/registry-lab-app:latest
```

Test:

```bash
curl http://localhost:8080
```

Cleanup:

```bash
docker stop hub-test
docker rm hub-test
```

---

# 🏢 Task 3 — Local Private Docker Registry

## 🔹 3.1 Create Registry Storage

```bash
mkdir -p ~/registry-data
mkdir -p ~/registry-config
```

Create configuration:

```yaml
version: 0.1

log:
  fields:
    service: registry

storage:
  cache:
    blobdescriptor: inmemory
  filesystem:
    rootdirectory: /var/lib/registry

http:
  addr: :5000
  headers:
    X-Content-Type-Options: [nosniff]

health:
  storagedriver:
    enabled: true
    interval: 10s
    threshold: 3
```

Save it as:

```text
~/registry-config/config.yml
```

---

# 🚀 Task 3.2 — Start Private Registry

```bash
docker run -d \
  -p 5000:5000 \
  --name local-registry \
  --restart=always \
  -v ~/registry-data:/var/lib/registry \
  -v ~/registry-config/config.yml:/etc/docker/registry/config.yml \
  registry:2
```

Verify:

```bash
docker ps
```

Test registry:

```bash
curl http://localhost:5000/v2/
```

### ✅ Expected Result

The registry API should respond successfully.

---

# ⚠️ Task 3.3 — Configure Insecure Registry

Create Docker daemon configuration:

```bash
sudo mkdir -p /etc/docker
```

```bash
sudo tee /etc/docker/daemon.json << 'EOF'
{
  "insecure-registries": [
    "localhost:5000",
    "127.0.0.1:5000"
  ]
}
EOF
```

Restart Docker:

```bash
sudo systemctl restart docker
```

Restart registry:

```bash
docker start local-registry
```

Verify:

```bash
docker info | grep -A 5 "Insecure Registries"
```

> ⚠️ **Important:** The lab uses an insecure local registry for demonstration. Production registries should use TLS/HTTPS rather than relying on insecure registry configuration.

---

# 📦 Task 4 — Working with Private Registry

## 🏷️ 4.1 Tag Image

```bash
docker tag yourusername/registry-lab-app:latest \
localhost:5000/registry-lab-app:v1.0
```

```bash
docker tag yourusername/registry-lab-app:latest \
localhost:5000/registry-lab-app:latest
```

Verify:

```bash
docker images | grep registry-lab-app
```

---

# 📤 4.2 Push to Private Registry

```bash
docker push localhost:5000/registry-lab-app:v1.0
docker push localhost:5000/registry-lab-app:latest
```

Check repositories:

```bash
curl http://localhost:5000/v2/_catalog
```

Check tags:

```bash
curl http://localhost:5000/v2/registry-lab-app/tags/list
```

---

# 📥 4.3 Pull from Private Registry

Remove images:

```bash
docker rmi localhost:5000/registry-lab-app:v1.0
docker rmi localhost:5000/registry-lab-app:latest
```

Pull:

```bash
docker pull localhost:5000/registry-lab-app:latest
```

Run:

```bash
docker run -d \
  -p 8081:80 \
  --name private-test \
  localhost:5000/registry-lab-app:latest
```

Test:

```bash
curl http://localhost:8081
```

Cleanup:

```bash
docker stop private-test
docker rm private-test
```

---

# 🔄 Task 4.4 — Image Version Management

Create Version 2:

```bash
docker build \
  -f Dockerfile-v2 \
  -t registry-lab-app:v2.0 .
```

Tag for Docker Hub:

```bash
docker tag registry-lab-app:v2.0 \
yourusername/registry-lab-app:v2.0
```

Tag for private registry:

```bash
docker tag registry-lab-app:v2.0 \
localhost:5000/registry-lab-app:v2.0
```

Push to Docker Hub:

```bash
docker push yourusername/registry-lab-app:v2.0
```

Push to private registry:

```bash
docker push localhost:5000/registry-lab-app:v2.0
```

### 🏷️ Version Strategy

```text
registry-lab-app
│
├── v1.0
├── v2.0
└── latest
```

---

# 🔎 Task 4.5 — Registry Inspection

List repositories:

```bash
curl http://localhost:5000/v2/_catalog | python3 -m json.tool
```

List image tags:

```bash
curl http://localhost:5000/v2/registry-lab-app/tags/list | \
python3 -m json.tool
```

Inspect manifest:

```bash
curl \
-H "Accept: application/vnd.docker.distribution.manifest.v2+json" \
http://localhost:5000/v2/registry-lab-app/manifests/v2.0 | \
python3 -m json.tool
```

Check storage:

```bash
du -sh ~/registry-data
```

Inspect files:

```bash
find ~/registry-data -type f | head -10
```

---

# 🔐 Task 5 — Registry Authentication

## 🔹 5.1 Install HTpasswd

Stop the registry:

```bash
docker stop local-registry
docker rm local-registry
```

Install authentication utility:

```bash
sudo apt install -y apache2-utils
```

Create authentication directory:

```bash
mkdir -p ~/registry-auth
```

Create registry user:

```bash
htpasswd -Bbn registryuser registrypass \
> ~/registry-auth/htpasswd
```

Verify:

```bash
cat ~/registry-auth/htpasswd
```

---

# 🔒 5.2 Start Authenticated Registry

```bash
docker run -d \
  -p 5000:5000 \
  --name secure-registry \
  --restart=always \
  -v ~/registry-data:/var/lib/registry \
  -v ~/registry-auth:/auth \
  -e "REGISTRY_AUTH=htpasswd" \
  -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
  -e "REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd" \
  registry:2
```

Verify:

```bash
docker ps
```

Test unauthenticated access:

```bash
curl http://localhost:5000/v2/_catalog
```

---

# 🔑 5.3 Authenticate

Login:

```bash
docker login localhost:5000
```

Credentials used in the lab:

```text
Username: registryuser
Password: registrypass
```

Test authenticated API access:

```bash
curl -u registryuser:registrypass \
http://localhost:5000/v2/_catalog
```

Push image:

```bash
docker push localhost:5000/registry-lab-app:v2.0
```

Verify:

```bash
curl -u registryuser:registrypass \
http://localhost:5000/v2/registry-lab-app/tags/list
```

> 🔐 **Security Note:** The credentials shown above are lab credentials. Do not use them in production.

---

# 🧹 Task 5.4 — Registry Maintenance

Create:

```bash
nano registry-cleanup.sh
```

The maintenance script checks:

* 📦 Current repositories
* 💾 Registry storage usage
* 🐳 Local registry images
* ✅ Maintenance status

Make executable:

```bash
chmod +x registry-cleanup.sh
```

Run:

```bash
./registry-cleanup.sh
```

---

# ⚡ Task 6 — Registry Performance & Security

## 📊 6.1 Performance Testing

The performance script compares image pull operations between:

```text
☁️ Docker Hub
        VS
🏢 Local Private Registry
```

Run:

```bash
chmod +x registry-performance.sh
./registry-performance.sh
```

The script reports the approximate pull time for each registry.

---

# 🛡️ 6.2 Security Checklist

Run:

```bash
chmod +x registry-security-check.sh
./registry-security-check.sh
```

The security script checks:

* 🔐 Authentication status
* 🌐 Network accessibility
* 📋 Recent registry logs

Example flow:

```text
Security Check
      │
      ├── 🔐 Authentication
      │
      ├── 🌐 Network Access
      │
      └── 📋 Registry Logs
```

---

# 🛠️ Task 7 — Troubleshooting & Monitoring

## 🔍 7.1 Troubleshooting

Run:

```bash
chmod +x registry-troubleshoot.sh
./registry-troubleshoot.sh
```

The script checks:

```text
🐳 Docker Service
      ↓
🏢 Registry Container
      ↓
🌐 Registry Connectivity
      ↓
💾 Disk Space
      ↓
📋 Registry Logs
```

---

# 📈 7.2 Registry Monitoring

Run:

```bash
chmod +x registry-monitor.sh
./registry-monitor.sh
```

The monitoring script checks:

* 🐳 Docker Hub image count
* 🏢 Private registry repositories
* 🧠 Memory usage
* 💾 Disk usage
* ⚙️ Docker daemon status
* 📦 Registry containers

---

# 📋 Task 8 — Lab Summary & Cleanup

## 📊 8.1 Generate Summary Report

Run:

```bash
chmod +x lab-summary-report.sh
./lab-summary-report.sh
```

The report summarizes:

* ☁️ Docker Hub integration
* 🏢 Private registry setup
* 🔐 Authentication
* 🏷️ Image versioning
* 📊 Registry operations
* 🛠️ Skills demonstrated

---

# 🗑️ 8.2 Optional Cleanup

A cleanup script is provided:

```bash
chmod +x cleanup-lab.sh
```

Run only when you want to remove lab resources:

```bash
./cleanup-lab.sh
```

The cleanup can remove:

* 🛑 Registry containers
* 📦 Local registry images
* 💾 Registry data
* 🔐 Authentication files
* ⚙️ Registry configuration

> ⚠️ **Warning:** Do not execute the cleanup script if you still need the registry images or data.

---

# 📁 Project Structure

A suggested project structure is:

```text
docker-registry-lab/
│
├── 📄 Dockerfile
├── 📄 Dockerfile-v2
├── 🌐 index.html
├── 🌐 index-v2.html
│
├── 🔧 registry-cleanup.sh
├── ⚡ registry-performance.sh
├── 🛡️ registry-security-check.sh
├── 🛠️ registry-troubleshoot.sh
├── 📊 registry-monitor.sh
├── 📋 lab-summary-report.sh
└── 🗑️ cleanup-lab.sh
```

---

# 🔄 Complete Workflow

```text
              ┌─────────────────┐
              │  Create App     │
              └────────┬────────┘
                       ↓
              ┌─────────────────┐
              │ Build Docker    │
              │     Image       │
              └────────┬────────┘
                       ↓
          ┌────────────┴────────────┐
          ↓                         ↓
 ┌─────────────────┐       ┌──────────────────┐
 │   Docker Hub    │       │ Private Registry │
 │     Public      │       │     Local        │
 └────────┬────────┘       └────────┬─────────┘
          ↓                         ↓
      Push / Pull               Push / Pull
          │                         │
          └────────────┬────────────┘
                       ↓
              ┌─────────────────┐
              │ Authentication  │
              │ & Security      │
              └────────┬────────┘
                       ↓
              ┌─────────────────┐
              │ Monitoring &    │
              │ Troubleshooting │
              └─────────────────┘
```

---

# 🧠 Skills Demonstrated

### 🐳 Docker

* Docker Engine installation
* Image creation
* Container lifecycle management
* Image tagging
* Image push/pull

### ☁️ Docker Hub

* Registry authentication
* Public image publishing
* Image version management
* Image retrieval

### 🏢 Private Registry

* Registry deployment
* Registry storage
* Registry API
* Repository management
* Image versioning

### 🔐 Security

* Registry authentication
* HTpasswd configuration
* Access control
* Security checks
* Registry activity inspection

### 📊 Operations

* Performance testing
* Monitoring
* Troubleshooting
* Maintenance automation
* Cleanup automation

---

# 🎓 Real-World Applications

The skills from this lab can be applied to:

### 🚀 DevOps CI/CD

Container registries can act as the central image source for automated CI/CD pipelines.

```text
Developer
   ↓
Git Repository
   ↓
CI/CD Pipeline
   ↓
Docker Build
   ↓
Container Registry
   ↓
Deployment
```

### 🏢 Enterprise Container Management

Private registries can provide organizations with greater control over proprietary container images.

### 🌍 Multi-Environment Deployment

Images can be promoted through:

```text
Development
     ↓
  Staging
     ↓
 Production
```

### 🔐 Security & Compliance

Authenticated registries help control access to private container images.

---

# 🏆 Key Takeaways

> 🐳 **Docker registries are essential for distributing and managing container images.**

> ☁️ **Docker Hub provides a convenient public registry for learning and open-source projects.**

> 🏢 **Private registries provide greater control over enterprise container images.**

> 🔐 **Authentication and secure configuration are important for protecting registry resources.**

> 🏷️ **Effective image tagging and versioning are fundamental to reliable container management.**

> 📊 **Monitoring and troubleshooting help maintain reliable registry operations.**

---

# ✅ Lab Completion Checklist

* [x] 🐳 Docker installed
* [x] 🔍 Docker installation verified
* [x] 🌐 Sample application created
* [x] 📦 Docker image built
* [x] ☁️ Docker Hub configured
* [x] 📤 Image pushed to Docker Hub
* [x] 📥 Image pulled from Docker Hub
* [x] 🏢 Private registry deployed
* [x] 🏷️ Image tags created
* [x] 📤 Image pushed to private registry
* [x] 📥 Image pulled from private registry
* [x] 🔐 Registry authentication configured
* [x] 📊 Registry monitoring implemented
* [x] 🛠️ Troubleshooting automation created
* [x] ⚡ Performance testing implemented
* [x] 🛡️ Security checks implemented
* [x] 📋 Summary report generated
* [x] 🧹 Cleanup automation created

---

# 🌟 Conclusion

🎉 **Congratulations!**

This lab provided hands-on experience with the complete **Docker image registry lifecycle**, from building container images to publishing them to Docker Hub and managing them through a private registry.

You also implemented:

**🐳 Containerization → 📦 Image Management → ☁️ Docker Hub → 🏢 Private Registry → 🔐 Authentication → 📊 Monitoring → 🛠️ Troubleshooting**

These practical skills provide a strong foundation for working with **Docker, DevOps, CI/CD pipelines, container security, and enterprise container management**.

---

<p align="center">

### 🐳 Docker Registry Integration

**Build • Tag • Push • Pull • Secure • Monitor • Manage**

⭐ **If this project helped you learn Docker Registry concepts, consider giving the repository a star!** ⭐

</p>

---

<p align="center">
  <img src="https://img.shields.io/badge/Docker-Registry%20Integration-2496ED?style=for-the-badge&logo=docker&logoColor=white">
  <img src="https://img.shields.io/badge/DevOps-Container%20Management-0A66C2?style=for-the-badge">
  <img src="https://img.shields.io/badge/Lab-Completed-success?style=for-the-badge">
</p>
