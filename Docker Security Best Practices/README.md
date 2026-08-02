# 🛡️ Docker Security Best Practices 

<p align="center">
  <img src="https://img.shields.io/badge/Docker-Security-2496ED?style=for-the-badge&logo=docker&logoColor=white" alt="Docker">
  <img src="https://img.shields.io/badge/Linux-Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white" alt="Ubuntu">
  <img src="https://img.shields.io/badge/Docker%20Scout-Vulnerability%20Scanning-0db7ed?style=for-the-badge&logo=docker&logoColor=white" alt="Docker Scout">
  <img src="https://img.shields.io/badge/Seccomp-System%20Call%20Filtering-red?style=for-the-badge" alt="Seccomp">
  <img src="https://img.shields.io/badge/AppArmor-Mandatory%20Access%20Control-orange?style=for-the-badge" alt="AppArmor">
  <img src="https://img.shields.io/badge/Bash-Automation-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white" alt="Bash">
</p>

<p align="center">
  <img src="https://img.shields.io/badge/User%20Namespaces-Enabled-success?style=for-the-badge">
  <img src="https://img.shields.io/badge/Resource%20Limits-Configured-brightgreen?style=for-the-badge">
  <img src="https://img.shields.io/badge/Container%20Hardening-Implemented-blueviolet?style=for-the-badge">
  <img src="https://img.shields.io/badge/Status-Completed-success?style=for-the-badge">
</p>

---

# 🛡️ About This Lab

This project demonstrates **Docker Security Best Practices** through hands-on implementation of multiple layers of container security.

The lab focuses on reducing container attack surfaces and preventing common security problems by implementing:

* 👤 User namespace isolation
* 🔒 Non-root container execution
* 🚧 Seccomp system-call filtering
* 🛡️ AppArmor mandatory access control
* 🔍 Docker Scout vulnerability scanning
* 💾 Memory restrictions
* ⚙️ CPU restrictions
* 🔢 Process limits
* 🚫 Linux capability restrictions
* 📖 Read-only container filesystems
* 🔐 `no-new-privileges`
* 🤖 Security automation scripts

The overall objective is to demonstrate a **defense-in-depth approach to Docker container security**.

---

# 🎯 Lab Objectives

By completing this lab, you will learn how to:

* 👤 Configure Docker user namespaces
* 🔐 Run containers with non-root users
* 🚧 Create and apply custom Seccomp profiles
* 🛡️ Configure AppArmor policies
* 🔍 Scan Docker images for vulnerabilities
* 📊 Compare vulnerable and secure images
* 💾 Configure memory limits
* ⚙️ Configure CPU limits
* 🔢 Configure process limits
* 🚫 Drop unnecessary Linux capabilities
* 📖 Use read-only container filesystems
* 🔒 Enable `no-new-privileges`
* 🤖 Build reusable secure-container scripts
* 🧪 Perform comprehensive security testing

---

# 🧰 Technologies & Security Tools

| Technology                | Purpose                                |
| ------------------------- | -------------------------------------- |
| 🐳 **Docker**             | Containerization platform              |
| 🐧 **Ubuntu/Linux**       | Lab operating system                   |
| 🔍 **Docker Scout**       | Container image vulnerability scanning |
| 🚧 **Seccomp**            | System-call filtering                  |
| 🛡️ **AppArmor**          | Mandatory access control               |
| 🔐 **User Namespaces**    | Container user isolation               |
| 💻 **Bash**               | Security automation                    |
| 📊 **Docker Stats**       | Resource monitoring                    |
| ⚙️ **systemd**            | Docker service management              |
| 🧱 **Linux Capabilities** | Container privilege control            |

---

# 📋 Prerequisites

Before starting this lab, you should have:

* 🐧 Basic Linux command-line knowledge
* 🐳 Basic Docker knowledge
* 👤 Understanding of Linux users and permissions
* 🔐 Basic understanding of security concepts
* 💻 Familiarity with Docker commands

---

# ☁️ Lab Environment

The lab uses Linux-based cloud machines provided by **Al Nafi**.

The machine starts as a bare-metal Linux environment without the required tools, so Docker and other security utilities are installed during the exercises.

---

# 🏗️ Docker Security Architecture

