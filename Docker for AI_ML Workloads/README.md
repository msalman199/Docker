# 🤖 Docker for AI/ML Workloads

<p align="center">
  <img src="https://img.shields.io/badge/Docker-Containerization-2496ED?style=for-the-badge&logo=docker&logoColor=white" alt="Docker">
  <img src="https://img.shields.io/badge/Docker%20Compose-Orchestration-2496ED?style=for-the-badge&logo=docker&logoColor=white" alt="Docker Compose">
  <img src="https://img.shields.io/badge/Python-Machine%20Learning-3776AB?style=for-the-badge&logo=python&logoColor=white" alt="Python">
  <img src="https://img.shields.io/badge/AI%2FML-Workloads-FF6F00?style=for-the-badge&logo=tensorflow&logoColor=white" alt="AI/ML">
  <img src="https://img.shields.io/badge/Linux-Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white" alt="Ubuntu">
</p>

<p align="center">
  <b>🐳 Containerizing Machine Learning Training Pipelines with Docker</b>
</p>

---

## 📌 Overview

This lab demonstrates how to **containerize and orchestrate AI/ML workloads using Docker and Docker Compose**.

The project covers the complete workflow of a containerized machine-learning pipeline:

```text
📊 Data Ingestion
      ↓
🧹 Data Preparation
      ↓
🐳 Dockerized ML Environment
      ↓
🧠 Model Training
      ↓
📈 Model Evaluation
      ↓
💾 Model + Metrics
      ↓
🚀 Docker Compose Workflow
```

The goal is to create **reproducible, self-contained ML environments** where dependencies, training code, artifacts, and workflow execution are consistently managed through containers.

---

# 🎯 Objectives

By completing this lab, you will learn how to:

* 🐳 Build Docker images for Python-based ML workloads
* 🧱 Create production-style multi-stage Docker images
* 🧠 Package complete ML training pipelines inside containers
* 📦 Install ML dependencies during image build time
* ⚙️ Pass hyperparameters through environment variables or CLI arguments
* 💾 Store trained models and metrics using mounted volumes
* 🔁 Achieve reproducible ML training using fixed random seeds
* 🧩 Build multi-container ML workflows using Docker Compose
* 📂 Share datasets between containers using named volumes
* 🔗 Control service startup order with Compose dependencies
* 🩺 Use health checks and successful completion conditions
* ❌ Implement fail-fast behavior when an upstream pipeline stage fails

---

# 🧰 Technology Stack

| Technology          | Purpose                       |
| ------------------- | ----------------------------- |
| 🐳 Docker           | Containerization              |
| 🔗 Docker Compose   | Multi-container orchestration |
| 🐍 Python           | ML application development    |
| 🧠 Machine Learning | Model training and evaluation |
| 🐧 Ubuntu           | Linux environment             |
| 💾 Docker Volumes   | Persistent ML artifacts       |
| 📊 JSON             | Metrics and results storage   |
| 🔄 Random Seeds     | Training reproducibility      |

---

# 📋 Prerequisites

Before starting this lab, you should have:

* Basic Linux command-line knowledge
* Understanding of file permissions
* Familiarity with processes and environment variables
* Basic Python knowledge
* Basic machine-learning concepts
* Understanding of training/test datasets
* Understanding of model evaluation metrics
* Familiarity with Docker fundamentals
* Basic understanding of Docker Compose

---

# ☁️ Lab Environment

The lab uses a dedicated **AWS EC2 Ubuntu instance provided by Al Nafi**.

The base system does not contain the required container tooling, so Docker and Docker Compose must be installed during the lab.

---

# 🏗️ Project Architecture

The final project can be organized as follows:

```text
docker-ai-ml/
│
├── Dockerfile
├── docker-compose.yml
├── requirements.txt
│
├── src/
│   ├── train.py
│   ├── prepare_data.py
│   └── evaluate.py
│
├── output/
│   ├── model.*
│   └── metrics.json
│
└── README.md
```

For the distributed workflow:

```text
                  ┌──────────────────────┐
                  │   Data Preparation   │
                  │       Worker         │
                  └──────────┬───────────┘
                             │
                             ▼
                  ┌──────────────────────┐
                  │   Prepared Dataset   │
                  │    Named Volume      │
                  └──────────┬───────────┘
                             │
                             ▼
                  ┌──────────────────────┐
                  │    Training Worker   │
                  │      ML Model        │
                  └──────────┬───────────┘
                             │
                             ▼
                  ┌──────────────────────┐
                  │    Results Volume    │
                  │     results.json     │
                  └──────────────────────┘
```

---

# 🚀 Task 1: Install and Verify Docker

