# 🔐 Advanced Docker Security

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge\&logo=docker\&logoColor=white)
![Docker Security](https://img.shields.io/badge/Docker%20Security-000000?style=for-the-badge\&logo=docker\&logoColor=white)
![Trivy](https://img.shields.io/badge/Trivy-1904DA?style=for-the-badge\&logo=aquasecurity\&logoColor=white)
![Hadolint](https://img.shields.io/badge/Hadolint-4B5563?style=for-the-badge\&logo=docker\&logoColor=white)
![Dockle](https://img.shields.io/badge/Dockle-Security-red?style=for-the-badge)
![Ubuntu](https://img.shields.io/badge/Ubuntu-22.04-E95420?style=for-the-badge\&logo=ubuntu\&logoColor=white)
![Alpine](https://img.shields.io/badge/Alpine-Linux-0D597F?style=for-the-badge\&logo=alpinelinux\&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-Scripting-121011?style=for-the-badge\&logo=gnu-bash\&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-EC2-FF9900?style=for-the-badge\&logo=amazonaws\&logoColor=white)

> 🛡️ **Defense in Depth for Containerized Applications**
>
> This lab demonstrates advanced Docker security by hardening the Docker daemon, creating minimal non-root container images, enforcing runtime security controls, and building an automated vulnerability and configuration scanning pipeline.

---

# 📚 Table of Contents

* [🎯 Overview](#-overview)
* [🎓 Objectives](#-objectives)
* [📋 Prerequisites](#-prerequisites)
* [☁️ Lab Environment](#️-lab-environment)
* [🏗️ Security Architecture](#️-security-architecture)
* [🛠️ Task 1 - Security Toolchain](#️-task-1---install-and-verify-the-security-toolchain)
* [🔐 Task 2 - Docker Daemon Hardening](#-task-2---harden-the-docker-daemon-and-build-a-minimal-secure-image)
* [🐳 Secure Multi-Stage Image](#-secure-multi-stage-image)
* [🛡️ Runtime Security Controls](#️-runtime-security-controls)
* [🔎 Task 3 - Automated Security Pipeline](#-task-3---build-an-automated-security-scanning-pipeline)
* [📄 Dockerfile Audit](#-dockerfile-audit)
* [🧪 Validation](#-validation-and-acceptance-criteria)
* [🚨 Troubleshooting](#-troubleshooting)
* [🧹 Cleanup](#-cleanup)
* [📊 Security Controls](#-security-controls-summary)
* [🏆 Expected Outcomes](#-expected-outcomes)
* [🎯 Conclusion](#-conclusion)

---

# 🎯 Overview

Containers provide process isolation, but container security requires more than simply running an application inside Docker.

This lab implements security controls at **three different layers**:

```text
┌─────────────────────────────────────────────┐
│             Docker Security                 │
├─────────────────────────────────────────────┤
│                                             │
│  1️⃣ Docker Daemon Security                  │
│     ├── User Namespace Remapping            │
│     ├── ICC Disabled                        │
│     ├── No New Privileges                   │
│     ├── Resource Limits                     │
│     └── Secure Logging                      │
│                                             │
│  2️⃣ Container / Image Security              │
│     ├── Minimal Alpine Image                │
│     ├── Multi-Stage Build                   │
│     ├── Non-Root UID 1001                   │
│     ├── Read-Only Filesystem                │
│     └── Dropped Capabilities                │
│                                             │
│  3️⃣ Automated Security Validation           │
│     ├── Trivy CVE Scan                     │
│     ├── Trivy Secret Scan                   │
│     ├── Trivy Misconfiguration Scan         │
│     ├── Dockle CIS Scan                     │
│     └── Hadolint Dockerfile Audit           │
│                                             │
└─────────────────────────────────────────────┘
```

The goal is to establish a reproducible **defense-in-depth Docker security baseline**.

---

# 🎓 Objectives

By completing this lab, you will learn how to:

* 🔐 Harden the Docker daemon
* 👤 Configure user namespace remapping
* 🚫 Disable inter-container communication
* 🛡️ Enable `no-new-privileges`
* 📊 Configure Docker resource limits
* 📝 Configure secure JSON logging
* 🐳 Build minimal production images
* 🏗️ Use multi-stage Docker builds
* 👤 Run applications as non-root
* 🔒 Drop Linux capabilities
* 📖 Run containers with read-only filesystems
* 🚨 Scan images for CVEs
* 🔑 Detect secrets in container images
* ⚙️ Detect Dockerfile misconfigurations
* 📋 Perform CIS benchmark checks
* 🧪 Automate security testing
* 📄 Generate auditable Dockerfile reports
* 🚦 Implement CVE-based pipeline gating

---

# 📋 Prerequisites

Before starting, you should understand:

* Linux command-line operations
* Linux users and groups
* File permissions
* Basic networking
* Docker fundamentals
* Dockerfiles
* Container lifecycle management
* Basic shell scripting

---

# ☁️ Lab Environment

The lab uses a dedicated **AWS EC2 Ubuntu instance** provided by **Al Nafi**.

The instance contains a base Ubuntu installation. All security tooling is installed during the lab.

### 🛠️ Required Tools

| Tool             | Purpose                                          |
| ---------------- | ------------------------------------------------ |
| 🐳 Docker Engine | Container runtime                                |
| 🔎 Trivy         | Vulnerability, secret & misconfiguration scanner |
| 📋 Hadolint      | Dockerfile linter                                |
| 🛡️ Dockle       | Container security/CIS scanner                   |
| 🐧 Ubuntu        | Host operating system                            |
| 🏔️ Alpine       | Minimal production image                         |
| 🖥️ AWS EC2      | Lab infrastructure                               |
| 🐚 Bash          | Automation                                       |

---

# 🏗️ Security Architecture

The security model follows a layered approach:

```text
                    AWS EC2 Ubuntu
                          │
                          ▼
                ┌──────────────────┐
                │ Docker Daemon    │
                │                  │
                │ UserNS Remap     │
                │ ICC Disabled     │
                │ No-New-Privileges│
                │ Resource Limits  │
                │ JSON Logging     │
                └────────┬─────────┘
                         │
                         ▼
                ┌──────────────────┐
                │ Secure Image     │
                │                  │
                │ Alpine           │
                │ Non-Root UID1001 │
                │ Multi-Stage      │
                │ Minimal Runtime  │
                └────────┬─────────┘
                         │
                         ▼
                ┌──────────────────┐
                │ Runtime Controls │
                │                  │
                │ Read-Only FS     │
                │ Drop ALL Caps    │
                │ 64MB Memory      │
                │ 50 PIDs          │
                │ No New Privilege │
                └────────┬─────────┘
                         │
                         ▼
                ┌──────────────────┐
                │ Security Pipeline│
                │                  │
                │ Trivy            │
                │ Dockle           │
                │ Hadolint         │
                └──────────────────┘
```

---

# 🛠️ Task 1 - Install and Verify the Security Toolchain

## 🐳 1.1 Install Docker Engine

Update the package index:

```bash
sudo apt-get update
```

Install dependencies:

```bash
sudo apt-get install -y \
  ca-certificates \
  curl \
  gnupg \
  lsb-release
```

Create the Docker keyring directory:

```bash
sudo install -m 0755 -d /etc/apt/keyrings
```

Add Docker's official GPG key:

```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
```

Set permissions:

```bash
sudo chmod a+r /etc/apt/keyrings/docker.gpg
```

Configure the Docker repository:

```bash
sudo tee /etc/apt/sources.list.d/docker.list <<EOF
deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable
EOF
```

Install Docker:

```bash
sudo apt-get update
sudo apt-get install -y \
  docker-ce \
  docker-ce-cli \
  containerd.io
```

Enable Docker:

```bash
sudo systemctl enable --now docker
```

Add the current user to the Docker group:

```bash
sudo usermod -aG docker "$USER"
```

Apply the group change:

```bash
newgrp docker
```

Test Docker:

```bash
docker run hello-world
```

---

# 🔎 1.2 Install Trivy

Install Trivy from its official installation source:

```bash
curl -fsSL \
https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh \
| sudo sh -s -- -b /usr/local/bin
```

Verify:

```bash
trivy --version
```

### 🔧 Troubleshooting

If the installation URL returns `404`, use the official Trivy release/install documentation and install the latest available release package.

---

# 📋 1.3 Install Hadolint

Set the version:

```bash
HADOLINT_VERSION="v2.12.0"
```

Download:

```bash
curl -fsSL \
"https://github.com/hadolint/hadolint/releases/download/${HADOLINT_VERSION}/hadolint-Linux-x86_64" \
-o /tmp/hadolint
```

Install:

```bash
sudo install -m 0755 /tmp/hadolint /usr/local/bin/hadolint
```

Verify:

```bash
hadolint --version
```

### 🔧 Troubleshooting

If you see:

```text
Exec format error
```

check the downloaded file:

```bash
file /usr/local/bin/hadolint
```

If it reports an HTML document instead of an executable, download the correct release asset.

---

# 🛡️ 1.4 Install Dockle

Set the version:

```bash
DOCKLE_VERSION="v0.4.14"
```

Download:

```bash
curl -fsSL \
"https://github.com/goodwithtech/dockle/releases/download/${DOCKLE_VERSION}/dockle_${DOCKLE_VERSION#v}_Linux-64bit.deb" \
-o /tmp/dockle.deb
```

Install:

```bash
sudo dpkg -i /tmp/dockle.deb
```

Verify:

```bash
dockle --version
```

If the `.deb` is not valid, verify the exact filename on the official Dockle release page and update the download command.

---

# ✅ 1.5 Verify the Complete Toolchain

Pull Alpine:

```bash
docker pull alpine:latest
```

Run Trivy:

```bash
trivy image \
  --severity HIGH,CRITICAL \
  alpine:latest
```

Run Hadolint:

```bash
echo "FROM alpine:latest" | hadolint -
```

Run Dockle:

```bash
dockle alpine:latest
```

### Expected Result

All four tools should execute successfully.

> ⚠️ Trivy and Dockle may report security findings. Findings are expected. A tool crash or `command not found` indicates an installation problem that must be fixed.

---

# 🔐 Task 2 - Harden the Docker Daemon

The Docker daemon will be configured with multiple security controls.

## 🛡️ Required Controls

The configuration must enforce:

* 👤 User namespace remapping
* 🚫 Inter-container communication disabled
* 🛑 No-new-privileges
* 📝 JSON file logging
* 📦 10 MB maximum log size
* 🔄 Maximum 3 rotated log files
* 📊 `nofile` soft limit of 64000
* 📊 `nofile` hard limit of 64000

---

# 👤 User Namespace Remapping

User namespace remapping helps prevent container root from directly mapping to host root.

Conceptually:

```text
Container UID 0
      │
      ▼
Namespace Mapping
      │
      ▼
Host Unprivileged UID
```

Create the Docker remapping configuration using the `dockremap` system identity as required by the lab.

Verify the configuration using:

```bash
docker info
```

Look for:

```text
userns
dockremap
```

---

# ⚙️ Docker Daemon Configuration

The configuration file is:

```text
/etc/docker/daemon.json
```

A hardened configuration should include the required controls, for example:

```json
{
  "userns-remap": "dockremap",
  "icc": false,
  "no-new-privileges": true,
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "default-ulimits": {
    "nofile": {
      "Name": "nofile",
      "Hard": 64000,
      "Soft": 64000
    }
  }
}
```

> ⚠️ If your Docker version does not accept a particular daemon option, verify the option against the Docker Engine version installed on the lab machine before restarting the daemon.

Restart Docker:

```bash
sudo systemctl restart docker
```

Check status:

```bash
sudo systemctl status docker
```

---

# 🔎 Verify Daemon Security

Inspect Docker:

```bash
docker info
```

Verify user namespace remapping:

```bash
docker info | grep -i userns
```

Verify ICC:

```bash
docker info | grep -i icc
```

Verify daemon configuration:

```bash
sudo cat /etc/docker/daemon.json
```

---

# 🛑 Verify No-New-Privileges

Run a container with:

```bash
docker run --rm \
  --security-opt=no-new-privileges:true \
  --cap-drop=ALL \
  alpine:latest \
  id
```

The container should not obtain additional privileges.

With user namespace remapping configured, container root should map to an unprivileged host identity rather than host UID 0.

---

# 🐳 Task 2.2 - Build a Minimal Secure Image

The production image must satisfy:

* 🏗️ Build stage based on `ubuntu:22.04`
* 🏔️ Production stage based on `alpine:latest`
* 🚫 No package manager cache
* 🚫 No build tools
* 🐚 Only `/bin/sh` as the shell
* 👤 UID 1001 non-root user
* ❤️ HEALTHCHECK instruction
* 📦 Final image under 20 MB

---

# 🏗️ Multi-Stage Build Concept

```text
        Ubuntu 22.04
        Build Stage
             │
             │ Compile / Assemble
             ▼
       Application Artifact
             │
             ▼
       Alpine Latest
      Production Stage
             │
      ┌──────┴──────┐
      │             │
   UID 1001     HEALTHCHECK
      │             │
      └──────┬──────┘
             ▼
      secure-app:1.0
```

A multi-stage build keeps development and build dependencies outside the final production image.

---

# 🔒 Secure Image Requirements

The final image should:

```text
❌ No compiler
❌ No package cache
❌ No unnecessary tools
❌ No root application process

✅ Alpine runtime
✅ UID 1001
✅ HEALTHCHECK
✅ Minimal filesystem
✅ Small attack surface
```

Build:

```bash
docker build \
  -t secure-app:1.0 \
  .
```

Inspect:

```bash
docker image inspect secure-app:1.0
```

Check image size:

```bash
docker images secure-app:1.0
```

---

# 🛡️ Run the Secure Container

Run with multiple runtime security restrictions:

```bash
docker run -d \
  --name secure-app \
  --read-only \
  --cap-drop=ALL \
  --memory=64m \
  --pids-limit=50 \
  --security-opt=no-new-privileges:true \
  secure-app:1.0
```

---

# 🔍 Verify Container User

Inspect:

```bash
docker image inspect \
  --format '{{.Config.User}}' \
  secure-app:1.0
```

Expected:

```text
1001
```

or the configured non-root user mapped to UID 1001.

Check running processes:

```bash
docker top secure-app
```

No application process should run as UID 0.

---

# 📊 Verify Resource Limits

Check memory:

```bash
docker stats secure-app --no-stream
```

The container is configured with:

```text
Memory Limit: 64 MB
```

Check PID limit:

```bash
docker inspect secure-app \
  --format '{{.HostConfig.PidsLimit}}'
```

Expected:

```text
50
```

---

# 🔐 Runtime Security Controls

The container is launched with:

### 📖 Read-Only Filesystem

```bash
--read-only
```

Prevents normal writes to the container filesystem.

### 🚫 Drop All Capabilities

```bash
--cap-drop=ALL
```

Removes Linux capabilities from the container.

### 🧠 Memory Limit

```bash
--memory=64m
```

Restricts memory usage.

### 🔢 PID Limit

```bash
--pids-limit=50
```

Limits the number of processes.

### 🛑 No New Privileges

```bash
--security-opt=no-new-privileges:true
```

Prevents processes from gaining additional privileges.

---

# 🔎 Task 3 - Automated Security Scanning Pipeline

The automated pipeline performs four security checks:

```text
Docker Image
     │
     ├──────────────► Trivy CVE Scan
     │
     ├──────────────► Trivy Secret Scan
     │
     ├──────────────► Trivy Misconfiguration Scan
     │
     └──────────────► Dockle CIS Scan
                         │
                         ▼
                    reports/
                         │
                         ▼
                   Security Report
```

---

# 📁 Required Pipeline Structure

The project should contain:

```text
.
├── Dockerfile
├── Dockerfile.optimized
├── scan-pipeline.sh
├── dockerfile-audit.txt
└── reports/
    ├── image-cve.txt
    ├── image-secrets.txt
    ├── image-misconfig.txt
    └── image-dockle.txt
```

The exact report filenames can include a sanitized image name.

---

# 🧪 Scan Pipeline Requirements

The script:

```text
scan-pipeline.sh
```

must accept exactly one argument:

```bash
bash scan-pipeline.sh secure-app:1.0
```

The pipeline performs:

1. 🔎 HIGH/CRITICAL CVE scan
2. 🔑 Secret scan
3. ⚙️ Misconfiguration scan
4. 🛡️ Dockle CIS scan

Each scan writes to a separate file inside:

```text
reports/
```

---

# 🔎 Trivy CVE Scan

The CVE scan is scoped to:

```text
HIGH
CRITICAL
```

Conceptually:

```bash
trivy image \
  --severity HIGH,CRITICAL \
  IMAGE
```

The pipeline must use the scan result to determine whether the image passes the security gate.

---

# 🔑 Trivy Secret Scan

The image is scanned for potentially exposed secrets.

The report should identify potential:

* API keys
* Credentials
* Tokens
* Passwords
* Private keys
* Other sensitive strings

---

# ⚙️ Trivy Misconfiguration Scan

The image and associated configuration should be checked for security misconfigurations.

This helps identify insecure configuration patterns before deployment.

---

# 🛡️ Dockle CIS Scan

Dockle checks container security practices against recognized container security recommendations.

Run:

```bash
dockle secure-app:1.0
```

The output is stored as part of the automated report.

---

# 📊 Pipeline Summary

The script must print a human-readable summary such as:

```text
========================================
 Docker Security Scan Summary
========================================

Image: secure-app:1.0

Trivy CVE Findings:          0
Trivy Secret Findings:       0
Trivy Misconfiguration:      0
Dockle Findings:             0

Security Gate:               PASSED
Exit Code:                   0
========================================
```

For an insecure image:

```text
========================================
 Docker Security Scan Summary
========================================

Image: vulnerable-app:latest

Trivy CVE Findings:          12
Trivy Secret Findings:       1
Trivy Misconfiguration:      4
Dockle Findings:             7

Security Gate:               FAILED
Exit Code:                   1
========================================
```

---

# 🚦 CVE Security Gate

The pipeline must return:

```text
Exit 0 → No HIGH/CRITICAL CVEs
Exit 1 → At least one HIGH/CRITICAL CVE
```

This makes the script suitable for CI/CD integration.

Example:

```bash
bash scan-pipeline.sh secure-app:1.0

echo $?
```

Expected:

```text
0
```

---

# 📄 Dockerfile Audit

All Dockerfiles created during the lab must be checked using Hadolint.

Run:

```bash
hadolint Dockerfile
```

For every Dockerfile, record:

* 📁 Dockerfile path
* 🔢 Line number
* 🏷️ Rule ID
* ⚠️ Severity
* 📝 Description

---

# 🧾 dockerfile-audit.txt

The consolidated audit file should look similar to:

```text
Dockerfile:5 DL3008 WARNING Use version pinning instead of apt-get install
Dockerfile:10 DL3015 INFO Avoid additional packages by specifying --no-install-recommends
Dockerfile.optimized:8 DL3042 WARNING Avoid use of cache directories
```

The exact findings depend on the Dockerfiles and the installed Hadolint rules.

Create the file:

```bash
touch dockerfile-audit.txt
```

Run Hadolint against each Dockerfile:

```bash
hadolint Dockerfile
hadolint Dockerfile.optimized
```

Record the findings in:

```text
dockerfile-audit.txt
```

---

# 🚨 Error-Level Findings

Any Hadolint finding at severity `ERROR` must be remediated.

After making corrections, run:

```bash
hadolint Dockerfile
```

The goal is:

```text
No ERROR-level findings
```

Warnings and informational findings may remain, but must still be documented.

---

# 🧪 Validation and Acceptance Criteria

## 🔐 Docker Daemon

The daemon must demonstrate:

* ✅ User namespace remapping
* ✅ `dockremap` mapping
* ✅ ICC disabled
* ✅ No-new-privileges enabled
* ✅ JSON logging
* ✅ 10 MB maximum log size
* ✅ 3 maximum rotated logs
* ✅ `nofile` 64000 soft/hard limit

---

## 🐳 Secure Image

The image must:

* ✅ Use Ubuntu 22.04 build stage
* ✅ Use Alpine production stage
* ✅ Run as UID 1001
* ✅ Include HEALTHCHECK
* ✅ Exclude build tools
* ✅ Exclude package manager caches
* ✅ Have minimal runtime contents
* ✅ Be smaller than 20 MB

Check:

```bash
docker images secure-app:1.0
```

---

## 🛡️ Runtime

The container must run with:

```text
--read-only
--cap-drop=ALL
--memory=64m
--pids-limit=50
--security-opt=no-new-privileges:true
```

---

# 🔎 Vulnerable Image Test

The lab also uses an intentionally outdated image:

```text
vulnerable-app:latest
```

based on:

```text
ubuntu:18.04
```

The pipeline is expected to detect HIGH/CRITICAL vulnerabilities.

Run:

```bash
bash scan-pipeline.sh vulnerable-app:latest
```

Expected:

```text
Exit Code: 1
```

This demonstrates the CVE security gate working correctly.

---

# 🏆 Secure Image Test

Run the pipeline against:

```bash
bash scan-pipeline.sh secure-app:1.0
```

Expected:

```text
Exit Code: 0
```

The four reports should be created:

```text
reports/
```

and contain scan output.

---

# 📊 Security Controls Summary

| Security Layer | Control           | Purpose                                     |
| -------------- | ----------------- | ------------------------------------------- |
| Docker Daemon  | UserNS Remapping  | Isolate container root                      |
| Docker Daemon  | ICC Disabled      | Reduce container-to-container communication |
| Docker Daemon  | No New Privileges | Prevent privilege escalation                |
| Docker Daemon  | Log Rotation      | Prevent uncontrolled log growth             |
| Docker Daemon  | `nofile` Limit    | Resource control                            |
| Image          | Multi-Stage Build | Reduce attack surface                       |
| Image          | Alpine Runtime    | Minimal production image                    |
| Image          | Non-Root UID 1001 | Reduce privilege                            |
| Image          | HEALTHCHECK       | Runtime health monitoring                   |
| Runtime        | Read-Only FS      | Prevent filesystem modification             |
| Runtime        | Drop ALL Caps     | Reduce kernel privileges                    |
| Runtime        | Memory 64 MB      | Resource isolation                          |
| Runtime        | PID Limit 50      | Fork/process protection                     |
| Runtime        | No New Privileges | Privilege escalation protection             |
| Pipeline       | Trivy CVE         | Vulnerability detection                     |
| Pipeline       | Trivy Secrets     | Secret detection                            |
| Pipeline       | Trivy Misconfig   | Configuration security                      |
| Pipeline       | Dockle            | Container security audit                    |
| Pipeline       | Hadolint          | Dockerfile security/linting                 |

---

# 🧠 Defense-in-Depth Model

The lab demonstrates that container security should not depend on one control.

```text
                 🛡️ DEFENSE IN DEPTH
                         │
       ┌─────────────────┼─────────────────┐
       │                 │                 │
       ▼                 ▼                 ▼
   DAEMON             IMAGE             PIPELINE
   SECURITY           SECURITY          SECURITY
       │                 │                 │
       ▼                 ▼                 ▼
   UserNS             Non-Root          Trivy
   ICC                Alpine            Dockle
   NoNewPrivs         Multi-Stage       Hadolint
   Resource Limits    Read-Only
   Logging            Drop Caps
       │                 │                 │
       └─────────────────┼─────────────────┘
                         ▼
                 SECURE CONTAINER
```

If one control fails, additional controls provide another layer of protection.

---

# 🚨 Troubleshooting

## Docker Repository Error

If you see:

```text
E: Malformed entry 1 in list file
```

Inspect:

```bash
cat /etc/apt/sources.list.d/docker.list
```

The repository must be one unbroken line.

Remove the broken file:

```bash
sudo rm /etc/apt/sources.list.d/docker.list
```

Recreate it using the correct Docker repository configuration.

---

## Trivy 404 Error

If the installation script returns:

```text
curl: (22) The requested URL returned error: 404
```

Check the latest Trivy installation/release instructions and install the current package.

Verify:

```bash
trivy --version
```

---

## Hadolint Exec Format Error

Check:

```bash
file /usr/local/bin/hadolint
```

If it reports an HTML document, the release URL is incorrect.

Download the correct Linux executable from the Hadolint releases.

---

## Dockle Invalid `.deb`

If you see:

```text
not a Debian format archive
```

check:

```bash
file /tmp/dockle.deb
```

If it is HTML, verify the exact release filename before downloading again.

---

## Docker Daemon Fails to Restart

Check:

```bash
sudo systemctl status docker
```

Review logs:

```bash
sudo journalctl -u docker --no-pager -n 100
```

Validate:

```bash
sudo cat /etc/docker/daemon.json
```

Correct any invalid JSON before restarting Docker.

---

# 🧹 Cleanup

Stop the secure container:

```bash
docker stop secure-app
```

Remove it:

```bash
docker rm secure-app
```

Remove the image:

```bash
docker rmi secure-app:1.0
```

Remove unused Docker resources:

```bash
docker system prune -f
```

> ⚠️ Be careful with `docker system prune` because it removes unused Docker resources.

---

# 📁 Recommended Repository Structure

```text
advanced-docker-security/
│
├── README.md
│
├── Dockerfile
├── Dockerfile.optimized
│
├── scan-pipeline.sh
├── dockerfile-audit.txt
│
├── reports/
│   ├── secure-app-cve.txt
│   ├── secure-app-secrets.txt
│   ├── secure-app-misconfig.txt
│   └── secure-app-dockle.txt
│
└── screenshots/
    ├── docker-info.png
    ├── trivy-scan.png
    ├── dockle-scan.png
    └── secure-container.png
```

---

# 🛠️ Technologies Used

```text
🐳 Docker Engine
🔎 Trivy
🛡️ Dockle
📋 Hadolint
🐧 Ubuntu
🏔️ Alpine Linux
☁️ AWS EC2
🐚 Bash
🔐 Linux Namespaces
🛡️ Linux Capabilities
📦 Docker Multi-Stage Builds
```

---

# 📈 Skills Demonstrated

This lab demonstrates practical experience with:

* 🔐 Docker daemon hardening
* 🛡️ Container security
* 👤 Linux user namespace isolation
* 🔒 Linux capability management
* 🚫 Privilege escalation prevention
* 📦 Secure multi-stage builds
* 🐳 Minimal container images
* 🔎 Vulnerability management
* 🔑 Secret detection
* 📋 Dockerfile auditing
* 🛡️ CIS container security
* 🐚 Bash automation
* 🚦 Security gates
* 📊 Security reporting
* ☁️ AWS EC2
* 🔄 DevSecOps practices

---

# 🏆 Expected Outcomes

At the end of the lab, you should have:

### ✅ Hardened Docker Daemon

A Docker daemon enforcing:

```text
User Namespace Remapping
ICC Disabled
No-New-Privileges
Resource Limits
Secure JSON Logging
```

### ✅ Hardened Production Image

A minimal:

```text
secure-app:1.0
```

image with:

```text
UID 1001
Alpine Runtime
Read-Only Filesystem
Dropped Capabilities
64 MB Memory Limit
50 PID Limit
HEALTHCHECK
```

### ✅ Automated Security Pipeline

A reproducible:

```text
scan-pipeline.sh
```

that performs:

```text
CVE Scan
   ↓
Secret Scan
   ↓
Misconfiguration Scan
   ↓
Dockle Scan
   ↓
Security Gate
```

### ✅ Dockerfile Audit

A consolidated:

```text
dockerfile-audit.txt
```

containing documented Hadolint findings.

---

# 🎯 Conclusion

This lab demonstrates Docker security at **three critical layers: daemon configuration, image construction, and automated security validation**.

The implemented controls provide a defense-in-depth approach:

```text
          Docker Security
                │
      ┌─────────┼─────────┐
      ▼         ▼         ▼
   Daemon     Image     Pipeline
   Hardening  Hardening  Security
      │         │         │
      ▼         ▼         ▼
   UserNS     Non-Root   Trivy
   ICC        Minimal    Dockle
   NoNewPriv  Alpine     Hadolint
   Limits     Drop Caps  CVE Gate
                │
                ▼
         Secure Container
```

The most important lesson is that **container security is not a single configuration option**. It requires multiple complementary controls working together.

Regularly update vulnerability databases and security tooling because an image that passes today may fail after new CVEs are published.

> 🛡️ **Secure the daemon. Harden the image. Restrict the runtime. Automate the security checks.**

---

# ⭐ Lab Achievement

🎉 **Successfully completed the Advanced Docker Security lab!**

This project demonstrates hands-on knowledge of **Docker hardening, Linux namespaces, container capabilities, secure image construction, Trivy, Dockle, Hadolint, vulnerability scanning, security automation, and DevSecOps practices.**

---

## 👨‍💻 Author

**Hafiz Muhammad Salman**

**Cloud DevOps Engineer | Linux Administrator**

### 🔧 Technology Stack

`Docker` • `Trivy` • `Dockle` • `Hadolint` • `AWS EC2` • `Ubuntu` • `Alpine Linux` • `Bash` • `DevSecOps` • `Container Security`

---

## ⭐ Support

If this lab helped you learn Docker security, consider giving the repository a ⭐ and sharing it with other DevOps and DevSecOps learners.

**Keep Learning • Keep Securing • Keep Automating 🚀**
