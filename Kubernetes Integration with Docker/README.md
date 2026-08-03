<div align="center">

# ☸️ Kubernetes Integration with Docker

### A Hands-On Al Nafi Lab for Local Container Orchestration with Minikube

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)
![Minikube](https://img.shields.io/badge/Minikube-2496ED?style=for-the-badge&logo=kubernetes&logoColor=white)
![kubectl](https://img.shields.io/badge/kubectl-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)
![Nginx](https://img.shields.io/badge/Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)

**Difficulty:** Intermediate • **Estimated Time:** 120–150 minutes

</div>

---

## 📖 Table of Contents

- [🎯 Lab Objectives](#-lab-objectives)
- [✅ Prerequisites](#-prerequisites)
- [🖥️ Lab Environment](#️-lab-environment)
- [🛠️ Task 1: Install Kubernetes (Minikube)](#️-task-1-install-kubernetes-minikube)
- [🐳 Task 2: Push Docker Images to Kubernetes using kubectl](#-task-2-push-docker-images-to-kubernetes-using-kubectl)
- [☸️ Task 3: Deploy Containers in Kubernetes and Manage Pods with kubectl](#️-task-3-deploy-containers-in-kubernetes-and-manage-pods-with-kubectl)
- [🩹 Troubleshooting Tips](#-troubleshooting-tips)
- [📌 Key Concepts Learned](#-key-concepts-learned)
- [🏁 Conclusion](#-conclusion)

---

## 🎯 Lab Objectives

By the end of this lab, students will be able to:

| # | Objective |
|---|-----------|
| 1 | Install and configure Kubernetes using Minikube on a single Linux machine |
| 2 | Understand the relationship between Docker containers and Kubernetes pods |
| 3 | Build and manage Docker images for Kubernetes deployment |
| 4 | Deploy containerized applications to Kubernetes using `kubectl` |
| 5 | Manage Kubernetes pods, services, and deployments |
| 6 | Monitor and troubleshoot Kubernetes applications |
| 7 | Scale applications horizontally using Kubernetes features |

## ✅ Prerequisites

Before starting this lab, students should have:

- ✔️ Basic understanding of Linux command line operations
- ✔️ Fundamental knowledge of Docker containers and images
- ✔️ Basic understanding of YAML file format
- ✔️ Familiarity with text editors like `nano` or `vim`
- ✔️ Understanding of networking concepts (ports, IP addresses)

## 🖥️ Lab Environment

> **☁️ Al Nafi Cloud Machine Setup:** Students will use Al Nafi's provided Linux-based cloud machines. Simply click **Start Lab** to access your dedicated Linux environment. The provided machine is bare metal with no pre-installed tools — you will install all required software during this lab.

> 🖥️ **System Requirements:** The lab runs entirely on a single Linux machine with no need for additional virtual machines or remote hosts.

---

## 🛠️ Task 1: Install Kubernetes (Minikube)

![Task Stack](https://img.shields.io/badge/Stack-Docker%20Engine-2496ED?style=flat-square&logo=docker&logoColor=white) ![Task Stack](https://img.shields.io/badge/Stack-Minikube-2496ED?style=flat-square&logo=kubernetes&logoColor=white)

> 🚦 **Sign-in Step:** Standing up the full local stack — Docker as the container runtime, `kubectl` as the control CLI, and Minikube as the single-node Kubernetes cluster itself.

### 🧩 Subtask 1.1: Update System and Install Dependencies

```bash
# 🔄 Update package repository
sudo apt update && sudo apt upgrade -y

# 📦 Install curl, wget, and other essential tools
sudo apt install -y curl wget apt-transport-https ca-certificates gnupg lsb-release

# 🐳 Install Docker if not already installed
sudo apt install -y docker.io

# ▶️ Start and enable Docker service
sudo systemctl start docker
sudo systemctl enable docker

# 👤 Add current user to docker group
sudo usermod -aG docker $USER

# ♻️ Apply group changes (logout and login, or use newgrp)
newgrp docker
```

### 🧩 Subtask 1.2: Install kubectl

```bash
# ⬇️ Download kubectl binary
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

# 🔓 Make kubectl executable
chmod +x kubectl

# 📂 Move kubectl to system PATH
sudo mv kubectl /usr/local/bin/

# ✅ Verify kubectl installation
kubectl version --client
```

### 🧩 Subtask 1.3: Install Minikube

```bash
# ⬇️ Download Minikube binary
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

# 📥 Install Minikube
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# ✅ Verify Minikube installation
minikube version
```

### 🧩 Subtask 1.4: Start Minikube Cluster

```bash
# 🐝 Start Minikube with Docker driver
minikube start --driver=docker

# ✅ Verify cluster status
minikube status

# 🔍 Check cluster information
kubectl cluster-info

# 📋 View cluster nodes
kubectl get nodes
```

> ✅ **Expected Output:** You should see your Minikube node in `Ready` status.

<!-- TODO: Run `kubectl get nodes -o wide` and note the node's internal IP and Kubernetes version -->

---

## 🐳 Task 2: Push Docker Images to Kubernetes using kubectl

![Task Stack](https://img.shields.io/badge/Service-Nginx-009639?style=flat-square&logo=nginx&logoColor=white) ![Task Stack](https://img.shields.io/badge/Format-YAML-CB171E?style=flat-square&logo=yaml&logoColor=white)

> 🚦 **Sign-in Step:** Building the app image straight into Minikube's own Docker daemon — no external registry needed — then authoring the Deployment and Service manifests that will run it.

### 🧩 Subtask 2.1: Create a Sample Application

```bash
# 📁 Create project directory
mkdir ~/k8s-lab
cd ~/k8s-lab

# 📝 Create a simple HTML file
cat > index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Kubernetes Lab Application</title>
</head>
<body>
    <h1>Welcome to Kubernetes Integration Lab</h1>
    <p>This application is running in a Kubernetes pod!</p>
    <p>Hostname: <span id="hostname"></span></p>
    <script>
        document.getElementById('hostname').textContent = window.location.hostname;
    </script>
</body>
</html>
EOF

# 🐳 Create Dockerfile
cat > Dockerfile << 'EOF'
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
EOF
```

### 🧩 Subtask 2.2: Build Docker Image

```bash
# 🔀 Configure Docker to use Minikube's Docker daemon
eval $(minikube docker-env)

# 🔨 Build Docker image
docker build -t k8s-lab-app:v1.0 .

# ✅ Verify image creation
docker images | grep k8s-lab-app
```

> 📝 **Important Note:** Using `eval $(minikube docker-env)` ensures Docker images are built directly in Minikube's Docker registry, eliminating the need to push images to external registries.

### 🧩 Subtask 2.3: Create Kubernetes Deployment Manifest

```yaml
# 📝 app-deployment.yaml
cat > app-deployment.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: k8s-lab-app-deployment
  labels:
    app: k8s-lab-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: k8s-lab-app
  template:
    metadata:
      labels:
        app: k8s-lab-app
    spec:
      containers:
      - name: k8s-lab-app
        image: k8s-lab-app:v1.0
        imagePullPolicy: Never
        ports:
        - containerPort: 80
        resources:
          requests:
            memory: "64Mi"
            cpu: "250m"
          limits:
            memory: "128Mi"
            cpu: "500m"
EOF
```

### 🧩 Subtask 2.4: Create Kubernetes Service Manifest

```yaml
# 📝 app-service.yaml
cat > app-service.yaml << 'EOF'
apiVersion: v1
kind: Service
metadata:
  name: k8s-lab-app-service
spec:
  selector:
    app: k8s-lab-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
      nodePort: 30080
  type: NodePort
EOF
```

<!-- TODO: Explain in your own words why imagePullPolicy is set to Never in this manifest -->

---

## ☸️ Task 3: Deploy Containers in Kubernetes and Manage Pods with kubectl

![Task Stack](https://img.shields.io/badge/Tool-kubectl-326CE5?style=flat-square&logo=kubernetes&logoColor=white) ![Task Stack](https://img.shields.io/badge/Feature-Rolling%20Updates-326CE5?style=flat-square&logo=kubernetes&logoColor=white)

> 🚦 **Sign-in Step:** The full application lifecycle — deploy, verify, expose, scale, roll out an update, exec into a pod, and finally clean everything up — all driven through `kubectl`.

### 🧩 Subtask 3.1: Deploy Application to Kubernetes

```bash
# 🚀 Apply deployment configuration
kubectl apply -f app-deployment.yaml

# 🚀 Apply service configuration
kubectl apply -f app-service.yaml

# ✅ Verify deployment status
kubectl get deployments

# 🔍 Check deployment details
kubectl describe deployment k8s-lab-app-deployment
```

### 🧩 Subtask 3.2: Manage and Monitor Pods

```bash
# 📋 List all pods
kubectl get pods

# 📋 Get detailed pod information
kubectl get pods -o wide

# 🔍 Describe a specific pod (replace POD_NAME with actual pod name)
kubectl describe pod <POD_NAME>

# 📜 View pod logs (replace POD_NAME with actual pod name)
kubectl logs <POD_NAME>

# 📋 Get all resources in default namespace
kubectl get all
```

### 🧩 Subtask 3.3: Test Application Accessibility

```bash
# 🌐 Get Minikube IP address
minikube ip

# 📋 Get service information
kubectl get services

# 🔗 Access application using Minikube service command
minikube service k8s-lab-app-service --url

# 🧪 Test application with curl (use the URL from previous command)
curl $(minikube service k8s-lab-app-service --url)
```

### 🧩 Subtask 3.4: Scale Application

```bash
# 📈 Scale deployment to 5 replicas
kubectl scale deployment k8s-lab-app-deployment --replicas=5

# ✅ Verify scaling
kubectl get pods

# 🔍 Check deployment status
kubectl get deployments

# 📉 Scale back to 2 replicas
kubectl scale deployment k8s-lab-app-deployment --replicas=2

# ✅ Verify scaling down
kubectl get pods
```

### 🧩 Subtask 3.5: Update Application

```bash
# 📝 Update the HTML file
cat > index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Kubernetes Lab Application - Updated</title>
</head>
<body>
    <h1>Welcome to Kubernetes Integration Lab - Version 2.0</h1>
    <p>This is an updated version running in Kubernetes!</p>
    <p>Hostname: <span id="hostname"></span></p>
    <script>
        document.getElementById('hostname').textContent = window.location.hostname;
    </script>
</body>
</html>
EOF

# 🔨 Build new version of the image
docker build -t k8s-lab-app:v2.0 .

# ♻️ Update deployment with new image
kubectl set image deployment/k8s-lab-app-deployment k8s-lab-app=k8s-lab-app:v2.0

# 👀 Monitor rollout status
kubectl rollout status deployment/k8s-lab-app-deployment

# ✅ Verify update
curl $(minikube service k8s-lab-app-service --url)
```

### 🧩 Subtask 3.6: Advanced Pod Management

```bash
# 🧑‍💻 Execute commands inside a pod (replace POD_NAME with actual pod name)
kubectl exec -it <POD_NAME> -- /bin/sh

# 📂 Inside the pod, run:
# ls /usr/share/nginx/html/
# cat /usr/share/nginx/html/index.html
# exit

# 🔀 Port forward to access pod directly
kubectl port-forward <POD_NAME> 8080:80 &

# 🧪 Test port forwarding
curl http://localhost:8080

# 🛑 Stop port forwarding
pkill -f "kubectl port-forward"

# 📊 View resource usage
kubectl top nodes
kubectl top pods
```

### 🧩 Subtask 3.7: Troubleshooting and Monitoring

```bash
# 📜 Get events in the cluster
kubectl get events --sort-by=.metadata.creationTimestamp

# 🔍 Check cluster component status
kubectl get componentstatuses

# 🔍 View detailed cluster information
kubectl cluster-info dump

# 📏 Check resource quotas and limits
kubectl describe limitrange
kubectl describe resourcequota

# 📊 Monitor pod resource usage
kubectl top pods --containers
```

### 🧩 Subtask 3.8: Cleanup and Resource Management

```bash
# 🗑️ Delete service
kubectl delete service k8s-lab-app-service

# 🗑️ Delete deployment
kubectl delete deployment k8s-lab-app-deployment

# ✅ Verify cleanup
kubectl get all

# 📋 View remaining resources
kubectl get pods
kubectl get services
kubectl get deployments

# 🛑 Stop Minikube (optional)
minikube stop

# 🗑️ Delete Minikube cluster (optional - only if you want to start fresh)
# minikube delete
```

<!-- TODO: Re-deploy the app and use `kubectl rollout undo` to revert v2.0 back to v1.0 -->

---

## 🩹 Troubleshooting Tips

<details>
<summary>🔴 Issue 1: Minikube fails to start</summary>

```bash
# 🛠️ Solution: Check Docker service and restart Minikube
sudo systemctl status docker
minikube delete
minikube start --driver=docker --force
```

</details>

<details>
<summary>🔴 Issue 2: Pods stuck in Pending state</summary>

```bash
# 🛠️ Solution: Check node resources and events
kubectl describe nodes
kubectl get events
kubectl describe pod <POD_NAME>
```

</details>

<details>
<summary>🔴 Issue 3: Image pull errors</summary>

```bash
# 🛠️ Solution: Ensure you're using Minikube's Docker daemon
eval $(minikube docker-env)
docker images
kubectl describe pod <POD_NAME>
```

</details>

<details>
<summary>🔴 Issue 4: Service not accessible</summary>

```bash
# 🛠️ Solution: Check service configuration and Minikube IP
kubectl get services
minikube ip
kubectl describe service k8s-lab-app-service
```

</details>

---

## 📌 Key Concepts Learned

| Concept | Description |
|---|---|
| **Kubernetes Architecture** | Understanding of master and worker nodes, even in a single-node setup |
| **Pod Management** | Creating, scaling, and monitoring pods using `kubectl` |
| **Deployments** | Managing application deployments and rolling updates |
| **Services** | Exposing applications and managing network access |
| **Container Orchestration** | How Kubernetes manages Docker containers at scale |
| **Resource Management** | Setting resource limits and requests for containers |
| **Troubleshooting** | Using `kubectl` commands to diagnose and resolve issues |

---

## 🏁 Conclusion

In this comprehensive lab, you successfully integrated Docker with Kubernetes using Minikube on a single Linux machine.

### ✅ Key Accomplishments

- ☸️ Installed and configured a local Kubernetes cluster using Minikube
- 🐳 Built Docker images and deployed them to Kubernetes without external registries
- 📝 Created and managed Kubernetes deployments and services using YAML manifests
- 📈 Scaled applications horizontally and performed rolling updates
- 📊 Monitored and troubleshot Kubernetes applications using `kubectl` commands
- 🔗 Understood the relationship between Docker containers and Kubernetes pods

### 🌍 Real-World Applications

This integration of Docker and Kubernetes provides a powerful foundation for container orchestration, enabling you to deploy, scale, and manage containerized applications efficiently. The skills learned in this lab are directly applicable to production Kubernetes environments and form the basis for more advanced container orchestration scenarios.

> 🧭 **Next Steps:** Consider exploring Kubernetes features like ConfigMaps, Secrets, Persistent Volumes, and Ingress controllers to further enhance your container orchestration capabilities.

---

<div align="center">

![Al Nafi](https://img.shields.io/badge/Al%20Nafi-Cybersecurity%20Training-1E3A8A?style=for-the-badge)

</div>
