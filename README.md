# 🚀 End-to-End CI/CD Pipeline on Kubernetes using Jenkins, SonarQube, Docker, Helm & kOps

## 📌 Project Overview

This project demonstrates a complete Production-Style Continuous Integration and Continuous Deployment (CI/CD) pipeline for a Java-based web application deployed on a Kubernetes cluster running on AWS using **kOps**.

The objective of this project was to automate the entire software delivery lifecycle starting from source code commit to Kubernetes deployment while incorporating industry-standard DevOps tools.

The pipeline performs:

- Source Code Checkout from GitHub
- Maven Build
- Unit Testing
- Integration Testing
- Static Code Analysis using Checkstyle
- Code Quality Analysis using SonarQube
- Docker Image Build
- Push Docker Image to DockerHub
- Kubernetes Deployment using Helm
- Automated Deployment through Jenkins Pipeline

This project follows a real-world DevOps workflow and includes several production-like troubleshooting scenarios encountered during implementation.

---

# Project Architecture

```
                    +--------------------+
                    |     Developer      |
                    +---------+----------+
                              |
                              |
                       Git Push to GitHub
                              |
                              ▼
                    +--------------------+
                    |      GitHub        |
                    +---------+----------+
                              |
                       Jenkins Webhook /
                        Poll SCM Trigger
                              |
                              ▼
                    +--------------------+
                    |      Jenkins       |
                    |   CI/CD Pipeline   |
                    +---------+----------+
                              |
      ---------------------------------------------------------
      |            |            |            |                 |
      ▼            ▼            ▼            ▼                 ▼

 Maven Build   Unit Test   Checkstyle   SonarQube      Docker Build
                                              |
                                              ▼
                                      Quality Analysis
                                              |
                                              ▼
                                   Docker Image Created
                                              |
                                              ▼
                                      Push to DockerHub
                                              |
                                              ▼
                                Jenkins SSH Agent (KOPS)
                                              |
                                              ▼
                                   Helm Upgrade/Install
                                              |
                                              ▼
                               Kubernetes Cluster (kOps)
                                              |
                                              ▼
                              vProfile Application Running
```

---

# Technology Stack

| Category | Technologies |
|----------|--------------|
| Cloud | AWS EC2 |
| Container | Docker |
| Container Registry | DockerHub |
| CI/CD | Jenkins |
| Build Tool | Maven 3.9.9 |
| Programming Language | Java |
| Code Quality | Checkstyle |
| Code Analysis | SonarQube Community Edition |
| Container Orchestration | Kubernetes |
| Kubernetes Provisioning | kOps |
| Package Manager | Helm |
| SCM | Git & GitHub |
| Operating System | Ubuntu 24.04 LTS |
| JDK | OpenJDK 21 |

---

# AWS Infrastructure

## Jenkins Server

- Ubuntu 24.04
- Jenkins
- Docker
- Maven
- Sonar Scanner
- AWS CLI
- Ansible

Responsible for:

- Building Application
- Running Tests
- SonarQube Analysis
- Docker Build
- Docker Push
- Triggering Kubernetes Deployment

---

## SonarQube Server

Installed separately on AWS EC2.

Responsible for:

- Static Code Analysis
- Code Quality
- Bugs
- Vulnerabilities
- Code Smells

---

## Kubernetes (kOps) Server

Configured using kOps.

Contains:

- Control Plane
- Worker Nodes
- Helm
- kubectl

Responsible for:

- Application Deployment
- Service Exposure
- Rolling Updates

---

# CI/CD Pipeline Workflow

## Stage 1

Checkout Source Code

↓

## Stage 2

Maven Clean Install

```
mvn clean install
```

↓

## Stage 3

Unit Tests

```
mvn test
```

↓

## Stage 4

Integration Tests

```
mvn verify
```

↓

## Stage 5

Checkstyle Analysis

```
mvn checkstyle:checkstyle
```

↓

## Stage 6

SonarQube Scan

Performed using Jenkins Sonar Scanner.

↓

## Stage 7

Docker Build

```
docker build
```

↓

## Stage 8

Push Docker Image

Images tagged as:

```
V1
V2
V3
...
Latest
```

↓

## Stage 9

Helm Deployment

```
helm upgrade --install
```

↓

## Stage 10

Application Running on Kubernetes

---

# Repository Structure

```
cicd-kube-docker/

│
├── Dockerfile
├── Jenkinsfile
├── pom.xml
├── README.md
│
├── helm/
│   └── vprofilecharts/
│
├── kubernetes/
│
└── src/
```