```text
                         🛡️ DOCKER SECURITY
                                │
             ┌──────────────────┼──────────────────┐
             │                  │                  │
             ▼                  ▼                  ▼
      👤 USER ISOLATION    🚧 SYSTEM CALLS     🛡️ ACCESS CONTROL
             │                  │                  │
      User Namespaces        Seccomp           AppArmor
             │                  │                  │
             └──────────────────┼──────────────────┘
                                │
                                ▼
                       🔍 IMAGE SECURITY
                                │
                         Docker Scout
                                │
                                ▼
                       ⚙️ RESOURCE CONTROL
                                │
            ┌───────────────────┼───────────────────┐
            │                   │                   │
         Memory                CPU               PIDs
            │                   │                   │
            └───────────────────┼───────────────────┘
                                │
                                ▼
                      🔐 CONTAINER HARDENING
                                │
        ┌───────────────────────┼───────────────────────┐
        │                       │                       │
   Read-Only FS          Drop Capabilities       No New Privileges
```

---

# 🛠️ Task 1 — User Namespaces for Non-Root Containers

## 🔹 1.1 Install Docker

Update the operating system:

```bash
sudo apt update && sudo apt upgrade -y
```

Install required packages:

```bash
sudo apt install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg \
  lsb-release
```

Add Docker's GPG key:

```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
sudo gpg --dearmor \
-o /usr/share/keyrings/docker-archive-keyring.gpg
```

Add Docker repository:

```bash
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

Install Docker:

```bash
sudo apt update

sudo apt install -y docker-ce docker-ce-cli containerd.io
```

Add current user to Docker group:

```bash
sudo usermod -aG docker $USER
```

Start Docker:

```bash
sudo systemctl start docker
sudo systemctl enable docker
```

### ✅ Checkpoint

```text
✔ Docker installed
✔ Docker service enabled
✔ User added to Docker group
```

---

# 👤 Task 1.2 — Configure User Namespace Mapping

Create a dedicated Docker user:

```bash
sudo useradd -r -s /bin/false dockeruser
```

Configure subordinate UID mapping:

```bash
echo "dockeruser:100000:65536" | sudo tee -a /etc/subuid
```

Configure subordinate GID mapping:

```bash
echo "dockeruser:100000:65536" | sudo tee -a /etc/subgid
```

Create Docker configuration directory:

```bash
sudo mkdir -p /etc/docker
```

Configure user namespace remapping:

```bash
sudo tee /etc/docker/daemon.json << EOF
{
  "userns-remap": "dockeruser"
}
EOF
```

Restart Docker:

```bash
sudo systemctl restart docker
```

Verify:

```bash
docker info | grep -i "user namespace"
```

### 🔐 Security Concept

```text
Container UID 0
      │
      ▼
User Namespace
      │
      ▼
Unprivileged Host UID
```

This provides an additional isolation layer between container users and the host system.

---

# 🧪 Task 1.3 — Test Non-Root Containers

Run a test container:

```bash
docker run --rm -it \
  ubuntu:20.04 \
  /bin/bash -c "whoami && id"
```

Create the security lab directory:

```bash
mkdir ~/docker-security-lab
cd ~/docker-security-lab
```

Create a non-root Dockerfile:

```dockerfile
FROM ubuntu:20.04

RUN groupadd -r appuser && \
    useradd -r -g appuser appuser

USER appuser

WORKDIR /home/appuser

CMD ["whoami"]
```

Build:

```bash
docker build \
  -f Dockerfile.nonroot \
  -t nonroot-test .
```

Run:

```bash
docker run --rm nonroot-test
```

Verify UID:

```bash
docker run --rm nonroot-test id
```

### 🎯 Security Goal

```text
❌ Container running as root
             ↓
        SECURITY RISK
             ↓
✅ Container running as appuser
             ↓
        Reduced Privilege
```

---

# 🚧 Task 2 — Seccomp & AppArmor

# 🔹 2.1 Create Custom Seccomp Profile

Create the profile directory:

```bash
mkdir -p ~/docker-security-lab/seccomp
```

Create:

```text
~/docker-security-lab/seccomp/restricted-profile.json
```

The profile uses:

```json
{
  "defaultAction": "SCMP_ACT_ERRNO"
}
```

and explicitly permits the required system calls.

### 🧪 Test Seccomp

```bash
docker run --rm \
  --security-opt seccomp=~/docker-security-lab/seccomp/restricted-profile.json \
  ubuntu:20.04 \
  /bin/bash -c "echo 'Seccomp profile applied successfully'"
