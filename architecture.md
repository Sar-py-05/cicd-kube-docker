# Architecture

# End-to-End CI/CD Pipeline using Jenkins, SonarQube, Docker, Helm & Kubernetes (kOps)

---

# 1. Architecture Overview

This project demonstrates a complete Production-Style Continuous Integration and Continuous Deployment (CI/CD) pipeline built on AWS. The architecture automates the complete software delivery lifecycle from source code commit to deployment on a Kubernetes cluster.

The solution integrates several industry-standard DevOps tools to automate software build, testing, code quality analysis, containerization, image distribution, and Kubernetes deployment.

The pipeline consists of the following major components:

- GitHub
- Jenkins
- SonarQube
- Docker
- DockerHub
- Kubernetes (kOps)
- Helm
- AWS EC2

---

# 2. High-Level Architecture

```
                           Developer
                               │
                               │
                     Git Push / Pull Request
                               │
                               ▼
                      +------------------+
                      |     GitHub       |
                      +--------+---------+
                               │
                               ▼
                      +------------------+
                      |     Jenkins      |
                      |   CI/CD Server   |
                      +--------+---------+
                               │
        ---------------------------------------------------------
        │           │             │             │               │
        ▼           ▼             ▼             ▼               ▼

   Maven Build   Unit Test   Checkstyle   SonarQube      Docker Build
                                                │
                                                ▼
                                       Code Quality Report
                                                │
                                                ▼
                                     Docker Image Creation
                                                │
                                                ▼
                                        DockerHub Registry
                                                │
                                                ▼
                                  Jenkins SSH Agent (KOPS)
                                                │
                                                ▼
                                  Helm Upgrade / Install
                                                │
                                                ▼
                                   Kubernetes Cluster
                                                │
                                                ▼
                                   vProfile Application
```

---

# 3. Infrastructure Architecture

AWS Infrastructure

```
                     AWS Cloud
                         │
 ┌────────────────────────────────────────────────────┐
 │                                                    │
 │                                                    │
 │      Jenkins Server (Ubuntu 24.04)                 │
 │      --------------------------------              │
 │      Jenkins                                       │
 │      Maven                                         │
 │      Docker                                        │
 │      Sonar Scanner                                 │
 │      AWS CLI                                       │
 │      Ansible                                       │
 │                                                    │
 └────────────────────────────────────────────────────┘
                │
                │
                ▼

 ┌────────────────────────────────────────────────────┐
 │                                                    │
 │      SonarQube Server                              │
 │      --------------------------------              │
 │      SonarQube Community Edition                   │
 │      PostgreSQL                                    │
 │      Java 21                                       │
 │                                                    │
 └────────────────────────────────────────────────────┘
                │
                │
                ▼

 ┌────────────────────────────────────────────────────┐
 │                                                    │
 │          Kubernetes Cluster (kOps)                 │
 │                                                    │
 │   Control Plane                                    │
 │   Worker Node 1                                    │
 │   Worker Node 2                                    │
 │                                                    │
 │   Helm                                             │
 │   kubectl                                          │
 │                                                    │
 └────────────────────────────────────────────────────┘
```

---

# 4. Source Code Management Layer

GitHub serves as the central source code repository.

Repository contains:

- Application Source Code
- Dockerfile
- Jenkinsfile
- Helm Charts
- Kubernetes Manifests
- Documentation

Every pipeline execution begins with Jenkins checking out the latest source code from GitHub.

---

# 5. Jenkins Architecture

Jenkins is the heart of the CI/CD pipeline.

Installed Components

- Jenkins LTS
- Maven 3.9.9
- JDK 21
- Docker
- Sonar Scanner
- Docker Pipeline Plugin
- Git Plugin
- SSH Agent Plugin
- Pipeline Plugin

Responsibilities

- Pull source code
- Compile application
- Execute tests
- Static code analysis
- Build Docker image
- Push image to DockerHub
- Trigger Kubernetes deployment

---

# 6. SonarQube Architecture

A dedicated SonarQube server performs static code analysis.

Pipeline Integration

```
Jenkins
      │
      ▼

Sonar Scanner

      │
      ▼

SonarQube Server

      │
      ▼

Quality Report

      │
      ▼

Quality Gate Status
```

SonarQube analyzes

- Bugs
- Vulnerabilities
- Security Hotspots
- Code Smells
- Maintainability
- Reliability

---

# 7. Build Architecture

Application build is performed using Apache Maven.

Pipeline

```
Source Code

      │

      ▼

mvn clean install

      │

      ▼

WAR File

target/

      │

      ▼

Docker Build
```

Generated Artifact

```
target/vprofile-v2.war
```

---

# 8. Testing Architecture

Testing consists of multiple stages.

## Unit Testing

```
mvn test
```

Verifies application logic.

---

## Integration Testing

```
mvn verify
```

Validates component interaction.

---

## Checkstyle

```
mvn checkstyle:checkstyle
```

Ensures coding standards.

---

## SonarQube

Performs