## 🔹 Step 1: Install Docker Engine and Docker Compose

Update the Ubuntu package index:

```bash
sudo apt-get update
```

Install required packages:

```bash
sudo apt-get install -y ca-certificates curl gnupg lsb-release
```

Create Docker's keyring directory:

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

Add the Docker repository:

```bash
sudo tee /etc/apt/sources.list.d/docker.list <<'EOF'
deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu jammy stable
EOF
```

Update package information:

```bash
sudo apt-get update
```

Install Docker Engine and Compose:

```bash
sudo apt-get install -y \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-compose-plugin
```

---

## 🔐 Configure Docker User Permissions

Add the current user to the Docker group:

```bash
sudo usermod -aG docker "$USER"
```

Apply the group membership:

```bash
newgrp docker
```

---

# 🔍 Step 2: Verify Docker Installation

Check Docker:

```bash
docker version
```

Check Docker Compose:

```bash
docker compose version
```

Run the Docker test container:

```bash
docker run --rm hello-world
```

### ✅ Expected Result

Docker should display:

```text
Hello from Docker!
```

The container should exit successfully with code `0`.

---

# 🛠️ Troubleshooting Docker

### ❌ Malformed Docker Repository Entry

If you receive:

```text
E: Malformed entry 1 in list file
```

Inspect the repository:

```bash
cat /etc/apt/sources.list.d/docker.list
```

The file should contain one unbroken repository line.

If necessary:

```bash
sudo rm /etc/apt/sources.list.d/docker.list
```

Then recreate the repository configuration.

---

### ❌ Docker Permission Denied

If you see:

```text
permission denied while trying to connect to the Docker daemon socket
```

Run:

```bash
groups
```

Confirm that `docker` appears in the group list.

If necessary:

```bash
newgrp docker
```

Or log out and log back in.

---

# 🧠 Task 2: Build a Containerized ML Training Image

## 🎯 Problem Statement

Create a production-style Docker image containing a complete supervised-learning pipeline.

The image should:

* 📦 Include all Python dependencies
* 🧠 Train an ML model
* ⚙️ Accept configurable hyperparameters
* 🔒 Keep dependencies inside the image
* 💾 Save the trained model
* 📊 Generate structured metrics
* 🔁 Support reproducible training
* 🚪 Exit with code `0` on successful training
* ❌ Return a non-zero exit code when training fails

---

# 🐍 ML Application Requirements

The project can use one of the following frameworks:

* Scikit-learn
* TensorFlow
* PyTorch

The dataset may be:

* Synthetic
* Bundled with the project
* Generated during preprocessing

A typical training flow should be:

```text
Input Dataset
     │
     ▼
Preprocessing
     │
     ▼
Train/Test Split
     │
     ▼
Model Training
     │
     ▼
Model Evaluation
     │
     ▼
Model Serialization
     │
     ├──────────────► model.*
     │
     └──────────────► metrics.json
```

---

# 🐳 Multi-Stage Docker Build

A production Dockerfile should separate build dependencies from the final runtime environment.

Example architecture:

```dockerfile
FROM python:3.11-slim AS builder

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir \
    --prefix=/install \
    -r requirements.txt

COPY src/ ./src/


FROM python:3.11-slim AS production

WORKDIR /app

COPY --from=builder /install /usr/local
COPY --from=builder /app/src ./src

RUN useradd --create-home --uid 1001 mluser

USER 1001

CMD ["python", "src/train.py"]
```

### 🔐 Benefits

Multi-stage builds help:

* Reduce final image size
* Remove unnecessary build tools
* Improve security
* Separate build and runtime dependencies
* Create cleaner production images

---

# ⚙️ Hyperparameter Configuration

The training application should support configuration through environment variables or command-line arguments.

Example:

```bash
docker run --rm \
  -e EPOCHS=10 \
  -e LEARNING_RATE=0.001 \
  -e RANDOM_SEED=42 \
  -v "$(pwd)/output:/app/output" \
  ml-training:1.0
```

---

# 💾 ML Output Artifacts

The container must generate artifacts in:

```text
/app/output
```

Expected output:

```text
output/
├── model.*
└── metrics.json
```

Example metrics structure:

```json
{
  "accuracy": 0.94,
  "loss": 0.18,
  "epochs_run": 10,
  "timestamp": "2026-08-02T12:00:00Z"
}
```

---

# 🧪 Test the ML Container

Build the image:

```bash
docker build -t ml-training:1.0 .
```

Create an output directory:

```bash
mkdir -p output
```

Run the training workload:

```bash
docker run --rm \
  -v "$(pwd)/output:/app/output" \
  ml-training:1.0
```

Inspect the generated files:

