# 🔐 Implementing Production-Grade RBAC in Argo CD

![Argo CD](https://img.shields.io/badge/Argo%20CD-GitOps-orange?style=for-the-badge\&logo=argo)
![Kubernetes](https://img.shields.io/badge/Kubernetes-Container%20Orchestration-326CE5?style=for-the-badge\&logo=kubernetes\&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-Container%20Runtime-2496ED?style=for-the-badge\&logo=docker\&logoColor=white)
![Minikube](https://img.shields.io/badge/Minikube-Local%20Kubernetes-9435E9?style=for-the-badge\&logo=kubernetes\&logoColor=white)
![Casbin](https://img.shields.io/badge/Casbin-RBAC%20Policy-00ADD8?style=for-the-badge)
![Linux](https://img.shields.io/badge/Linux-Ubuntu-E95420?style=for-the-badge\&logo=ubuntu\&logoColor=white)
![Shell](https://img.shields.io/badge/Shell-Bash-4EAA25?style=for-the-badge\&logo=gnu-bash\&logoColor=white)
![GitOps](https://img.shields.io/badge/GitOps-Argo%20CD-blue?style=for-the-badge)

---

## 📌 Overview

This lab demonstrates how to **design, implement, validate, and troubleshoot production-grade Role-Based Access Control (RBAC) in Argo CD**.

Argo CD uses the **Casbin policy engine** to control access to Applications, Projects, Repositories, Clusters, Logs, and other resources.

The lab implements a three-tier access model:

| User          | Role               | Access Level                                  |
| ------------- | ------------------ | --------------------------------------------- |
| 👨‍💻 `alice` | Developer          | Read, sync scoped applications, read logs     |
| ⚙️ `bob`      | DevOps             | Application lifecycle + repository management |
| 👑 `charlie`  | Organization Admin | Full access                                   |

The implementation also demonstrates **AppProject isolation**, policy testing, `can-i` authorization checks, and server-side RBAC audit logging.

---

# 🎯 Objectives

By completing this lab, you will learn how to:

* 🔐 Design a multi-tier Argo CD RBAC policy
* 🛡️ Implement least-privilege access
* ⚙️ Configure Casbin policy rules
* 👨‍💻 Create developer, DevOps, and administrator roles
* 📦 Configure Argo CD AppProjects
* 🚧 Restrict users to specific application projects
* 🧪 Validate allowed and denied operations
* 🔎 Use `argocd account can-i`
* 📋 Analyze Argo CD server logs
* 🐚 Build an automated RBAC validation script
* 🛠️ Troubleshoot RBAC policy misconfigurations
* 📊 Verify policy decisions against audit logs

---

# 🧰 Technologies & Tools

| Technology    | Purpose                    |
| ------------- | -------------------------- |
| 🐳 Docker     | Container runtime          |
| ☸️ Kubernetes | Container orchestration    |
| 🚀 Minikube   | Local Kubernetes cluster   |
| 🐙 Argo CD    | GitOps continuous delivery |
| 🔐 Casbin     | RBAC policy engine         |
| 🖥️ kubectl   | Kubernetes CLI             |
| ⚡ Argo CD CLI | Argo CD management         |
| 🐚 Bash       | Automation and validation  |
| 🐧 Ubuntu     | Lab operating system       |

---

# 🏗️ Lab Architecture

```text
                    ┌─────────────────────┐
                    │     Ubuntu EC2      │
                    │      Instance       │
                    └──────────┬──────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │      Docker         │
                    └──────────┬──────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │     Minikube        │
                    │ Kubernetes Cluster  │
                    └──────────┬──────────┘
                               │
                    ┌──────────▼──────────┐
                    │      Argo CD        │
                    │                     │
                    │  Casbin RBAC Engine │
                    └──────────┬──────────┘
                               │
             ┌─────────────────┼─────────────────┐
             │                 │                 │
             ▼                 ▼                 ▼
        👨‍💻 Alice          ⚙️ Bob          👑 Charlie
        Developer          DevOps          Org Admin
             │                 │                 │
             ▼                 ▼                 ▼
        Team Alpha       Applications      All Resources
        Applications     Repositories
                         Clusters
                         Projects
```

---

# 📋 Prerequisites

Before starting, you should understand:

* Linux command-line operations
* Linux users and groups
* File permissions
* Basic networking
* Kubernetes RBAC concepts
* Kubernetes namespaces
* GitOps principles
* Argo CD Applications
* Argo CD AppProjects
* Application synchronization

---

# ☁️ Lab Environment

The lab uses a dedicated **AWS EC2 Ubuntu instance provided by Al Nafi**.

The base system does not contain the required tools, so the environment is provisioned during the lab.

Minimum Minikube resources:

```text
CPU    : 2
Memory : 4 GB
Driver : Docker
```

---

# 🚀 Task 1 — Provision the Environment

## 1.1 Update Ubuntu

```bash
sudo apt-get update -y
sudo apt-get upgrade -y

sudo apt-get install -y \
  curl \
  wget \
  git \
  apt-transport-https \
  ca-certificates \
  gnupg \
  lsb-release
```

---

## 1.2 Install Docker

```bash
curl -fsSL https://get.docker.com | sudo sh

sudo usermod -aG docker $USER

newgrp docker

docker version
```

Enable Docker:

```bash
sudo systemctl enable docker
sudo systemctl start docker
```

Verify:

```bash
docker info
```

### 🛠️ Troubleshooting

If Docker returns:

```text
permission denied while trying to connect to the Docker daemon socket
```

Run:

```bash
groups
```

If `docker` is not listed:

```bash
newgrp docker
```

If required, log out and log back in.

---

# ☸️ 1.3 Install kubectl

```bash
KUBECTL_VERSION=$(curl -fsSL https://dl.k8s.io/release/stable.txt)

curl -fsSL \
"https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
-o kubectl

sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

rm kubectl
```

Verify:

```bash
kubectl version --client
```

---

# ⛵ 1.4 Install Minikube

```bash
curl -fsSL \
https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
-o minikube

sudo install -o root -g root -m 0755 minikube /usr/local/bin/minikube

rm minikube
```

Verify:

```bash
minikube version
```

---

# 🚀 1.5 Start Kubernetes Cluster

```bash
minikube start \
  --driver=docker \
  --memory=4096 \
  --cpus=2
```

Verify:

```bash
kubectl cluster-info
kubectl get nodes
```

Expected result:

```text
NAME       STATUS   ROLES           AGE
minikube   Ready    control-plane   ...
```

---

# 🚀 Task 2 — Deploy Argo CD

## 2.1 Create Argo CD Namespace

```bash
kubectl create namespace argocd
```

---

## 2.2 Install Argo CD

```bash
kubectl apply \
  -n argocd \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

Check pods:

```bash
kubectl get pods -n argocd
```

---

## 2.3 Wait for Argo CD Components

```bash
kubectl wait \
  --for=condition=available \
  --timeout=300s \
  deployment/argocd-server \
  -n argocd

kubectl wait \
  --for=condition=available \
  --timeout=300s \
  deployment/argocd-repo-server \
  -n argocd

kubectl wait \
  --for=condition=available \
  --timeout=300s \
  deployment/argocd-application-controller \
  -n argocd
```

Verify:

```bash
kubectl get pods -n argocd
```

All critical components should reach:

```text
Running
```

---

# 🛠️ Argo CD Troubleshooting

If a component does not become ready:

```bash
kubectl describe pod \
  -n argocd \
  -l app.kubernetes.io/name=argocd-server
```

Check for:

* `ImagePullBackOff`
* `CrashLoopBackOff`
* insufficient memory
* insufficient CPU

Increase Minikube resources if necessary:

```bash
minikube stop

minikube start \
  --driver=docker \
  --memory=6144 \
  --cpus=2
```

---

# ⚡ 2.4 Install Argo CD CLI

```bash
ARGOCD_VERSION=$(curl -fsSL \
https://api.github.com/repos/argoproj/argo-cd/releases/latest \
| grep '"tag_name"' \
| sed 's/.*"tag_name": "\(.*\)".*/\1/')
```

Download:

```bash
curl -fsSL \
"https://github.com/argoproj/argo-cd/releases/download/${ARGOCD_VERSION}/argocd-linux-amd64" \
-o argocd
```

Install:

```bash
sudo install -m 0755 argocd /usr/local/bin/argocd

rm argocd
```

Verify:

```bash
argocd version --client
```

---

# 🔑 2.5 Authenticate with Argo CD

Expose Argo CD:

```bash
kubectl port-forward \
  svc/argocd-server \
  -n argocd \
  8080:443 &
```

Retrieve the initial admin password:

```bash
ARGOCD_INITIAL_PASSWORD=$(kubectl \
  -n argocd \
  get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" \
  | base64 --decode)
```

Login:

```bash
argocd login localhost:8080 \
  --username admin \
  --password "${ARGOCD_INITIAL_PASSWORD}" \
  --insecure
```

Verify accounts:

```bash
argocd account list
```

Expected:

```text
admin    Enabled: true
```

---

# 🔐 Task 3 — Implement Multi-Tier RBAC

## 3.1 Access Control Model

The lab implements:

```text
Developer
   │
   ├── Read Applications
   ├── Sync Team Alpha
   └── Read Logs

DevOps
   │
   ├── Full Application Lifecycle
   ├── Repository Management
   ├── Read Clusters
   ├── Read Projects
   └── Read Logs

Organization Admin
   │
   └── Full Access
```

---

# 👥 RBAC Matrix

| User      | Role      | Applications          | Repositories    | Clusters | Projects | Logs |
| --------- | --------- | --------------------- | --------------- | -------- | -------- | ---- |
| `alice`   | Developer | Get + Team Alpha Sync | ❌               | ❌        | ❌        | Read |
| `bob`     | DevOps    | Full Lifecycle        | Full Management | Read     | Read     | Read |
| `charlie` | Org Admin | Full                  | Full            | Full     | Full     | Full |

---

# 🏷️ 3.2 Create Application Namespaces

```bash
kubectl create namespace alpha-ns
kubectl create namespace beta-ns
```

---

# 👤 3.3 Create Local Argo CD Users

Patch `argocd-cm`:

```bash
kubectl patch configmap argocd-cm \
  -n argocd \
  --type merge \
  -p '{
    "data": {
      "accounts.alice": "login",
      "accounts.bob": "login",
      "accounts.charlie": "login"
    }
  }'
```

Verify:

```bash
kubectl get configmap argocd-cm \
  -n argocd \
  -o jsonpath='{.data}' \
  | tr ',' '\n'
```

---

# 🔑 3.4 Configure User Passwords

Retrieve admin password:

```bash
ARGOCD_INITIAL_PASSWORD=$(kubectl \
  -n argocd \
  get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" \
  | base64 --decode)
```

Set Alice's password:

```bash
argocd account update-password \
  --account alice \
  --new-password "AlicePass#2024" \
  --current-password "${ARGOCD_INITIAL_PASSWORD}"
```

Set Bob's password:

```bash
argocd account update-password \
  --account bob \
  --new-password "BobPass#2024" \
  --current-password "${ARGOCD_INITIAL_PASSWORD}"
```

Set Charlie's password:

```bash
argocd account update-password \
  --account charlie \
  --new-password "CharliePass#2024" \
  --current-password "${ARGOCD_INITIAL_PASSWORD}"
```

Verify:

```bash
argocd account list
```

> ⚠️ **Security Note:** The passwords above are lab credentials only. Never use them in production.

---

# 📦 3.5 Create AppProjects

## Team Alpha

```yaml
apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: team-alpha
  namespace: argocd
spec:
  description: "Project scoped to the alpha team namespace"

  sourceRepos:
    - "https://github.com/argoproj/argocd-example-apps.git"

  destinations:
    - namespace: alpha-ns
      server: https://kubernetes.default.svc

  namespaceResourceWhitelist:
    - group: apps
      kind: Deployment
    - group: ""
      kind: Service
    - group: ""
      kind: ConfigMap
```

Apply:

```bash
kubectl apply -f team-alpha.yaml
```

---

## Team Beta

```yaml
apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: team-beta
  namespace: argocd
spec:
  description: "Project scoped to the beta team namespace"

  sourceRepos:
    - "https://github.com/argoproj/argocd-example-apps.git"

  destinations:
    - namespace: beta-ns
      server: https://kubernetes.default.svc

  namespaceResourceWhitelist:
    - group: apps
      kind: Deployment
    - group: ""
      kind: Service
    - group: ""
      kind: ConfigMap
```

Apply:

```bash
kubectl apply -f team-beta.yaml
```

Verify:

```bash
argocd proj list
```

---

# 🛡️ 3.6 Configure Casbin RBAC Policy

Create `argocd-rbac-cm`:

```yaml
apiVersion: v1
kind: ConfigMap

metadata:
  name: argocd-rbac-cm
  namespace: argocd

data:

  policy.default: role:readonly

  policy.csv: |

    # ==========================================
    # READONLY
    # ==========================================

    p, role:readonly, applications, get, */*, allow
    p, role:readonly, projects, get, *, allow


    # ==========================================
    # DEVELOPER
    # ==========================================

    p, role:developer, applications, get, */*, allow
    p, role:developer, applications, sync, team-alpha/*, allow
    p, role:developer, logs, get, */*, allow


    # ==========================================
    # DEVOPS
    # ==========================================

    p, role:devops, applications, get, */*, allow
    p, role:devops, applications, create, */*, allow
    p, role:devops, applications, update, */*, allow
    p, role:devops, applications, delete, */*, allow
    p, role:devops, applications, sync, */*, allow

    p, role:devops, repositories, get, *, allow
    p, role:devops, repositories, create, *, allow
    p, role:devops, repositories, update, *, allow
    p, role:devops, repositories, delete, *, allow

    p, role:devops, clusters, get, *, allow
    p, role:devops, projects, get, *, allow
    p, role:devops, logs, get, */*, allow


    # ==========================================
    # ORGANIZATION ADMIN
    # ==========================================

    p, role:org-admin, *, *, *, allow


    # ==========================================
    # USER → ROLE MAPPINGS
    # ==========================================

    g, alice, role:developer
    g, bob, role:devops
    g, charlie, role:org-admin
```

Apply:

```bash
kubectl apply -f argocd-rbac-cm.yaml
```

Verify:

```bash
kubectl get configmap argocd-rbac-cm \
  -n argocd \
  -o jsonpath='{.data.policy\.csv}'
```

---

# 🔄 3.7 Restart Argo CD Server

```bash
kubectl rollout restart \
  deployment/argocd-server \
  -n argocd
```

Wait:

```bash
kubectl wait \
  --for=condition=available \
  --timeout=120s \
  deployment/argocd-server \
  -n argocd
```

---

# 📱 Task 4 — Deploy Test Applications

## 4.1 Team Alpha Application

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application

metadata:
  name: guestbook-alpha
  namespace: argocd

spec:
  project: team-alpha

  source:
    repoURL: https://github.com/argoproj/argocd-example-apps.git
    targetRevision: HEAD
    path: guestbook

  destination:
    server: https://kubernetes.default.svc
    namespace: alpha-ns

  syncPolicy:
    automated:
      prune: false
      selfHeal: false
```

Apply:

```bash
kubectl apply -f guestbook-alpha.yaml
```

---

# 4.2 Team Beta Application

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application

metadata:
  name: guestbook-beta
  namespace: argocd

spec:
  project: team-beta

  source:
    repoURL: https://github.com/argoproj/argocd-example-apps.git
    targetRevision: HEAD
    path: guestbook

  destination:
    server: https://kubernetes.default.svc
    namespace: beta-ns

  syncPolicy:
    automated:
      prune: false
      selfHeal: false
```

Apply:

```bash
kubectl apply -f guestbook-beta.yaml
```

Verify:

```bash
argocd app list
```

Expected applications:

```text
guestbook-alpha    team-alpha
guestbook-beta     team-beta
```

---

# 🧪 Task 5 — Validate RBAC Boundaries

The lab requires an automated validation harness called:

```text
rbac-validator.sh
```

The script validates:

* Authentication
* Authorization
* Allowed operations
* Denied operations
* Application boundaries
* Repository permissions
* Project permissions
* Cluster permissions

---

# 📊 Required RBAC Test Matrix

| User    | Resource     | Action | Object                     | Expected |
| ------- | ------------ | ------ | -------------------------- | -------- |
| Alice   | applications | get    | team-alpha/guestbook-alpha | ✅ Allow  |
| Alice   | applications | sync   | team-alpha/guestbook-alpha | ✅ Allow  |
| Alice   | applications | sync   | team-beta/guestbook-beta   | ❌ Deny   |
| Alice   | applications | create | team-alpha/*               | ❌ Deny   |
| Alice   | applications | delete | team-alpha/*               | ❌ Deny   |
| Bob     | applications | create | team-alpha/*               | ✅ Allow  |
| Bob     | applications | delete | team-alpha/*               | ✅ Allow  |
| Bob     | repositories | create | *                          | ✅ Allow  |
| Bob     | projects     | create | *                          | ❌ Deny   |
| Bob     | clusters     | delete | *                          | ❌ Deny   |
| Charlie | projects     | create | *                          | ✅ Allow  |
| Charlie | clusters     | delete | *                          | ✅ Allow  |

---

# 🧪 RBAC Validation Commands

Check Alice:

```bash
argocd account can-i \
  get applications \
  --as alice \
  "team-alpha/guestbook-alpha"
```

Expected:

```text
yes
```

Check Alice's Team Alpha synchronization:

```bash
argocd account can-i \
  sync applications \
  --as alice \
  "team-alpha/guestbook-alpha"
```

Expected:

```text
yes
```

Check Alice's Team Beta synchronization:

```bash
argocd account can-i \
  sync applications \
  --as alice \
  "team-beta/guestbook-beta"
```

Expected:

```text
no
```

Check Alice application creation:

```bash
argocd account can-i \
  create applications \
  --as alice \
  "team-alpha/*"
```

Expected:

```text
no
```

---

# ⚙️ Bob Validation

Application creation:

```bash
argocd account can-i \
  create applications \
  --as bob \
  "team-alpha/*"
```

Expected:

```text
yes
```

Application deletion:

```bash
argocd account can-i \
  delete applications \
  --as bob \
  "team-alpha/*"
```

Expected:

```text
yes
```

Repository creation:

```bash
argocd account can-i \
  create repositories \
  --as bob \
  "*"
```

Expected:

```text
yes
```

Project creation:

```bash
argocd account can-i \
  create projects \
  --as bob \
  "*"
```

Expected:

```text
no
```

---

# 👑 Charlie Validation

Project creation:

```bash
argocd account can-i \
  create projects \
  --as charlie \
  "*"
```

Expected:

```text
yes
```

Cluster deletion:

```bash
argocd account can-i \
  delete clusters \
  --as charlie \
  "*"
```

Expected:

```text
yes
```

---

# 🧪 Automated RBAC Validator

Create:

```text
rbac-validator.sh
```

The validator should implement:

```bash
rbac_test_case()
rbac_run_suite()
login_as()
restore_admin_session()
```

Required behavior:

```text
PASS
PASS
PASS
PASS
...
```

The final summary must contain:

```text
Total Tests : 12
Passed      : 12
Failed      : 0
Status      : PASS
```

Execute:

```bash
chmod +x rbac-validator.sh

./rbac-validator.sh
```

---

# 📋 Task 6 — Audit RBAC Decisions

## 6.1 Enable Debug Logging

Patch the Argo CD command parameters:

```bash
kubectl patch configmap \
  argocd-cmd-params-cm \
  -n argocd \
  --type merge \
  -p '{
    "data": {
      "server.log.level": "debug",
      "server.log.format": "json"
    }
  }'
```

Restart:

```bash
kubectl rollout restart \
  deployment/argocd-server \
  -n argocd
```

Wait:

```bash
kubectl wait \
  --for=condition=available \
  --timeout=120s \
  deployment/argocd-server \
  -n argocd
```

---

# 🚫 6.2 Trigger a Denied Action

Login as Alice:

```bash
argocd login localhost:8080 \
  --username alice \
  --password "AlicePass#2024" \
  --insecure
```

Attempt to synchronize the Team Beta application:

```bash
argocd app sync guestbook-beta || true
```

The operation should be denied.

---

# 🔎 6.3 Inspect Argo CD Server Logs

```bash
kubectl logs \
  -n argocd \
  deployment/argocd-server \
  --since=2m \
  | grep -i "enforc" \
  | tail -20
```

Look for RBAC enforcement information showing the authorization decision.

---

# 🔐 6.4 Verify with `can-i`

Login as admin:

```bash
ARGOCD_INITIAL_PASSWORD=$(kubectl \
  -n argocd \
  get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" \
  | base64 --decode)

argocd login localhost:8080 \
  --username admin \
  --password "${ARGOCD_INITIAL_PASSWORD}" \
  --insecure
```

Test:

```bash
argocd account can-i \
  sync applications \
  --as alice \
  "team-alpha/guestbook-alpha"
```

Expected:

```text
yes
```

Test:

```bash
argocd account can-i \
  sync applications \
  --as alice \
  "team-beta/guestbook-beta"
```

Expected:

```text
no
```

---

# 🔍 Troubleshooting

## ❌ Unexpected `yes` Authorization

If a user receives:

```text
yes
```

when:

```text
no
```

is expected, inspect:

### 1. Default policy

```yaml
policy.default: role:readonly
```

### 2. User-to-role mappings

```text
g, alice, role:developer
g, bob, role:devops
g, charlie, role:org-admin
```

### 3. Casbin rules

```bash
kubectl get configmap argocd-rbac-cm \
  -n argocd \
  -o yaml
```

### 4. Restart Argo CD Server

```bash
kubectl rollout restart \
  deployment/argocd-server \
  -n argocd
```

---

# ❌ RBAC Logs Not Appearing

Check:

```bash
kubectl get configmap \
  argocd-cmd-params-cm \
  -n argocd \
  -o yaml
```

Verify:

```yaml
server.log.level: debug
server.log.format: json
```

Check the server:

```bash
kubectl logs \
  -n argocd \
  deployment/argocd-server \
  --tail=100
```

Restart if necessary:

```bash
kubectl rollout restart \
  deployment/argocd-server \
  -n argocd
```

---

# 📁 Recommended Repository Structure

```text
argocd-rbac-lab/
│
├── README.md
│
├── manifests/
│   ├── team-alpha.yaml
│   ├── team-beta.yaml
│   ├── guestbook-alpha.yaml
│   ├── guestbook-beta.yaml
│   └── argocd-rbac-cm.yaml
│
├── scripts/
│   └── rbac-validator.sh
│
└── docs/
    └── rbac-test-results.txt
```

---

# 🧹 Cleanup

Delete the test applications:

```bash
kubectl delete application \
  guestbook-alpha \
  guestbook-beta \
  -n argocd
```

Delete projects:

```bash
kubectl delete appproject \
  team-alpha \
  team-beta \
  -n argocd
```

Delete namespaces:

```bash
kubectl delete namespace \
  alpha-ns \
  beta-ns
```

Delete Minikube:

```bash
minikube delete
```

---

# 📈 Expected Results

After completing the lab:

```text
┌──────────────────────────────────────────┐
│       Production RBAC Validation         │
├──────────────────────────────────────────┤
│                                          │
│ Alice → Developer                        │
│   ✓ Application Read                     │
│   ✓ Team Alpha Sync                      │
│   ✗ Team Beta Sync                       │
│   ✗ Application Create                   │
│   ✗ Application Delete                   │
│                                          │
│ Bob → DevOps                             │
│   ✓ Application Lifecycle                │
│   ✓ Repository Management                │
│   ✓ Cluster Read                         │
│   ✓ Project Read                         │
│   ✗ Project Management                   │
│   ✗ Cluster Management                   │
│                                          │
│ Charlie → Organization Admin             │
│   ✓ Full Access                          │
│                                          │
│ RBAC Tests → 12/12 PASS                  │
└──────────────────────────────────────────┘
```

---

# 🏆 Learning Outcomes

By completing this lab, you have demonstrated the ability to:

* ✅ Deploy Argo CD on Kubernetes
* ✅ Configure local Argo CD accounts
* ✅ Design production-style RBAC
* ✅ Work with Casbin policies
* ✅ Implement least privilege
* ✅ Create scoped AppProjects
* ✅ Isolate application environments
* ✅ Control application synchronization
* ✅ Manage repository permissions
* ✅ Separate DevOps and administrator privileges
* ✅ Automate RBAC validation
* ✅ Use `argocd account can-i`
* ✅ Analyze Argo CD server logs
* ✅ Troubleshoot authorization failures
* ✅ Implement defense-in-depth access control

---

# 🔐 Security Best Practices

For production deployments:

* 🔑 Never use hardcoded passwords
* 🔐 Integrate SSO/OIDC where possible
* 👥 Use groups instead of individual user mappings
* 🎯 Follow least-privilege principles
* 📦 Scope Applications with AppProjects
* 🚫 Avoid unnecessary wildcard permissions
* 📝 Enable centralized audit logging
* 🔄 Regularly review RBAC policies
* 🧪 Automate authorization testing
* 🔒 Protect Argo CD administrative accounts
* 📊 Monitor failed authorization attempts
* 🔑 Rotate credentials regularly

---

# 🎯 Production RBAC Model

```text
                    Argo CD
                       │
                 ┌─────▼─────┐
                 │   Casbin  │
                 │ RBAC Engine│
                 └─────┬─────┘
                       │
        ┌──────────────┼──────────────┐
        │              │              │
        ▼              ▼              ▼
   Developer         DevOps       Org Admin
        │              │              │
        ▼              ▼              ▼
  Limited Access   Operational      Full Access
        │              │              │
        ▼              ▼              ▼
 Team Alpha       Apps/Repos       Everything
```

---

# 📚 Conclusion

This lab demonstrated how **Argo CD's Casbin-based RBAC engine** can be used to implement production-grade access control across users, roles, Applications, AppProjects, repositories, clusters, and projects.

The implementation followed a **defense-in-depth and least-privilege approach**, separating responsibilities between developers, DevOps engineers, and organization administrators.

You also created automated validation using `rbac-validator.sh`, verified authorization decisions through `argocd account can-i`, and analyzed Argo CD server logs to confirm that policy decisions were being enforced correctly.

These practices are directly applicable to production GitOps environments where **separation of duties, controlled application access, namespace isolation, auditing, and compliance** are critical requirements.

---

## 🌟 Key Takeaway

> **Production-grade RBAC is not simply about granting permissions — it is about ensuring every user receives exactly the permissions required to perform their responsibilities, while all unauthorized actions are explicitly prevented and auditable.**

---

### 🛠️ Lab Technologies

`Argo CD` • `Kubernetes` • `Docker` • `Minikube` • `Casbin` • `kubectl` • `Bash` • `GitOps` • `AWS EC2` • `Ubuntu`

---

## 👨‍💻 Author

**Hafiz Muhammad Salman**

**Cloud DevOps Engineer | Linux Administrator**

⭐ If this lab helped you understand Argo CD RBAC, consider starring the repository!