```

Test a restricted operation:

```bash
docker run --rm \
  --security-opt seccomp=~/docker-security-lab/seccomp/restricted-profile.json \
  ubuntu:20.04 \
  /bin/bash -c "mount" || \
  echo "Mount command blocked by seccomp profile"
```

### 🚧 Seccomp Flow

```text
Container
    │
    ▼
System Call
    │
    ▼
┌───────────────┐
│    Seccomp    │
│    Profile    │
└───────┬───────┘
        │
   ┌────┴────┐
   ▼         ▼
 ALLOW      DENY
```

---

# 🛡️ Task 2.2 — Configure AppArmor

Install AppArmor utilities:

```bash
sudo apt install -y apparmor-utils
```

Check status:

```bash
sudo aa-status
```

Create the profile:

```bash
sudo mkdir -p /etc/apparmor.d/docker
```

Create:

```text
/etc/apparmor.d/docker-restricted
```

The profile:

* 📖 Allows required file operations
* 🚫 Denies `sys_admin`
* 🚫 Denies `sys_module`
* 🚫 Denies `sys_rawio`
* 🚫 Denies `sys_time`
* 🌐 Allows TCP/UDP networking
* 🚫 Denies mount operations
* 🔐 Controls signal operations

Load the profile:

```bash
sudo apparmor_parser -r \
  /etc/apparmor.d/docker-restricted
```

Verify:

```bash
sudo aa-status | grep docker-restricted
```

Test:

```bash
docker run --rm \
  --security-opt apparmor=docker-restricted \
  ubuntu:20.04 \
  /bin/bash -c "echo 'AppArmor profile applied successfully'"
```

---

# 🔐 Task 2.3 — Combine Security Controls

Run a container with multiple security mechanisms:

```bash
docker run --rm \
  --security-opt seccomp=~/docker-security-lab/seccomp/restricted-profile.json \
  --security-opt apparmor=docker-restricted \
  --user 1000:1000 \
  --read-only \
  --tmpfs /tmp \
  ubuntu:20.04 \
  /bin/bash -c \
  "whoami && echo 'Multi-layered security applied'"
```

### 🛡️ Defense-in-Depth

```text
             Container
                 │
       ┌─────────┼─────────┐
       ▼         ▼         ▼
    UserNS    Seccomp   AppArmor
       │         │         │
       └─────────┼─────────┘
                 ▼
          Read-Only FS
                 │
                 ▼
         Reduced Attack Surface
```

---

# 🔍 Task 3 — Docker Scout Vulnerability Scanning

## 🐳 3.1 Enable Docker Scout

Login:

```bash
docker login
```

Check Docker Scout:

```bash
docker scout --help
```

Pull test images:

```bash
docker pull nginx:latest
docker pull node:14-alpine
```

---

# 🔎 Task 3.2 — Scan Images

Scan NGINX:

```bash
docker scout cves nginx:latest
```

Generate SARIF output:

```bash
docker scout cves \
  --format sarif \
  nginx:latest > nginx-scan-results.sarif
```

Scan Node.js:

```bash
docker scout cves node:14-alpine
```

Compare:

```bash
docker scout compare \
  nginx:latest \
  node:14-alpine
```

Get recommendations:

```bash
docker scout recommendations nginx:latest
```

### 🔍 Security Workflow

```text
Docker Image
     │
     ▼
Docker Scout
     │
     ├── 🔴 Vulnerabilities
     ├── 🟠 Security Findings
     ├── 🟡 Recommendations
     └── 🟢 Improvements
```

---

# 🧪 Task 3.3 — Vulnerable vs Secure Image

## ⚠️ Vulnerable Image

The lab creates a deliberately vulnerable image based on Ubuntu 18.04.

Security issues include:

* ❌ Running as root
* ❌ SSH server exposed
* ❌ Older base image

Build:

```bash
docker build \
  -f Dockerfile.vulnerable \
  -t vulnerable-app:latest .