```bash
ls -lah output
```

Inspect metrics:

```bash
cat output/metrics.json
```

---

# 📏 Image Size Validation

Check the image size:

```bash
docker images ml-training:1.0
```

### Acceptance Criterion

The final image must be:

```text
≤ 4 GB
```

---

# 🔁 Reproducibility Testing

Run the container twice using independent output directories.

```bash
mkdir -p output1 output2
```

First run:

```bash
docker run --rm \
  -e RANDOM_SEED=42 \
  -v "$(pwd)/output1:/app/output" \
  ml-training:1.0
```

Second run:

```bash
docker run --rm \
  -e RANDOM_SEED=42 \
  -v "$(pwd)/output2:/app/output" \
  ml-training:1.0
```

Compare metrics:

```bash
cat output1/metrics.json
cat output2/metrics.json
```

### ✅ Acceptance Criterion

The accuracy or regression metric between the two runs must differ by **no more than 5 percentage points**.

A fixed random seed should be used to improve reproducibility.

---

# 🔗 Task 3: Docker Compose Distributed ML Workflow

## 🎯 Objective

Create a minimum two-service Docker Compose ML pipeline.

Required services:

```text
┌─────────────────────┐
│ data-prep-worker    │
│                     │
│ Prepare Dataset     │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│ prepared-data       │
│ Docker Volume       │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│ training-worker     │
│                     │
│ Train ML Model      │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│ training-results    │
│ Docker Volume       │
└─────────────────────┘
```

---

# 📦 Required Services

## 🧹 Data Preparation Worker

Responsibilities:

* Load or generate dataset
* Clean/preprocess data
* Write processed data
* Store output in a named Docker volume

Example:

```text
/prepared-data/train.csv
```

---

## 🧠 Training Worker

Responsibilities:

* Wait for data preparation
* Read prepared dataset
* Train the model
* Evaluate the model
* Write results to a second volume

Example:

```text
/results/results.json
```

---

# 🗄️ Docker Named Volumes

The Compose deployment should use two named volumes:

```yaml
volumes:
  prepared-data:
  training-results:
```

The volumes provide controlled data flow between pipeline stages.

---

# 🔄 Service Dependency

The training worker must not start before the preparation worker successfully completes.

Example Compose pattern:

```yaml
services:

  data-prep-worker:
    build:
      context: .
      dockerfile: Dockerfile.prep
    volumes:
      - prepared-data:/prepared-data

  training-worker:
    build:
      context: .
      dockerfile: Dockerfile.train
    volumes:
      - prepared-data:/prepared-data:ro
      - training-results:/results
    depends_on:
      data-prep-worker:
        condition: service_completed_successfully

volumes:
  prepared-data:
  training-results:
```

This creates the following dependency:

```text
data-prep-worker
       │
       │ successful completion
       ▼
training-worker
```

---

# ▶️ Start the Compose Workflow

Run:

```bash
docker compose up --abort-on-container-exit
```

Check the services:

```bash
docker compose ps -a
```

View logs:

```bash
docker compose logs
```

---

# 📊 Verify Training Results

Inspect the training results:

```bash
docker compose run training-worker cat /results/results.json
```

Expected structure:

```json
{
  "model_accuracy": 0.94,
  "data_source": "/prepared-data/train.csv"
}
```

---

# 🧪 Failure Testing

The pipeline must fail safely when the preparation stage fails.

For example, intentionally configure the preparation worker to use a nonexistent script.

Then run:

```bash
docker compose up --abort-on-container-exit
```

Check:

```bash
docker compose ps -a
```

### ✅ Expected Behavior

```text
data-prep-worker → FAILED
       │
       X
       │
training-worker → NOT STARTED
```

This demonstrates that the dependency contract is working correctly.

---

# 🩺 Troubleshooting

## ❌ Docker Permission Error

Check:

```bash
groups
```

Add the user:

```bash
sudo usermod -aG docker "$USER"
```

Then:

```bash
newgrp docker
```

---

## ❌ Compose Command Not Found

Check:

```bash
docker compose version
```

If unavailable, install the Docker Compose plugin:

```bash
sudo apt-get install -y docker-compose-plugin
```

---

## ❌ Training Worker Starts Too Early

Check the Compose dependency:

```yaml
depends_on:
  data-prep-worker:
    condition: service_completed_successfully
```

Then recreate the stack:

```bash
docker compose down -v
docker compose up --abort-on-container-exit
```

---

## ❌ Missing Dataset

Check the preparation volume:

```bash
docker volume ls
```

Inspect Compose configuration:

```bash
docker compose config
```

Review preparation logs:

```bash
docker compose logs data-prep-worker
```

---

