<div align="center">

# 🧱 Docker Compose Basics

### A Hands-On Al Nafi Lab for Multi-Container Application Orchestration

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Docker Compose](https://img.shields.io/badge/Docker%20Compose-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![Flask](https://img.shields.io/badge/Flask-000000?style=for-the-badge&logo=flask&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![Nginx](https://img.shields.io/badge/Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white)
![phpMyAdmin](https://img.shields.io/badge/phpMyAdmin-6C78AF?style=for-the-badge&logo=phpmyadmin&logoColor=white)

**Difficulty:** Beginner–Intermediate • **Estimated Time:** 90–120 minutes

</div>

---

## 📖 Table of Contents

- [🎯 Lab Objectives](#-lab-objectives)
- [✅ Prerequisites](#-prerequisites)
- [🖥️ Lab Environment](#️-lab-environment)
- [🛠️ Task 1: Install Docker and Docker Compose](#️-task-1-install-docker-and-docker-compose)
- [🧩 Task 2: Create a Multi-Container Application with Docker Compose](#-task-2-create-a-multi-container-application-with-docker-compose)
- [🚀 Task 3: Start and Scale the Application with Docker Compose](#-task-3-start-and-scale-the-application-with-docker-compose)
- [🩹 Troubleshooting Common Issues](#-troubleshooting-common-issues)
- [🧹 Cleanup](#-cleanup)
- [📌 Key Concepts](#-key-concepts)
- [🏁 Conclusion](#-conclusion)

---

## 🎯 Lab Objectives

By the end of this lab, students will be able to:

| # | Objective |
|---|-----------|
| 1 | Understand the purpose and benefits of Docker Compose for multi-container applications |
| 2 | Install Docker Compose on a Linux system |
| 3 | Create and configure a `docker-compose.yml` file for orchestrating multiple containers |
| 4 | Use Docker Compose commands to manage multi-container applications |
| 5 | Scale services using Docker Compose |
| 6 | Understand service networking and volume management in Docker Compose |
| 7 | Troubleshoot common Docker Compose issues |

## ✅ Prerequisites

Before starting this lab, students should have:

- ✔️ Basic understanding of Linux command line operations
- ✔️ Familiarity with Docker containers and basic Docker commands
- ✔️ Knowledge of YAML file format and syntax
- ✔️ Understanding of web applications and databases
- ✔️ Basic networking concepts (ports, IP addresses)

## 🖥️ Lab Environment

> **☁️ Note:** Al Nafi provides Linux-based cloud machines for this lab. Simply click **Start Lab** to access your dedicated Linux machine. The provided machine is bare metal with no pre-installed tools — you will install Docker and Docker Compose during this lab.

> ⚠️ **Important:** All tasks in this lab are performed on a single Linux machine. No additional machines or remote hosts are required.

---

## 🛠️ Task 1: Install Docker and Docker Compose

![Task Stack](https://img.shields.io/badge/Stack-Docker%20Engine-2496ED?style=flat-square&logo=docker&logoColor=white) ![Task Stack](https://img.shields.io/badge/Stack-Ubuntu-E95420?style=flat-square&logo=ubuntu&logoColor=white)

> 🚦 **Sign-in Step:** Getting the Docker Engine and the Compose CLI plugin both installed and permission-configured — the two tools everything else in this lab depends on.

### 🧩 Subtask 1.1: Update System Packages

```bash
# 🔄 Ensure your system packages are up to date
sudo apt update
sudo apt upgrade -y
```

### 🧩 Subtask 1.2: Install Docker

```bash
# 📦 Install required packages
sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release

# 🔑 Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# ➕ Add Docker repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 🔄 Update package index
sudo apt update

# 🐳 Install Docker Engine
sudo apt install -y docker-ce docker-ce-cli containerd.io
```

### 🧩 Subtask 1.3: Configure Docker Permissions

```bash
# 👤 Add your user to the docker group to run Docker commands without sudo
sudo usermod -aG docker $USER
newgrp docker
```

```bash
# ✅ Verify Docker installation
docker --version
docker run hello-world
```

### 🧩 Subtask 1.4: Install Docker Compose

```bash
# ⬇️ Download Docker Compose binary
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# 🔓 Make it executable
sudo chmod +x /usr/local/bin/docker-compose

# 🔗 Create symbolic link for easier access
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
```

```bash
# ✅ Verify Docker Compose installation
docker-compose --version
```

<!-- TODO: Confirm both `docker --version` and `docker-compose --version` print without needing sudo -->

---

## 🧩 Task 2: Create a Multi-Container Application with Docker Compose

![Task Stack](https://img.shields.io/badge/Backend-Flask-000000?style=flat-square&logo=flask&logoColor=white) ![Task Stack](https://img.shields.io/badge/Database-MySQL-4479A1?style=flat-square&logo=mysql&logoColor=white) ![Task Stack](https://img.shields.io/badge/Admin-phpMyAdmin-6C78AF?style=flat-square&logo=phpmyadmin&logoColor=white)

> 🚦 **Sign-in Step:** Wiring up a three-service stack — a Flask web app, a MySQL database with an init script, and a phpMyAdmin panel — all declared in a single `docker-compose.yml`.

### 🧩 Subtask 2.1: Create Project Directory Structure

```bash
# 📁 Create a directory structure for your multi-container application
mkdir ~/webapp-project
cd ~/webapp-project
mkdir app
mkdir database-init
```

### 🧩 Subtask 2.2: Create a Simple Web Application

```python
# 🐍 app/app.py — simple Python Flask web application
cat > app/app.py << 'EOF'
from flask import Flask, render_template_string
import mysql.connector
import os
import time

app = Flask(__name__)

def get_db_connection():
    max_retries = 5
    retry_count = 0

    while retry_count < max_retries:
        try:
            connection = mysql.connector.connect(
                host=os.environ.get('DB_HOST', 'db'),
                user=os.environ.get('DB_USER', 'webapp'),
                password=os.environ.get('DB_PASSWORD', 'webapp123'),
                database=os.environ.get('DB_NAME', 'webapp_db')
            )
            return connection
        except mysql.connector.Error as err:
            retry_count += 1
            print(f"Database connection attempt {retry_count} failed: {err}")
            if retry_count < max_retries:
                time.sleep(5)
            else:
                raise

@app.route('/')
def home():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT COUNT(*) FROM visits")
        visit_count = cursor.fetchone()[0]

        cursor.execute("INSERT INTO visits (timestamp) VALUES (NOW())")
        conn.commit()

        cursor.close()
        conn.close()

        return render_template_string('''
        <html>
            <head><title>Docker Compose Web App</title></head>
            <body>
                <h1>Welcome to Docker Compose Lab!</h1>
                <p>This page has been visited {{ count }} times.</p>
                <p>Application is running in a Docker container managed by Docker Compose.</p>
            </body>
        </html>
        ''', count=visit_count + 1)
    except Exception as e:
        return f"Database connection error: {str(e)}"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
EOF
```

### 🧩 Subtask 2.3: Create Requirements File

```bash
# 📋 Create a requirements file for the Python application
cat > app/requirements.txt << 'EOF'
Flask==2.3.3
mysql-connector-python==8.1.0
EOF
```

### 🧩 Subtask 2.4: Create Dockerfile for Web Application

```dockerfile
# 🐳 app/Dockerfile
cat > app/Dockerfile << 'EOF'
FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

EXPOSE 5000

CMD ["python", "app.py"]
EOF
```

### 🧩 Subtask 2.5: Create Database Initialization Script

```sql
-- 🗄️ database-init/init.sql
cat > database-init/init.sql << 'EOF'
CREATE DATABASE IF NOT EXISTS webapp_db;
USE webapp_db;

CREATE TABLE IF NOT EXISTS visits (
    id INT AUTO_INCREMENT PRIMARY KEY,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE USER IF NOT EXISTS 'webapp'@'%' IDENTIFIED BY 'webapp123';
GRANT ALL PRIVILEGES ON webapp_db.* TO 'webapp'@'%';
FLUSH PRIVILEGES;
EOF
```

### 🧩 Subtask 2.6: Create Docker Compose Configuration

```yaml
# 🧱 docker-compose.yml — web + db + phpmyadmin
cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  web:
    build: ./app
    ports:
      - "8080:5000"
    environment:
      - DB_HOST=db
      - DB_USER=webapp
      - DB_PASSWORD=webapp123
      - DB_NAME=webapp_db
    depends_on:
      - db
    restart: unless-stopped
    networks:
      - webapp-network

  db:
    image: mysql:8.0
    environment:
      - MYSQL_ROOT_PASSWORD=rootpassword123
      - MYSQL_DATABASE=webapp_db
      - MYSQL_USER=webapp
      - MYSQL_PASSWORD=webapp123
    volumes:
      - db-data:/var/lib/mysql
      - ./database-init:/docker-entrypoint-initdb.d
    ports:
      - "3306:3306"
    restart: unless-stopped
    networks:
      - webapp-network

  phpmyadmin:
    image: phpmyadmin/phpmyadmin:latest
    environment:
      - PMA_HOST=db
      - PMA_USER=root
      - PMA_PASSWORD=rootpassword123
    ports:
      - "8081:80"
    depends_on:
      - db
    restart: unless-stopped
    networks:
      - webapp-network

volumes:
  db-data:

networks:
  webapp-network:
    driver: bridge
EOF
```

<!-- TODO: Add a fourth service (e.g. Redis) and wire it into the webapp-network -->

---

## 🚀 Task 3: Start and Scale the Application with Docker Compose

![Task Stack](https://img.shields.io/badge/Tool-docker--compose-2496ED?style=flat-square&logo=docker&logoColor=white) ![Task Stack](https://img.shields.io/badge/Load%20Balancer-Nginx-009639?style=flat-square&logo=nginx&logoColor=white)

> 🚦 **Sign-in Step:** Bringing the stack up, proving it works, then scaling the web service to three replicas behind an Nginx load balancer — the full lifecycle of a Compose deployment.

### 🧩 Subtask 3.1: Validate Docker Compose Configuration

```bash
# ✅ Parse and validate docker-compose.yml before starting anything
docker-compose config
```

> 📝 This command parses the `docker-compose.yml` file and displays the resolved configuration, helping identify any syntax errors.

### 🧩 Subtask 3.2: Build and Start the Multi-Container Application

```bash
# 🚀 Build and start all services
docker-compose up --build -d
```

> 📝 The `--build` flag ensures custom images are built, and `-d` runs the containers in detached mode.

### 🧩 Subtask 3.3: Verify Running Services

```bash
# 📋 View running containers
docker-compose ps

# 📜 View logs from all services
docker-compose logs

# 📜 View logs from a specific service
docker-compose logs web
docker-compose logs db
```

### 🧩 Subtask 3.4: Test the Web Application

```bash
# 🌐 Test using curl
curl http://localhost:8080

# 🔎 Check if the database connection is working
curl -I http://localhost:8080
```

> 🖥️ You can also access the application using a web browser if available:
> - **Web Application:** http://localhost:8080
> - **phpMyAdmin:** http://localhost:8081

### 🧩 Subtask 3.5: Scale the Web Service

```bash
# 📈 Scale the web service to 3 instances
docker-compose up --scale web=3 -d

# ✅ Verify the scaled services
docker-compose ps
```

> ⚠️ **Note:** When scaling, remove the ports mapping from the web service in `docker-compose.yml` or use a load balancer, since multiple containers cannot bind to the same host port.

### 🧩 Subtask 3.6: Create a Load Balancer Configuration

```yaml
# ⚖️ docker-compose-scaled.yml — adds an Nginx front end, drops web's direct port mapping
cat > docker-compose-scaled.yml << 'EOF'
version: '3.8'

services:
  nginx:
    image: nginx:alpine
    ports:
      - "8080:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
    depends_on:
      - web
    networks:
      - webapp-network

  web:
    build: ./app
    environment:
      - DB_HOST=db
      - DB_USER=webapp
      - DB_PASSWORD=webapp123
      - DB_NAME=webapp_db
    depends_on:
      - db
    restart: unless-stopped
    networks:
      - webapp-network

  db:
    image: mysql:8.0
    environment:
      - MYSQL_ROOT_PASSWORD=rootpassword123
      - MYSQL_DATABASE=webapp_db
      - MYSQL_USER=webapp
      - MYSQL_PASSWORD=webapp123
    volumes:
      - db-data:/var/lib/mysql
      - ./database-init:/docker-entrypoint-initdb.d
    ports:
      - "3306:3306"
    restart: unless-stopped
    networks:
      - webapp-network

  phpmyadmin:
    image: phpmyadmin/phpmyadmin:latest
    environment:
      - PMA_HOST=db
      - PMA_USER=root
      - PMA_PASSWORD=rootpassword123
    ports:
      - "8081:80"
    depends_on:
      - db
    restart: unless-stopped
    networks:
      - webapp-network

volumes:
  db-data:

networks:
  webapp-network:
    driver: bridge
EOF
```

```nginx
# 🧭 nginx.conf — round-robin proxy to the scaled web service
cat > nginx.conf << 'EOF'
events {
    worker_connections 1024;
}

http {
    upstream web_servers {
        server web:5000;
    }

    server {
        listen 80;

        location / {
            proxy_pass http://web_servers;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }
    }
}
EOF
```

### 🧩 Subtask 3.7: Deploy Scaled Application with Load Balancer

```bash
# 🛑 Stop current application
docker-compose down

# 🚀 Start scaled application with load balancer
docker-compose -f docker-compose-scaled.yml up --build --scale web=3 -d

# ✅ Verify the deployment
docker-compose -f docker-compose-scaled.yml ps
```

### 🧩 Subtask 3.8: Monitor and Manage Services

```bash
# 👀 View real-time logs
docker-compose -f docker-compose-scaled.yml logs -f

# 🧑‍💻 Execute commands in running containers
docker-compose -f docker-compose-scaled.yml exec web ls -la

# ♻️ Restart a specific service
docker-compose -f docker-compose-scaled.yml restart web

# 🛑 Stop specific service
docker-compose -f docker-compose-scaled.yml stop web

# ▶️ Start specific service
docker-compose -f docker-compose-scaled.yml start web
```

### 🧩 Subtask 3.9: Test Load Balancing

```bash
# 🔁 Make multiple requests to see load balancing in action
for i in {1..10}; do
    echo "Request $i:"
    curl -s http://localhost:8080 | grep -o "visited [0-9]* times"
    sleep 1
done
```

### 🧩 Subtask 3.10: Inspect Docker Compose Resources

```bash
# 🌐 List networks created by Docker Compose
docker network ls | grep webapp

# 🔍 Inspect the network
docker network inspect webapp-project_webapp-network

# 💾 List volumes created by Docker Compose
docker volume ls | grep webapp

# 🔍 Inspect the volume
docker volume inspect webapp-project_db-data
```

<!-- TODO: Scale web to 5 instances instead of 3 and confirm all 5 appear behind the Nginx upstream -->

---

## 🩹 Troubleshooting Common Issues

<details>
<summary>🔴 Issue 1: Port Already in Use</summary>

If you encounter port binding errors:

```bash
# 🔎 Check what's using the port
sudo netstat -tulpn | grep :8080

# 🛠️ Stop conflicting services or change ports in docker-compose.yml
```

</details>

<details>
<summary>🔴 Issue 2: Database Connection Errors</summary>

If the web application cannot connect to the database:

```bash
# 📜 Check database logs
docker-compose logs db

# ✅ Verify database is ready
docker-compose exec db mysql -u root -p -e "SHOW DATABASES;"
```

</details>

<details>
<summary>🔴 Issue 3: Build Failures</summary>

If Docker build fails:

```bash
# 🧹 Clean up and rebuild
docker-compose down --rmi all --volumes
docker-compose build --no-cache
docker-compose up -d
```

</details>

<details>
<summary>🔴 Issue 4: Service Dependencies</summary>

If services start in the wrong order:

```yaml
# 🩺 Use healthchecks in docker-compose.yml
# Add depends_on with condition: service_healthy
```

</details>

---

## 🧹 Cleanup

```bash
# 🛑 Stop and remove all containers, networks, and volumes
docker-compose -f docker-compose-scaled.yml down --volumes --rmi all

# 🗑️ Remove any remaining containers
docker container prune -f

# 🌐 Remove unused networks
docker network prune -f

# 💾 Remove unused volumes
docker volume prune -f
```

---

## 📌 Key Concepts

| Concept | Purpose |
|---|---|
| Service Definition | Declaring multiple containers as one stack in a single `docker-compose.yml` |
| `depends_on` | Controlling service startup order (not readiness — pair with healthchecks) |
| Networking | Isolated bridge networks enabling service-name DNS between containers |
| Volume Management | Persistent data storage (`db-data`) surviving container restarts |
| Scaling | `--scale web=3` for horizontal scaling of a single service |
| Load Balancing | Nginx `upstream` block distributing requests across scaled replicas |
| `docker-compose config` | Validating YAML syntax before deployment |

---

## 🏁 Conclusion

In this lab, you learned the fundamentals of Docker Compose for managing multi-container applications.

### ✅ Technical Skills Gained

- 🐳 Installed Docker and Docker Compose on a Linux system
- 🧱 Created a comprehensive `docker-compose.yml` configuration file
- 🚀 Built and deployed a multi-container application with web, database, and admin services
- ⚖️ Implemented service scaling and load balancing using Docker Compose
- 🧑‍💻 Learned essential Docker Compose commands for application lifecycle management

### 🌍 Practical Applications

- 🖥️ **Development Environment** — Docker Compose simplifies setting up consistent development environments across teams
- 🧩 **Microservices Architecture** — enables easy orchestration of multiple interconnected services
- 🧪 **Testing and CI/CD** — provides reproducible environments for automated testing and deployment pipelines
- 🏭 **Production Deployment** — offers a foundation for container orchestration in smaller production environments

### 📌 Key Concepts Mastered

- **Service Definition** — understanding how to define and configure multiple services in a single file
- **Networking** — creating isolated networks for service communication
- **Volume Management** — implementing persistent data storage across container restarts
- **Scaling** — horizontally scaling services to handle increased load
- **Dependencies** — managing service startup order and dependencies

This knowledge forms the foundation for more advanced container orchestration platforms like Kubernetes and provides essential skills for modern application deployment and DevOps practices. Docker Compose is particularly valuable for local development, testing environments, and smaller production deployments where full Kubernetes complexity may not be necessary.

The multi-container application built in this lab demonstrates real-world patterns used in modern web applications, including separation of concerns, service isolation, and scalable architecture design.

---

<div align="center">

![Al Nafi](https://img.shields.io/badge/Al%20Nafi-Cybersecurity%20Training-1E3A8A?style=for-the-badge)

</div>
