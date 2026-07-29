# troubleshooting-guide.md

# Troubleshooting Guide

## Project

**End-to-End CI/CD Pipeline using Jenkins, Docker, SonarQube, DockerHub, Helm, KOPS and Kubernetes on AWS**

---

# Purpose

This document consolidates every major issue encountered during the implementation of this project, along with the root cause, diagnosis, and resolution steps. It serves as a reference for future troubleshooting and interview preparation.

---

# Table of Contents

1. Jenkins Issues
2. Maven Issues
3. SonarQube Issues
4. Docker Issues
5. DockerHub Issues
6. Git & GitHub Issues
7. Jenkins Agent Issues
8. Java Issues
9. Kubernetes Issues
10. Helm Issues
11. KOPS Issues
12. Linux & Ubuntu Issues
13. AWS Issues

---

# 1. Jenkins Issues

---

## Issue 1: Maven Tool Not Found

### Error

```
Tool type "maven" does not have an install of "maven3.9.9"
```

### Root Cause

The Maven tool name in the Jenkinsfile did not exactly match the configured Global Tool name.

### Resolution

Navigate to

```
Manage Jenkins

↓

Global Tool Configuration
```

Use the exact configured tool name.

Example

```groovy
tools {
    maven "MAVEN3.9.9"
}
```

---

## Issue 2: Sonar Scanner Tool Not Found

### Error

```
No tool named mysonarscanner4 found
```

### Resolution

Configure the Sonar Scanner under:

```
Manage Jenkins

↓

Global Tool Configuration
```

Then reference it exactly in the Jenkinsfile.

---

## Issue 3: Pipeline Aborted Due to Quality Gate

### Error

```
Pipeline aborted due to quality gate failure
```

### Root Cause

`waitForQualityGate abortPipeline:true`

stops the pipeline whenever the Quality Gate returns **ERROR**.

### Resolution (Training Environment)

Disable pipeline abortion.

```groovy
waitForQualityGate abortPipeline: false
```

or remove the Quality Gate stage entirely during practice.

---

## Issue 4: Groovy Compilation Error

### Error

```
Expected a step
```

### Root Cause

A Groovy variable (`def qg`) was declared directly inside the `steps` block.

### Resolution

Wrap Groovy code in a `script` block.

```groovy
script {
    def qg = waitForQualityGate abortPipeline: false
    echo "${qg.status}"
}
```

---

## Issue 5: Jenkins Pipeline Stuck Waiting for Agent

### Error

```
Still waiting to schedule task

'kops' is offline
```

### Root Cause

The KOPS Jenkins agent was offline.

### Resolution

- Verify SSH connectivity.
- Restart the agent.
- Confirm Java version.
- Reconnect the node.

---

# 2. Maven Issues

---

## Build Failure

### Error

```
BUILD FAILURE
```

### Resolution

Run locally.

```
mvn clean install
```

Verify

- pom.xml
- Dependencies
- Java Version

---

# 3. SonarQube Issues

---

## Quality Gate Failed

### Symptoms

Analysis completed successfully.

Pipeline failed afterwards.

### Root Cause

Quality Gate status

```
ERROR
```

### Resolution

For production

Fix

- Bugs
- Vulnerabilities
- Code Smells

For training

Continue deployment by disabling Quality Gate enforcement.

---

## Sonar Token Authentication Failure

### Error

```
Not authorized
```

### Root Cause

Incorrect token type.

### Resolution

Use

```
Project Analysis Token
```

instead of User Token.

---

# 4. Docker Issues

---

## Docker Build Failed

### Error

```
openjdk:11 not found
```

### Root Cause

Image removed from DockerHub.

### Resolution

Update Dockerfile.

Old

```
FROM openjdk:11
```

New

```
FROM eclipse-temurin:21-jdk
```

---

## Tomcat Image Not Found

### Error

```
tomcat:9-jre11
```

not available.

### Resolution

Use

```
tomcat:9.0-jdk21-temurin
```

---

## Docker Login Failure

### Error

```
Authentication failed
```

### Root Cause

Incorrect DockerHub credentials.

### Resolution

Create Jenkins credentials using

```
Username

Password (or Personal Access Token)
```

Credential ID

```
dockerhub
```

---

## Docker Push Hanging

### Symptoms

Layers remain in

```
Waiting
```

### Cause

Slow network or DockerHub upload.

### Resolution

Usually resolves automatically.

Wait until

```
Pushed
```

appears.

---

## Docker Cleanup Failure

### Resolution

Use

```
docker rmi IMAGE || true
```

to avoid pipeline failure.

---

# 5. Git & GitHub Issues

---

## Authentication Failed

### Error

```
Authentication failed
```

### Root Cause

GitHub no longer accepts account passwords.

### Resolution

Use

```
GitHub Personal Access Token
```

instead.

---

## SSH Authentication Failed

### Error

```
Permission denied (publickey)
```

### Root Cause

SSH public key not added to GitHub.

### Resolution

Generate SSH key.

```
ssh-keygen
```

Copy

```
id_ed25519.pub
```

to GitHub.

---

## Wrong Branch

### Error

```
src refspec master does not match
```

### Root Cause

Repository uses

```
main
```

instead of

```
master
```

### Resolution

```
git push origin main
```

---

## Upstream Gone

### Error