## ❌ Missing Results

Check:

```bash
docker compose logs training-worker
```

Verify the results volume:

```bash
docker volume ls
```

Then inspect:

```bash
docker compose run training-worker ls -lah /results
```

---

# 📋 Acceptance Criteria

## 🐳 ML Image

| Requirement         | Expected                        |
| ------------------- | ------------------------------- |
| Docker build        | Successful                      |
| Dependencies        | Installed at build time         |
| Model artifact      | Generated                       |
| `metrics.json`      | Generated                       |
| Accuracy/loss       | Present                         |
| Epoch count         | Present                         |
| Timestamp           | Present                         |
| Image size          | ≤ 4 GB                          |
| Reproducibility     | ≤ 5 percentage-point difference |
| Successful training | Exit code 0                     |

---

## 🔗 Docker Compose

| Requirement                         | Expected     |
| ----------------------------------- | ------------ |
| Minimum services                    | 2            |
| Data preparation                    | Successful   |
| Training worker                     | Successful   |
| Shared dataset                      | Named volume |
| Results storage                     | Named volume |
| Startup dependency                  | Enforced     |
| `results.json`                      | Generated    |
| Failure propagation                 | Working      |
| Training blocked after prep failure | Yes          |

---

# 🔐 Production Considerations

For real-world AI/ML workloads, consider adding:

* 🔒 Non-root containers
* 🛡️ Read-only filesystems where possible
* 🔑 Docker secrets for credentials
* 📦 Pinned Python dependency versions
* 🧾 Image vulnerability scanning
* 📊 Centralized logging
* 🔍 Container monitoring
* 🧪 Automated testing
* 🔐 Image signing and verification
* 🏷️ Immutable image tags
* 💾 External artifact storage
* ⚙️ GPU-enabled container runtimes for accelerated workloads

---

# 🧹 Cleanup

Stop the Compose application:

```bash
docker compose down
```

Remove volumes:

```bash
docker compose down -v
```

Remove unused Docker resources:

```bash
docker system prune -f
```

List images:

```bash
docker images
```

---

# 📚 Learning Outcomes

After completing this lab, you should understand how to:

✅ Package ML dependencies inside Docker images

✅ Build production-oriented multi-stage Docker images

✅ Execute reproducible ML training workloads

✅ Persist trained models and metrics outside containers

✅ Design distributed ML workflows using Docker Compose

✅ Share datasets between independent containers

✅ Control workflow execution order

✅ Implement failure-aware ML pipelines

✅ Use Docker volumes for ML artifacts

✅ Separate data preparation and model-training responsibilities

---

# 🎯 Expected Outcomes

At the end of the lab, you should have:

### 1️⃣ A Versioned ML Docker Image

```text
ml-training:1.0
```

The image contains everything required to execute the training pipeline without manual dependency installation.

### 2️⃣ Reproducible ML Results

```text
output/
├── model.*
└── metrics.json
```

### 3️⃣ A Distributed Compose Pipeline

```text
Data Preparation
       ↓
Prepared Dataset
       ↓
Model Training
       ↓
Evaluation Results
```

### 4️⃣ Fail-Fast Pipeline Behavior

If data preparation fails:

```text
❌ Data Preparation
       ↓
🚫 Training Blocked
```

---

# 🏆 Conclusion

This lab demonstrates how Docker can provide a **reproducible and portable foundation for AI/ML workloads**.

By packaging Python dependencies, training code, model artifacts, and configuration inside immutable container images, environment drift between development and production can be significantly reduced.

Docker Compose extends this approach by allowing ML workflows to be divided into independent services such as data preparation and model training. Named volumes provide controlled data exchange, while dependency conditions ensure that downstream workloads only execute after upstream stages complete successfully.

The resulting architecture provides an operational foundation for larger cloud-native ML systems:

```text
🐍 Python ML
     +
🐳 Docker
     +
🔗 Docker Compose
     +
💾 Persistent Volumes
     +
🔁 Reproducible Training
     ↓
🚀 Containerized ML Workflows
```

These practices are valuable for building portable, repeatable, and maintainable machine-learning pipelines across development, testing, and production environments.

---

## ⭐ Skills Demonstrated

```text
Docker Containerization
Docker Compose
Python
Machine Learning
ML Model Training
Multi-Stage Docker Builds
Docker Volumes
Data Pipelines
Model Serialization
Reproducibility
Container Orchestration
AI/ML Workload Deployment
Linux Administration
```

---

<p align="center">
  <b>🚀 Learn • Build • Containerize • Automate • Deploy 🚀</b>
</p>

<p align="center">
  🐳 <b>Docker for AI/ML Workloads</b> 🤖
</p>
