# runbook.md

# Operations Runbook

## Project

CI/CD Pipeline for VProfile Application using Jenkins, Docker, SonarQube, Helm and Kubernetes (KOPS)

---

# Purpose

This runbook provides standard operating procedures for deploying, monitoring, troubleshooting, recovering, and maintaining the VProfile application running on a Kubernetes cluster through an automated Jenkins CI/CD pipeline.

---

# Environment

## Source Control

GitHub Repository

```
https://github.com/Sar-py-05/cicd-kube-docker
```

---

## Container Registry

DockerHub

```
aroy0509/vprofileapp
```

---

## CI Server

Jenkins

Responsible for:

- Source checkout
- Maven Build
- Unit Tests
- Integration Tests
- Checkstyle
- SonarQube Scan
- Docker Build
- Docker Push
- Helm Deployment

---

## Code Quality

SonarQube

Project

```
vprofile
```

---

## Container Platform

Kubernetes Cluster

Provisioned using

```
KOPS
```

---

## Package Manager

Helm

Release

```
vprofile-stack
```

Namespace

```
prod
```

---

# Daily Health Checks

## Verify Jenkins

Open Jenkins Dashboard

Confirm

- Jenkins service is running
- Build queue is empty
- Agents are online
- No failed scheduled jobs

---

## Verify Jenkins Agent

On Jenkins Dashboard

```
Manage Jenkins

↓

Nodes

↓

kops
```

Expected Status

```
Online
```

---

## Verify Kubernetes Cluster

```
kops validate cluster
```

Expected Output

```
Your cluster is ready
```

---

## Verify Cluster Nodes

```
kubectl get nodes
```

Expected

```
Ready
```

for all nodes.

---

## Verify Namespaces

```
kubectl get ns
```

Expected

```
prod
default
kube-system
```

---

## Verify Pods

```
kubectl get pods -n prod
```

Expected

```
Running
```

for every application pod.

---

## Verify Deployments

```
kubectl get deployment -n prod
```

Expected

```
READY
AVAILABLE
```

should match desired replicas.

---

## Verify ReplicaSets

```
kubectl get rs -n prod
```

---

## Verify Services

```
kubectl get svc -n prod
```

---

## Verify Helm Release

```
helm list -A
```

Expected

```
vprofile-stack
```

Status

```
deployed
```

---

# Manual Build Procedure

Navigate to Jenkins

```
Dashboard

↓

kube-cicd Pipeline

↓

Build Now
```

Expected Flow

```
Checkout

↓

Build

↓

Unit Test

↓

Integration Test

↓

Checkstyle

↓

SonarQube

↓

Docker Build

↓

Docker Push

↓

Cleanup

↓

Helm Deploy
```

---

# Manual Deployment

Deploy latest image

```
helm upgrade --install vprofile-stack \
helm/vprofilecharts \
--namespace prod \
--create-namespace \
--set appimage=aroy0509/vprofileapp:latest
```

---

Deploy specific version

```
helm upgrade --install vprofile-stack \
helm/vprofilecharts \
--namespace prod \
--set appimage=aroy0509/vprofileapp:V10
```

---

# Verify New Deployment

```
kubectl rollout status deployment -n prod
```

---

Check Pods

```
kubectl get pods -n prod
```

---

Describe Pod

```
kubectl describe pod <pod-name> -n prod
```

---

Container Logs

```
kubectl logs <pod-name> -n prod
```

---

Previous Container Logs

```
kubectl logs --previous <pod-name> -n prod
```

---

Stream Logs

```
kubectl logs -f <pod-name> -n prod
```

---

# Rollback Procedure

List Helm Revisions

```
helm history vprofile-stack -n prod
```

Rollback

```
helm rollback vprofile-stack 1 -n prod
```

Verify

```
helm list -n prod
```

---

# Restart Deployment

```
kubectl rollout restart deployment -n prod
```

---

Monitor Restart

```
kubectl rollout status deployment -n prod
```

---

# Scaling Application

Increase Replicas

```
kubectl scale deployment vprofile-vproapp \
--replicas=4 \
-n prod
```

---

Verify

```
kubectl get pods -n prod
```

---

# Emergency Pod Restart