```

Scan:

```bash
docker scout cves vulnerable-app:latest
```

---

# ✅ Secure Image

The improved image:

* ✔ Uses Ubuntu 22.04
* ✔ Installs only required packages
* ✔ Removes package lists
* ✔ Creates an application user
* ✔ Runs as non-root
* ✔ Exposes only the required application port

Build:

```bash
docker build \
  -f Dockerfile.secure \
  -t secure-app:latest .
```

Compare:

```bash
docker scout compare \
  vulnerable-app:latest \
  secure-app:latest
```

### 🆚 Security Improvement

```text
⚠️ Vulnerable Image
├── Root User
├── SSH Exposure
└── Older Base Image

          ↓ HARDENING ↓

🛡️ Secure Image
├── Non-Root User
├── Minimal Packages
├── Required Port Only
└── Updated Base Image
```

---

# 💾 Task 4 — Container Resource Limits

## 🔹 4.1 Memory Limits

Run with 128 MB:

```bash
docker run --rm -it \
  --memory=128m \
  ubuntu:20.04 \
  /bin/bash -c \
  "echo 'Memory limited to 128MB'"
```

Test a 64 MB limit:

```bash
docker run --rm \
  --memory=64m \
  ubuntu:20.04 \
  /bin/bash -c "
    echo 'Testing memory limit...'
    python3 -c '