---

# Jenkins Pipeline Stages

✔ Build

✔ Unit Test

✔ Integration Test

✔ Checkstyle

✔ SonarQube Scan

✔ Docker Build

✔ Docker Push

✔ Remove Local Docker Image

✔ Kubernetes Deployment

---

# Docker Image Lifecycle

```
Build

↓

Tag

↓

Push to DockerHub

↓

Pull inside Kubernetes

↓

Deploy using Helm

↓

Rolling Update
```

---

# Kubernetes Deployment

Deployment performed using Helm.

Example:

```
helm upgrade --install \
vprofile-stack \
helm/vprofilecharts \
--namespace prod \
--create-namespace \
--set appimage=aroy0509/vprofileapp:V7
```

---

# Features Implemented

- Automated Build
- Automated Testing
- Static Code Analysis
- Docker Image Creation
- DockerHub Integration
- Helm Deployment
- Kubernetes Rolling Upgrade
- Jenkins SSH Agent
- Multi-stage Jenkins Pipeline
- Artifact Archiving
- Workspace Cleanup

---

# Major Challenges Solved

During implementation several real-world DevOps problems were encountered and resolved.

Some of them include:

- Jenkins Tool Configuration
- Maven Configuration Issues
- SonarQube Installation
- Sonar Token Configuration
- Sonar Scanner Configuration
- Sonar Quality Gate Failure
- Docker Installation Issues
- Docker Repository Signed-By Conflict
- Docker Permission Denied
- DockerHub Authentication
- GitHub Personal Access Token Authentication
- SSH Authentication
- Git Remote Configuration
- Jenkins Agent Offline
- Java Version Mismatch
- Java 8 vs Java 21 Compatibility
- Jenkins Remoting.jar Error
- Docker Base Image Compatibility
- Helm Installation
- Helm Deployment Issues
- Kubernetes Namespace Creation
- Kubernetes Deployment Automation
- AWS CLI Installation on Ubuntu 24.04
- Jenkins Workspace Cleanup
- Docker Image Cleanup

Complete details are available in:

- deployment-guide.md
- troubleshooting-guide.md
- lessons-learned.md

---

# Skills Demonstrated

## DevOps

- CI/CD
- Infrastructure Automation
- Build Automation
- Deployment Automation

## Cloud

- AWS EC2
- Security Groups
- SSH
- IAM Concepts

## Containers

- Docker
- DockerHub
- Image Optimization

## Kubernetes

- kOps
- Helm
- Deployments
- Services
- Pods
- Namespaces

## Jenkins

- Declarative Pipeline
- SSH Agents
- Credentials
- Tool Configuration
- Docker Integration

## Code Quality

- SonarQube
- Checkstyle

---

# Key Learnings

Throughout this project I gained hands-on experience in:

- Designing Production-Style CI/CD Pipelines
- Deploying Applications on Kubernetes
- Jenkins Agent Architecture
- Docker Image Management
- SonarQube Integration
- Helm Package Management
- Kubernetes Rolling Updates
- GitHub Authentication Methods
- Jenkins Credential Management
- Debugging Production Deployment Issues
- Java Runtime Compatibility
- Docker Registry Authentication
- Kubernetes Deployment Automation

---

# Future Enhancements

- Jenkins Webhook Integration
- GitOps using ArgoCD
- Terraform Infrastructure Provisioning
- Prometheus Monitoring
- Grafana Dashboards
- Ingress Controller
- HTTPS using Let's Encrypt
- Horizontal Pod Autoscaler
- Kubernetes Secrets Management
- Blue-Green Deployment
- Canary Deployment
- Slack Notifications
- Email Notifications
- Nexus Artifact Repository

---

# Project Outcome

Successfully implemented a complete Production-Style CI/CD Pipeline capable of:

- Building Java applications
- Running automated tests
- Performing static code analysis
- Creating Docker images
- Publishing images to DockerHub
- Deploying applications on Kubernetes using Helm
- Automating the entire deployment workflow through Jenkins

The project closely resembles enterprise DevOps workflows and demonstrates practical experience with modern CI/CD, containerization, and Kubernetes deployment strategies.

---

# Author

**Abhishek Roy**

**Role:** DevOps / MLOps Engineer

**GitHub:** https://github.com/Sar-py-05

---

⭐ If you found this project helpful, consider giving the repository a star!
