# deployment-guide.md

# Deployment Guide

## Project Overview

This project implements a complete CI/CD pipeline for deploying the Java-based VProfile application to a Kubernetes cluster created using KOPS on AWS.

The deployment pipeline performs the following:

1. Checkout source code from GitHub
2. Build Maven application
3. Run Unit Tests
4. Run Integration Tests
5. Perform Checkstyle Analysis
6. Perform SonarQube Analysis
7. Build Docker Image
8. Push Docker Image to DockerHub
9. Remove Local Docker Images
10. Deploy latest image to Kubernetes using Helm

---

# Architecture

```
GitHub Repository
        │
        ▼
Jenkins Pipeline
        │
        ├── Maven Build
        ├── Unit Test
        ├── Integration Test
        ├── Checkstyle
        ├── SonarQube
        ├── Docker Build
        ├── Docker Push
        ▼
DockerHub
        │
        ▼
KOPS Kubernetes Cluster
        │
        ▼
Helm Upgrade
        │
        ▼
Running Pods
```

---

# Infrastructure Used

## AWS

- EC2 (Jenkins Server)
- EC2 (SonarQube Server)
- EC2 (KOPS Master)
- EC2 Worker Nodes
- Route53 / GoDaddy DNS
- Security Groups
- IAM Roles

---

## DevOps Tools

- Git
- GitHub
- Jenkins
- Maven
- Docker
- DockerHub
- SonarQube
- Helm
- Kubernetes
- KOPS

---

# Jenkins Configuration

## Required Plugins

- Pipeline
- Git
- Docker Pipeline
- Docker
- SSH Agent
- SSH Build Agents
- SonarQube Scanner
- Maven Integration
- Pipeline Utility Steps

---

## Global Tools

### JDK

```
Java 21
```

---

### Maven

```
MAVEN3.9.9
```

---

### Sonar Scanner

```
mysonarscanner4
```

---

## SonarQube Server

```
sonar-pro
```

---

## DockerHub Credentials

```
Credential Type:
Username with Password

ID:
dockerhub
```

---

## SSH Credentials

```
kops-login
```

Used for Jenkins Agent connection.

---

# Jenkins Agent Configuration

Agent Name

```
kops
```

Label

```
KOPS
```

Remote Directory

```
/opt/jenkins-slave
```

Launch Method

```
Launch Agents via SSH
```

Java Version

```
OpenJDK 21
```

---

# Kubernetes Cluster

Validation

```
kops validate cluster
```

Expected Output

```
Cluster is ready
```

---

# Install Helm

```
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
```

Verify

```
helm version
```

---

# Clone Repository

```
git clone https://github.com/Sar-py-05/cicd-kube-docker.git

cd cicd-kube-docker
```

---

# Maven Build

```
mvn clean install
```

Artifacts

```
target/vprofile-v2.war
```

---

# Run Unit Tests

```
mvn test
```

---

# Run Integration Tests

```
mvn verify
```

---

# Run Checkstyle

```
mvn checkstyle:checkstyle
```

Output

```
target/checkstyle-result.xml
```

---

# Run SonarQube Scan

```
sonar-scanner \
-Dsonar.projectKey=vprofile \
-Dsonar.projectName=vprofile-repo \
-Dsonar.sources=src \
-Dsonar.java.binaries=target/classes
```

For this training project:

Quality Gate is executed for reporting purposes only.

Pipeline continues even if the Quality Gate status is ERROR.

---

# Docker Image Build

```
docker build -t aroy0509/vprofileapp:V${BUILD_NUMBER} .
```

Verify

```
docker images
```

---

# Push Image to DockerHub

```
docker push aroy0509/vprofileapp:V${BUILD_NUMBER}

docker push aroy0509/vprofileapp:latest
```

Verify

```
https://hub.docker.com/r/aroy0509/vprofileapp
```

---

# Remove Local Docker Images

```
docker rmi aroy0509/vprofileapp:V${BUILD_NUMBER}

docker rmi aroy0509/vprofileapp:latest
```

---

# Kubernetes Deployment

Deployment performed using Helm.

Command

```
helm upgrade --install vprofile-stack \
helm/vprofilecharts \
--namespace prod \
--create-namespace \
--set appimage=aroy0509/vprofileapp:V${BUILD_NUMBER}
```

---

# Verify Deployment

Check Helm Releases

```
helm list -A
```

Expected

```
vprofile-stack
```

---

Check Pods

```
kubectl get pods -n prod
```

---

Check Services

```
kubectl get svc -n prod
```

---

Check Deployments

```
kubectl get deploy -n prod
```

---

Check ReplicaSets

```
kubectl get rs -n prod
```

---

Describe Deployment

```
kubectl describe deployment vprofile-vproapp -n prod
```

---

View Logs

```
kubectl logs <pod-name> -n prod
```

---

Rollout Status

```
kubectl rollout status deployment vprofile-vproapp -n prod
```

---

Restart Deployment

```
kubectl rollout restart deployment vprofile-vproapp -n prod
```

---

Rollback Deployment

```
helm rollback vprofile-stack 1 -n prod
```

---

Upgrade Deployment

```
helm upgrade vprofile-stack \
helm/vprofilecharts \
--namespace prod \
--set appimage=aroy0509/vprofileapp:latest
```

---

# Jenkins Pipeline Flow

```
GitHub Commit
      │
      ▼
Checkout
      │
      ▼
Maven Build
      │
      ▼
Unit Test
      │
      ▼
Integration Test
      │
      ▼
Checkstyle
      │
      ▼
SonarQube Analysis
      │
      ▼
Docker Build
      │
      ▼
DockerHub Push
      │
      ▼
Cleanup Images
      │
      ▼
Deploy via Helm
      │
      ▼
Production Namespace
```

---

# Validation Checklist

✅ GitHub repository accessible

✅ Jenkins pipeline configured

✅ Maven installed

✅ Docker installed

✅ DockerHub credentials configured

✅ SonarQube reachable

✅ Jenkins agent online

✅ Java 21 installed on Jenkins Agent

✅ KOPS cluster healthy

✅ kubectl configured

✅ Helm installed

✅ Docker image successfully pushed

✅ Helm deployment successful

✅ Pods Running

✅ Services Available

---

# Expected Successful Pipeline

```
Git Checkout
        ✔

Build
        ✔

Unit Tests
        ✔

Integration Tests
        ✔

Checkstyle
        ✔

SonarQube Analysis
        ✔

Docker Build
        ✔

Docker Push
        ✔

Docker Cleanup
        ✔

Helm Upgrade
        ✔

Pipeline SUCCESS
```

---

# Deployment Outcome

At the completion of a successful Jenkins pipeline:

- Maven application is compiled and packaged.
- Unit and integration tests are executed.
- Static code analysis is completed using Checkstyle and SonarQube.
- A versioned Docker image and `latest` tag are pushed to DockerHub.
- Temporary local Docker images are removed from the Jenkins server.
- Helm upgrades (or installs) the application in the Kubernetes `prod` namespace.
- Kubernetes performs a rolling update with the new application image.
- The deployment is verified through Helm, kubectl, and Jenkins logs.

This deployment process provides a fully automated CI/CD workflow for containerized Java applications running on a KOPS-managed Kubernetes cluster in AWS.