- Static Analysis
- Security Analysis
- Code Quality

---

# 9. Docker Architecture

Docker is responsible for packaging the application.

Pipeline

```
WAR File

        │

        ▼

Docker Build

        │

        ▼

Docker Image

        │

        ▼

DockerHub
```

Image Tags

```
V1

V2

V3

Latest
```

Docker Image Structure

```
Tomcat 9

↓

ROOT.war

↓

Container

↓

Port 8080
```

---

# 10. DockerHub Architecture

DockerHub acts as the container registry.

Workflow

```
Docker Build

↓

Tag Image

↓

Docker Login

↓

Push Image

↓

Store Image

↓

Kubernetes Pulls Image
```

---

# 11. Jenkins Agent Architecture

The deployment stage executes on a dedicated Jenkins SSH Agent.

```
Jenkins Master

        │

 SSH Connection

        │

        ▼

KOPS EC2

        │

        ▼

Helm

        │

        ▼

Kubernetes
```

Why SSH Agent?

- Secure deployment
- Separate execution environment
- Access to Kubernetes cluster
- Helm installed only on deployment node

---

# 12. Kubernetes Architecture

Cluster Components

```
                Control Plane
                      │
         ----------------------------
         │                          │
         ▼                          ▼

      Worker 1                 Worker 2

         │                          │
         └──────────────┬───────────┘
                        │
                        ▼

                 Application Pods
```

Responsibilities

Control Plane

- Scheduling
- API Server
- Controller Manager
- etcd

Worker Nodes

- Pods
- Services
- Networking

---

# 13. Helm Architecture

Helm manages Kubernetes deployments.

Pipeline

```
DockerHub

      │

      ▼

Helm Chart

      │

      ▼

helm upgrade --install

      │

      ▼

Deployment

      │

      ▼

Pods Updated
```

Benefits

- Versioned deployments
- Easy rollback
- Parameterized deployments
- Reusable templates

---

# 14. Deployment Flow

```
Git Push

↓

Jenkins

↓

Maven Build

↓

Tests

↓

Checkstyle

↓

SonarQube

↓

Docker Build

↓

DockerHub

↓

SSH Agent

↓

Helm Upgrade

↓

Kubernetes Deployment

↓

Application Running
```

---

# 15. Networking Architecture

Communication Flow

```
Developer

↓

GitHub

↓

Jenkins

↓

SonarQube

↓

DockerHub

↓

KOPS Master

↓

Worker Nodes

↓

Pods

↓

Application
```

---

# 16. Security Architecture

Implemented Security Features

GitHub

- Personal Access Token
- SSH Authentication

Jenkins

- Credentials Store
- DockerHub Credentials
- SonarQube Token
- SSH Credentials

Docker

- Authenticated DockerHub Push

AWS

- Security Groups
- SSH Keys

Kubernetes

- Namespace Isolation
- Helm-managed Deployments

---

# 17. Artifact Lifecycle

```
Source Code

↓

Compile

↓

WAR

↓

Docker Image

↓

DockerHub

↓

Helm

↓

Kubernetes Deployment

↓

Running Pod
```

---

# 18. Pipeline Sequence Diagram

```
Developer
    │
    ▼
GitHub
    │
    ▼
Jenkins
    │
    ├──────── Build
    │
    ├──────── Unit Test
    │
    ├──────── Integration Test
    │
    ├──────── Checkstyle
    │
    ├──────── SonarQube
    │
    ├──────── Docker Build
    │
    ├──────── Docker Push
    │
    ├──────── Cleanup
    │
    └──────── Deploy
                 │
                 ▼
              Helm
                 │
                 ▼
         Kubernetes Cluster
                 │
                 ▼
         Application Running
```

---

# 19. High Availability Considerations

Current Implementation

- Dedicated Jenkins Server
- Dedicated SonarQube Server
- Separate Kubernetes Cluster
- Multiple Kubernetes Worker Nodes
- Versioned Docker Images
- Versioned Helm Releases

Future Enhancements

- Jenkins High Availability
- External Artifact Repository
- Nexus Integration
- ArgoCD GitOps
- Horizontal Pod Autoscaler
- Prometheus Monitoring
- Grafana Dashboards
- HTTPS with Ingress Controller
- Blue-Green Deployment
- Canary Deployment

---

# 20. Architecture Summary

This architecture demonstrates a complete enterprise-style DevOps pipeline where:

- GitHub stores application source code.
- Jenkins automates the CI/CD workflow.
- Maven compiles and packages the application.
- Unit and Integration tests validate application quality.
- Checkstyle enforces coding standards.
- SonarQube performs static code analysis.
- Docker packages the application into immutable images.
- DockerHub stores versioned images.
- Jenkins SSH Agent securely connects to the Kubernetes environment.
- Helm manages application deployment and upgrades.
- Kubernetes orchestrates application containers across multiple worker nodes.

The architecture follows modern DevOps best practices by separating build, analysis, containerization, registry management, and deployment responsibilities while ensuring automation, repeatability, scalability, and maintainability.