import sys
try:
    data = bytearray(100 * 1024 * 1024)
    print(\"Memory allocation successful\")
except MemoryError:
    print(\"Memory allocation failed - limit enforced\")
    sys.exit(1)
'"
```

### 💾 Memory Protection

```text
Container
    │
    ▼
Memory Limit
    │
    ├── Normal Usage → ✅ Allowed
    │
    └── Excess Usage → 🚫 Restricted
```

---

# ⚙️ Task 4.2 — CPU Limits

Run with 50% CPU:

```bash
docker run --rm -d \
  --name cpu-limited \
  --cpus="0.5" \
  ubuntu:20.04 \
  /bin/bash -c "
    while true; do
      echo 'CPU intensive task'
      sleep 1
    done
  "
```

Monitor:

```bash
docker stats cpu-limited --no-stream
```

Stop:

```bash
docker stop cpu-limited
```

### CPU Shares

```bash
docker run --rm -d \
  --name cpu-shares \
  --cpu-shares=512 \
  ubuntu:20.04 \
  /bin/bash -c "
    while true; do
      echo 'CPU task with shares'
      sleep 1
    done
  "
```

Monitor:

```bash
docker stats cpu-shares --no-stream
```

Stop:

```bash
docker stop cpu-shares
```

---

# 🧱 Task 4.3 — Comprehensive Resource Limits

Create a hardened resource-limited container:

```bash
docker run --rm -d \
  --name resource-limited \
  --memory=256m \
  --memory-swap=256m \
  --cpus="1.0" \
  --pids-limit=100 \
  --ulimit nofile=1024:1024 \
  --read-only \
  --tmpfs /tmp:rw,noexec,nosuid,size=50m \
  ubuntu:20.04 \
  /bin/bash -c "
    echo 'Container with comprehensive resource limits'
    while true; do
      sleep 10
    done
  "
```

Monitor:

```bash
docker stats resource-limited --no-stream
```

Inspect:

```bash
docker inspect resource-limited | \
grep -A 20 "HostConfig"
```

Stop:

```bash
docker stop resource-limited
```

---

# 🔐 Task 4.4 — Secure Container Launcher

The lab creates a reusable security-focused launcher script:

```text
secure-container.sh
```

The launcher applies:

```text
🔐 Seccomp
🛡️ AppArmor
🚫 No New Privileges
👤 Non-Root User
💾 Memory Limit
⚙️ CPU Limit
🔢 PID Limit
📖 Read-Only Filesystem
📁 Temporary Filesystem
🚫 Drop Capabilities
```

Make executable:

```bash
chmod +x ~/docker-security-lab/secure-container.sh
```

Run:

```bash
~/docker-security-lab/secure-container.sh \
  ubuntu:20.04 \
  "whoami && id && echo 'Secure container launched successfully'"
```

---

# 🧪 Verification & Testing

## 🔎 Comprehensive Security Test

Create:

```text
security-test.sh
```

The test verifies:

```text
1️⃣ User Namespaces
2️⃣ Seccomp
3️⃣ AppArmor
4️⃣ Resource Limits
5️⃣ Vulnerability Scanning
```

Make executable:

```bash
chmod +x ~/docker-security-lab/security-test.sh
```

Run:

```bash
~/docker-security-lab/security-test.sh
```

### 🏆 Security Validation Flow

```text
             🧪 SECURITY TEST
                    │
        ┌───────────┼───────────┐
        ▼           ▼           ▼
     UserNS      Seccomp     AppArmor
        │           │           │
        └───────────┼───────────┘
                    ▼
             Resource Limits
                    │
                    ▼
             Docker Scout
                    │
                    ▼
              ✅ VALIDATED
```

---

# 🛠️ Troubleshooting

## ⚠️ Issue 1 — User Namespace Problems

Check Docker:

```bash
sudo systemctl status docker
```

Check namespaces:

```bash
docker info | grep -i namespace
```

If required, reset Docker configuration according to the lab procedure:

```bash
sudo systemctl stop docker
sudo rm -rf /var/lib/docker
sudo systemctl start docker
```

> ⚠️ Removing `/var/lib/docker` can delete local Docker data. Use this reset procedure carefully.

---

# 🛡️ Issue 2 — AppArmor Profile Problems

Check:

```bash
sudo aa-status
```

Reload:

```bash
sudo apparmor_parser -r \
  /etc/apparmor.d/docker-restricted
```

Check syntax:

```bash
sudo apparmor_parser -Q \
  /etc/apparmor.d/docker-restricted
```

---

# 🔍 Issue 3 — Docker Scout Authentication

Logout:

```bash
docker logout
```

Login again:

```bash
docker login
```

Check Scout:

```bash
docker scout --help
```

---

# 📁 Project Structure

```text
docker-security-lab/
│
├── 📄 Dockerfile.nonroot
├── 📄 Dockerfile.vulnerable
├── 📄 Dockerfile.secure
│
├── 📁 seccomp/
│   └── 🔐 restricted-profile.json
│
├── 🔐 secure-container.sh
├── 🧪 security-test.sh
│
└── 📊 nginx-scan-results.sarif
```

---

# 🛡️ Security Controls Implemented

| Security Control         | Purpose                        |
| ------------------------ | ------------------------------ |
| 👤 **User Namespaces**   | Isolate container users        |
| 🔐 **Non-Root User**     | Reduce privilege               |
| 🚧 **Seccomp**           | Restrict system calls          |
| 🛡️ **AppArmor**         | Mandatory access control       |
| 🔍 **Docker Scout**      | Vulnerability detection        |
| 💾 **Memory Limits**     | Prevent memory exhaustion      |
| ⚙️ **CPU Limits**        | Control CPU consumption        |
| 🔢 **PID Limits**        | Limit process creation         |
| 📖 **Read-Only FS**      | Reduce filesystem modification |
| 🚫 **Capability Drop**   | Remove unnecessary privileges  |
| 🔒 **No New Privileges** | Prevent privilege escalation   |
| 📁 **Tmpfs**             | Controlled temporary storage   |

---

# 🧠 Skills Demonstrated

### 🐳 Docker Security

* Container hardening
* Security configuration
* User namespace isolation
* Non-root containers

### 🔐 Linux Security

* User/group management
* UID/GID mappings
* Linux capabilities
* AppArmor policies
* Seccomp profiles

### 🔍 Vulnerability Management

* Docker Scout
* CVE scanning
* SARIF reporting
* Image comparison
* Security recommendations

### ⚙️ Resource Management

* Memory limits
* CPU limits
* CPU shares
* PID limits
* File descriptor limits

### 🤖 Automation

* Secure container launcher
* Security validation script
* Repeatable security configuration

---

# 🌍 Real-World Applications

These techniques are directly useful in:

### 🏢 Production Container Environments

Running applications with reduced privileges helps minimize the impact of container compromise.

### ☁️ Cloud & DevOps

Container security controls can be incorporated into cloud deployment and DevOps workflows.

### 🔄 CI/CD Pipelines

Docker Scout and security validation scripts can be incorporated into image build and deployment processes.

### 👥 Multi-Tenant Environments

User namespaces, resource limits, and mandatory access controls provide additional isolation between workloads.

### 📋 Compliance-Sensitive Applications

Security controls such as least privilege, vulnerability scanning, and resource restrictions support stronger security governance.

---

# 🏆 Docker Security Best Practices

```text
                    🛡️ SECURE CONTAINER
                           │
        ┌──────────────────┼──────────────────┐
        ▼                  ▼                  ▼
   👤 Non-Root          🔍 Scan Images      🚧 Seccomp
        │                  │                  │
        ▼                  ▼                  ▼
    🛡️ AppArmor       📊 Monitor          ⚙️ Limits
        │                  │                  │
        └──────────────────┼──────────────────┘
                           ▼
                    🔐 Defense in Depth
```

### Recommended Principles

* 👤 Run containers as non-root
* 🔒 Apply least privilege
* 🚧 Restrict unnecessary system calls
* 🛡️ Use mandatory access controls
* 🔍 Scan images regularly
* 📦 Use appropriately maintained base images
* 💾 Apply resource limits
* 🚫 Drop unnecessary capabilities
* 📖 Use read-only filesystems where possible
* 🔐 Prevent privilege escalation
* 📊 Monitor container behavior
* 🔄 Automate security validation

---

# ✅ Lab Completion Checklist

* [x] 🐳 Docker installed
* [x] 👤 User namespace configured
* [x] 🔐 Non-root container tested
* [x] 🚧 Custom Seccomp profile created
* [x] 🛡️ AppArmor profile created
* [x] 🔒 Multiple security options combined
* [x] 🔍 Docker Scout configured
* [x] 🐛 Images scanned for vulnerabilities
* [x] ⚠️ Vulnerable image created
* [x] ✅ Secure image created
* [x] 🆚 Images compared
* [x] 💾 Memory limits configured
* [x] ⚙️ CPU limits configured
* [x] 🔢 PID limits configured
* [x] 📖 Read-only filesystem configured
* [x] 🚫 Linux capabilities restricted
* [x] 🔒 No-new-privileges configured
* [x] 🤖 Secure container launcher created
* [x] 🧪 Comprehensive security test created
* [x] 🛠️ Troubleshooting procedures documented

---

# 🎓 Lab Summary

This lab provided hands-on experience implementing **comprehensive Docker security best practices**.

The major security layers implemented were:

```text
👤 User Namespace Isolation
          ↓
🚧 Seccomp System Call Filtering
          ↓
🛡️ AppArmor Mandatory Access Control
          ↓
🔍 Vulnerability Scanning
          ↓
💾 Resource Restrictions
          ↓
🚫 Capability Restrictions
          ↓
📖 Read-Only Filesystem
          ↓
🔒 No-New-Privileges
          ↓
🧪 Automated Security Testing
```

Together, these controls demonstrate a **defense-in-depth approach to container security**, helping reduce risks such as privilege escalation, resource abuse, excessive system-call access, and vulnerable container images.

---

# 🌟 Conclusion

🎉 **Congratulations on completing the Docker Security Best Practices Lab!**

Through this project, you gained practical experience with:

**🐳 Docker → 👤 User Isolation → 🚧 Seccomp → 🛡️ AppArmor → 🔍 Vulnerability Scanning → ⚙️ Resource Controls → 🔐 Container Hardening → 🧪 Security Testing**

These skills provide a strong foundation for securing Docker workloads in **DevOps, cloud, production, multi-tenant, and compliance-sensitive environments**.

---

<p align="center">

## 🛡️ Docker Security Best Practices

**Secure • Harden • Scan • Restrict • Monitor • Automate**

⭐ **Secure containers. Reduce privileges. Minimize attack surface.** ⭐

</p>

---

<p align="center">
  <img src="https://img.shields.io/badge/Docker-Security-2496ED?style=for-the-badge&logo=docker&logoColor=white">
  <img src="https://img.shields.io/badge/DevSecOps-Container%20Security-8A2BE2?style=for-the-badge">
  <img src="https://img.shields.io/badge/Security-Hardening-red?style=for-the-badge">
  <img src="https://img.shields.io/badge/Lab-Completed-success?style=for-the-badge">
</p>