```
upstream is gone
```

### Resolution

```
git branch --unset-upstream
```

or

```
git branch --set-upstream-to origin/main
```

---

# 6. Jenkins Agent Issues

---

## Agent Launch Failure

### Error

```
UnsupportedClassVersionError
```

### Root Cause

Agent was running

```
Java 8
```

while Jenkins Remoting required

```
Java 17+
```

### Resolution

Install Java 21.

```
sudo apt install openjdk-21-jdk
```

Update alternatives.

```
sudo update-alternatives --config java
```

Verify.

```
java -version
```

Expected

```
Java 21
```

Reconnect agent.

---

## Incorrect Ownership

### Warning

```
ubuntu.ubuntu
```

### Resolution

Correct syntax.

```
sudo chown ubuntu:ubuntu /opt/jenkins-slave -R
```

---

# 7. Java Issues

---

## Wrong Java Version

### Symptoms

```
java -version
```

showed

```
Java 8
```

### Resolution

Switch Java.

```
sudo update-alternatives --config java
```

Select

```
Java 21
```

Repeat for

```
javac
```

---

# 8. Kubernetes Issues

---

## Cluster Validation

Verify

```
kops validate cluster
```

Expected

```
Your cluster is ready
```

---

## Pods Not Running

Check

```
kubectl get pods
```

Describe

```
kubectl describe pod POD
```

Logs

```
kubectl logs POD
```

---

## CrashLoopBackOff

Possible causes

- Image failure
- Environment variables
- Resource limits
- Wrong image tag

---

## ImagePullBackOff

Verify

```
docker push
```

Check

- Image name
- Repository
- Tag

---

# 9. Helm Issues

---

## Helm Not Installed

### Error

```
helm: command not found
```

### Resolution

Install

```
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
```

---

## Installation Failed

### Error

```
must either provide a name
```

### Root Cause

Missing release name.

### Resolution

```
helm install vprofile-stack helm/vprofilecharts
```

---

## Deployment Failed

Check

```
helm status vprofile-stack
```

History

```
helm history vprofile-stack
```

Rollback

```
helm rollback vprofile-stack 1
```

---

# 10. KOPS Issues

---

## Cluster Not Ready

Run

```
kops validate cluster
```

---

## kubeconfig Missing

Export configuration.

```
kops export kubeconfig
```

---

## Helm Deployment Failed

Verify

```
kubectl get nodes
```

```
helm list
```

```
kubectl get pods
```

---

# 11. Linux & Ubuntu Issues

---

## Docker Repository Conflict

### Error

```
Signed-By conflict
```

### Root Cause

Both

```
docker.sources
```

and

```
docker.list
```

configured Docker repository.

### Resolution

Keep only one configuration.

Remove duplicate.

```
sudo rm /etc/apt/sources.list.d/docker.sources
```

Run

```
sudo apt update
```

---

## apt Update Timeout

### Error

```
Connection timed out
```

### Resolution

Retry.

```
sudo apt update
```

or

```
sudo apt --fix-missing install
```

---

# 12. AWS Issues

---

## Security Group Problems

Symptoms

- SSH fails
- Jenkins inaccessible
- Sonar inaccessible

### Resolution

Verify inbound rules.

```
22
80
8080
9000
6443
30000-32767
```

---

## EC2 Connectivity

Verify

```
ping
```

```
ssh
```

```
curl
```

---

# Useful Diagnostic Commands

## Jenkins

```
sudo systemctl status jenkins
```

```
sudo journalctl -u jenkins -f
```

---

## Docker

```
docker ps
```

```
docker images
```

```
docker system prune -a
```

---

## Kubernetes

```
kubectl get all -A
```

```
kubectl get events -A
```

```
kubectl describe pod POD
```

---

## Helm

```
helm list -A
```

```
helm history vprofile-stack
```

---

## KOPS

```
kops validate cluster
```

```
kops export kubeconfig
```

---

## Java

```
java -version
```

```
javac -version
```

---

## Git

```
git status
```

```
git branch
```

```
git remote -v
```

---

# Lessons Learned

- Tool names in Jenkinsfiles must exactly match Jenkins Global Tool Configuration.
- Jenkins agents should run Java 17 or later; Java 21 is recommended.
- Keep only one Docker APT repository definition to avoid `Signed-By` conflicts.
- Always use a GitHub Personal Access Token (PAT) or SSH keys for Git operations; account passwords are no longer supported.
- Validate the Kubernetes cluster before deploying.
- Verify Docker image availability before updating Helm charts.
- Test Docker builds locally before running the CI pipeline.
- Monitor SonarQube Quality Gates, but avoid blocking deployments in a learning environment.
- Prefer Helm upgrades over deleting and recreating Kubernetes resources.
- Maintain versioned Docker images (`V1`, `V2`, etc.) alongside the `latest` tag for rollback capability.

---

# Final Outcome

After resolving all issues documented above, the pipeline successfully achieved:

- Source checkout from GitHub
- Maven build and packaging
- Unit and integration testing
- Checkstyle and SonarQube analysis
- Docker image build
- Docker image push to DockerHub
- Local Docker image cleanup
- Helm deployment to the KOPS Kubernetes cluster
- Successful rolling update of the application in the `prod` namespace
- End-to-end CI/CD pipeline completion with **SUCCESS**