Delete unhealthy pod

```
kubectl delete pod <pod-name> -n prod
```

Kubernetes automatically recreates it.

---

# Docker Operations

View Images

```
docker images
```

---

Remove Image

```
docker rmi IMAGE_ID
```

---

View Running Containers

```
docker ps
```

---

Clean Unused Images

```
docker image prune -a
```

---

Clean Everything

```
docker system prune -a
```

---

# Helm Operations

Installed Releases

```
helm list -A
```

---

Release History

```
helm history vprofile-stack
```

---

Upgrade

```
helm upgrade
```

---

Rollback

```
helm rollback
```

---

Uninstall

```
helm uninstall vprofile-stack -n prod
```

---

# Kubernetes Operations

Cluster Information

```
kubectl cluster-info
```

---

Current Context

```
kubectl config current-context
```

---

All Resources

```
kubectl get all -n prod
```

---

Events

```
kubectl get events -n prod
```

---

Describe Deployment

```
kubectl describe deployment -n prod
```

---

Describe Node

```
kubectl describe node
```

---

# SonarQube Operations

Run Analysis

```
sonar-scanner
```

---

Open Dashboard

```
Projects

↓

vprofile
```

---

Quality Gate

Review

- Bugs
- Vulnerabilities
- Code Smells
- Coverage
- Duplication

**Note:** For this training project, the Jenkins pipeline is configured to continue even if the SonarQube Quality Gate reports an `ERROR`, allowing deployment practice while still reviewing code quality results.

---

# Jenkins Operations

Restart Jenkins

```
sudo systemctl restart jenkins
```

---

Check Status

```
sudo systemctl status jenkins
```

---

View Logs

```
sudo journalctl -u jenkins -f
```

---

Reload Configuration

```
Manage Jenkins

↓

Reload Configuration from Disk
```

---

# Docker Service

Status

```
sudo systemctl status docker
```

---

Restart

```
sudo systemctl restart docker
```

---

Enable

```
sudo systemctl enable docker
```

---

# KOPS Operations

Validate Cluster

```
kops validate cluster
```

---

Update Cluster

```
kops update cluster --yes
```

---

Rolling Update

```
kops rolling-update cluster --yes
```

---

Export kubeconfig

```
kops export kubeconfig
```

---

# Monitoring Checklist

Daily

- Jenkins running
- Docker running
- SonarQube reachable
- Kubernetes healthy
- Helm release deployed
- Pods running
- Services available
- Node Ready
- Build success
- DockerHub push successful

---

Weekly

- Review Jenkins logs
- Remove unused Docker images
- Verify Kubernetes events
- Check disk utilization
- Review SonarQube issues
- Update plugins if required
- Verify backups

---

# Recovery Procedures

## Jenkins Down

```
sudo systemctl restart jenkins
```

---

## Docker Down

```
sudo systemctl restart docker
```

---

## Agent Offline

Verify

```
java -version
```

Expected

```
Java 21
```

Restart the Jenkins agent from the Jenkins dashboard if necessary.

---

## Pods CrashLoopBackOff

```
kubectl describe pod
```

```
kubectl logs
```

Redeploy

```
helm upgrade
```

---

## Image Pull Failure

Verify

```
docker push
```

Check

- DockerHub repository
- Image tag
- Image name

---

## Helm Failure

```
helm history
```

Rollback

```
helm rollback
```

---

# Backup Recommendations

Regularly back up:

- Jenkins Home (`/var/lib/jenkins`)
- Jenkinsfiles
- Helm Charts
- Kubernetes manifests
- SonarQube database
- GitHub repositories
- Docker image tags
- KOPS cluster configuration

---

# Success Criteria

The environment is considered healthy when:

- Jenkins pipeline completes successfully.
- SonarQube analysis finishes without scanner errors.
- Docker image is published to DockerHub.
- Helm deployment completes successfully.
- Kubernetes pods are in the `Running` state.
- Services are accessible.
- Application is reachable through the configured endpoint.

---

# Document Version

Version: 1.0

Last Updated: July 2026

Project: End-to-End CI/CD Pipeline using Jenkins, Docker, SonarQube, DockerHub, Helm, KOPS, and Kubernetes on AWS
