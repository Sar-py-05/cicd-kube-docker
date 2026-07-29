# Chapter-07-Kubernetes.md
# Part-1

# Kubernetes Fundamentals (Questions 1–25)

---

# Q1. What is Kubernetes?

## Answer

Kubernetes (often abbreviated as **K8s**) is an open-source container orchestration platform that automates the deployment, scaling, networking, and management of containerized applications.

It was originally developed by Google based on its internal Borg system and is now maintained by the Cloud Native Computing Foundation (CNCF).

Instead of manually managing Docker containers on individual servers, Kubernetes manages them across an entire cluster.

In our project, Kubernetes deployed the Docker image built by Jenkins using a Helm chart onto a KOPS cluster running on AWS.

Architecture

```
Developer

↓

GitHub

↓

Jenkins

↓

Docker Hub

↓

Kubernetes Cluster

↓

Running Pods
```

---

# Q2. Why did you use Kubernetes in your project?

## Answer

Docker solves the problem of packaging applications, while Kubernetes solves the problem of running containers reliably at scale.

Reasons we used Kubernetes:

• Automatic deployment

• Self-healing

• High availability

• Rolling updates

• Service discovery

• Load balancing

• Horizontal scaling

• Easy rollback

Our project workflow was:

```
GitHub

↓

Jenkins Pipeline

↓

Docker Image

↓

Docker Hub

↓

Helm

↓

KOPS Cluster

↓

Pods
```

---

# Q3. What problems does Kubernetes solve?

## Answer

Managing containers manually becomes difficult as the number of applications grows.

Without Kubernetes:

• Manual deployment

• Manual scaling

• No automatic recovery

• Difficult upgrades

• Complex networking

• High operational effort

With Kubernetes:

✓ Automatic scheduling

✓ Self-healing

✓ Rolling updates

✓ Service discovery

✓ Auto scaling

✓ Resource management

---

# Q4. Explain Kubernetes Architecture.

## Answer

A Kubernetes cluster consists of two major components:

```
                Kubernetes Cluster

        ┌─────────────────────────────┐
        │        Control Plane        │
        ├─────────────────────────────┤
        │ kube-apiserver              │
        │ etcd                        │
        │ Scheduler                   │
        │ Controller Manager          │
        └─────────────────────────────┘
                    │
     ───────────────────────────────────────
          │                │             │
     Worker Node      Worker Node   Worker Node
          │                │             │
        Pods             Pods          Pods
```

The Control Plane manages the cluster, while Worker Nodes run application workloads.

---

# Q5. What is the Control Plane?

## Answer

The Control Plane is the brain of Kubernetes.

Responsibilities:

• Receives API requests

• Schedules Pods

• Maintains cluster state

• Monitors node health

• Performs self-healing

Major components:

• kube-apiserver

• etcd

• kube-scheduler

• controller-manager

In our KOPS cluster, the Control Plane managed deployments created by Helm.

---

# Q6. What is a Worker Node?

## Answer

Worker Nodes are machines where application containers actually run.

Each worker node contains:

```
Worker Node

├── kubelet

├── kube-proxy

├── Container Runtime

└── Pods
```

In our project, Docker images from Docker Hub were downloaded onto worker nodes where Pods were created.

---

# Q7. What is a Pod?

## Answer

A Pod is the smallest deployable unit in Kubernetes.

A Pod can contain:

• One container

• Multiple tightly coupled containers

Example

```
Pod

└── Java Application Container
```

In our project, each Pod contained the vProfile application.

---

# Q8. Why does Kubernetes use Pods instead of Containers?

## Answer

Pods provide additional capabilities beyond containers.

Benefits:

• Shared network

• Shared storage

• Shared lifecycle

• Sidecar support

Structure

```
Pod

├── Container A

├── Container B

└── Shared Network
```

Containers inside the same Pod communicate through localhost.

---

# Q9. What is the lifecycle of a Pod?

## Answer

A Pod goes through several phases.

```
Pending

↓

Running

↓

Succeeded

↓

Failed
```

Sometimes a Pod may also enter:

```
CrashLoopBackOff

ImagePullBackOff

ContainerCreating
```

These states help diagnose deployment issues.

---

# Q10. What is a ReplicaSet?

## Answer

A ReplicaSet ensures that a specified number of Pod replicas are always running.

Example

Desired replicas:

```
3 Pods
```

If one Pod crashes:

```
3

↓

2

↓

ReplicaSet creates another Pod

↓

3
```

This provides self-healing.

---

# Q11. What is a Deployment?

## Answer

A Deployment is a higher-level Kubernetes object used to manage ReplicaSets.

Responsibilities:

• Rolling updates

• Rollback

• Replica management

• Self-healing

Architecture

```
Deployment

↓

ReplicaSet

↓

Pods
```

Our Helm chart created a Deployment for the application.

---

# Q12. Difference between Pod and Deployment?

## Answer

Pod

• Runs application

• Temporary

• No automatic recovery

Deployment

• Manages Pods

• Supports scaling

• Supports rolling updates

• Supports rollback

Production applications should always use Deployments instead of standalone Pods.

---

# Q13. What is a Namespace?

## Answer

Namespaces logically separate resources inside a Kubernetes cluster.

Example

```
default

kube-system

prod

test

dev
```

In our project we deployed applications into different namespaces such as:

```
test

prod
```

using Helm.

---

# Q14. Why are Namespaces important?

## Answer

Benefits:

• Resource isolation

• Environment separation

• RBAC separation

• Quota management

• Cleaner administration

Example

```
Production Namespace

↓

Production Pods

Development Namespace

↓

Development Pods
```

---

# Q15. What are Labels?

## Answer

Labels are key-value pairs attached to Kubernetes objects.

Example

```yaml
labels:

  app: vprofile

  env: production
```

Labels allow Kubernetes to identify related resources.

---

# Q16. What are Selectors?

## Answer

Selectors identify objects based on labels.

Example

Deployment

```
Selector

↓

app=vprofile

↓

Matching Pods
```

Without selectors, Services and Deployments cannot identify their target Pods.

---

# Q17. Explain the relationship between Labels and Selectors.

## Answer

Labels identify resources.

Selectors find resources.

Example

```
Pod

Label

app=vprofile

↓

Service

Selector

app=vprofile
```

The Service routes traffic to Pods whose labels match its selector.

---

# Q18. What is etcd?

## Answer

etcd is Kubernetes' distributed key-value database.

It stores:

• Cluster state

• Configuration

• Secrets

• Deployments

• Services

• Nodes

Without etcd, Kubernetes cannot function.

---

# Q19. What is kube-apiserver?

## Answer

The API Server is the front door of Kubernetes.

Every operation passes through it.

Example

```
kubectl

↓

API Server

↓

Cluster
```

When we executed:

```bash
kubectl get pods
```

the request first reached the API Server.

---

# Q20. What is kube-scheduler?

## Answer

The Scheduler determines which worker node should run a Pod.

Decision factors include:

• CPU availability

• Memory

• Node affinity

• Taints

• Resource requests

Example

```
New Pod

↓

Scheduler

↓

Best Worker Node
```

---

# Q21. What is kube-controller-manager?

## Answer

The Controller Manager continuously monitors the cluster and attempts to move it toward the desired state.

Examples:

• Replica Controller

• Deployment Controller

• Endpoint Controller

If a Pod crashes, the Controller Manager ensures a replacement Pod is created.

---

# Q22. What is kubelet?

## Answer

kubelet is the primary agent running on every worker node.

Responsibilities:

• Receives Pod specifications

• Starts containers

• Monitors container health

• Reports node status

Workflow

```
API Server

↓

kubelet

↓

Container Runtime

↓

Pod
```

---

# Q23. What is kube-proxy?

## Answer

kube-proxy manages networking rules on worker nodes.

Responsibilities:

• Service routing

• Load balancing

• Network forwarding

Architecture

```
Client

↓

Service

↓

kube-proxy

↓

Pods
```

This enables traffic distribution among multiple Pod replicas.

---

# Q24. What Container Runtime did your project use?

## Answer

Our worker nodes used a container runtime to execute Docker-compatible images.

The workflow was:

```
Docker Image

↓

Container Runtime

↓

Pod
```

The runtime downloads images from Docker Hub and starts the containers requested by Kubernetes.

Modern Kubernetes environments commonly use containerd, although Docker images remain fully compatible because they follow the OCI image specification.

---

# Q25. Summarize Kubernetes fundamentals using your project.

## Answer

This project provided practical experience with Kubernetes fundamentals:

✓ KOPS cluster deployment on AWS

✓ Kubernetes architecture

✓ Control Plane

✓ Worker Nodes

✓ Pods

✓ ReplicaSets

✓ Deployments

✓ Namespaces

✓ Labels

✓ Selectors

✓ kube-apiserver

✓ kubelet

✓ kube-scheduler

✓ kube-proxy

✓ etcd

✓ Helm-based deployments

✓ Docker image deployment

✓ Jenkins integration

Complete workflow:

```
GitHub

↓

Jenkins

↓

Docker Build

↓

Docker Hub

↓

Helm Upgrade

↓

Kubernetes Deployment

↓

ReplicaSet

↓

Pods

↓

Running Application
```

These concepts formed the foundation for deploying and managing our application in a production-style Kubernetes environment.

---

End of Chapter-07 (Part-1)

Questions Covered: **1–25**

Next Part (Part-2) will cover:

• Scheduling
• Node Affinity
• Taints & Tolerations
• Cordon & Drain
• Cluster Networking
• Services
• CoreDNS
• Ingress
• Persistent Volumes
• Persistent Volume Claims
• Storage Classes
• ConfigMaps
• Secrets
• Real troubleshooting scenarios from your KOPS project

# Chapter-07-Kubernetes.md
# Part-2

# Kubernetes Scheduling, Networking & Storage (Questions 26–50)

---

# Q26. How does Kubernetes schedule a Pod?

## Answer

When a Pod is created, Kubernetes does not immediately run it on a worker node. Instead, the **kube-scheduler** evaluates all available worker nodes and selects the most appropriate one based on resource availability and scheduling constraints.

The scheduler considers:

- CPU requests
- Memory requests
- Node health
- Node affinity
- Taints and tolerations
- Resource availability
- Existing workloads

Workflow:

```
Pod Created

      │

      ▼

Pending State

      │

      ▼

kube-scheduler

      │

      ▼

Worker Node Selected

      │

      ▼

kubelet Starts Pod
```

In our project, every application deployment created through Helm first entered the Pending state before being scheduled onto one of the KOPS worker nodes.

---

# Q27. What happens when Kubernetes cannot schedule a Pod?

## Answer

If no worker node satisfies the scheduling requirements, the Pod remains in the **Pending** state.

Common causes include:

- Insufficient CPU
- Insufficient Memory
- Node Not Ready
- Taints
- Missing tolerations
- Unsatisfied affinity rules
- PVC not bound

Useful commands:

```bash
kubectl get pods

kubectl describe pod <pod-name>
```

The Events section usually explains why scheduling failed.

---

# Q28. What is Node Affinity?

## Answer

Node Affinity allows Kubernetes to schedule Pods only onto nodes that match specific labels.

Example:

```yaml
nodeAffinity:
  requiredDuringSchedulingIgnoredDuringExecution:
```

Suppose worker nodes are labeled as:

```
node1

environment=production

node2

environment=test
```

A production Pod can be configured to run only on production nodes.

Benefits:

- Workload isolation
- Better resource utilization
- Compliance
- Dedicated hardware usage

---

# Q29. Difference between Node Selector and Node Affinity?

## Answer

### Node Selector

- Simple matching
- One label
- Limited flexibility

Example:

```yaml
nodeSelector:
  environment: production
```

### Node Affinity

- Advanced scheduling
- Multiple conditions
- Preferred or mandatory rules
- More expressive

Affinity is generally preferred in production environments.

---

# Q30. What are Taints and Tolerations?

## Answer

Taints prevent Pods from being scheduled onto specific nodes unless those Pods explicitly tolerate the taint.

Think of it as:

```
Node says:

"I do not accept Pods."

↓

Only Pods with matching tolerations can run here.
```

Example taint:

```bash
kubectl taint nodes worker1 dedicated=db:NoSchedule
```

Matching toleration:

```yaml
tolerations:
- key: dedicated
  operator: Equal
  value: db
  effect: NoSchedule
```

---

# Q31. What are the effects of taints?

## Answer

There are three taint effects:

### NoSchedule

New Pods cannot be scheduled.

### PreferNoSchedule

Scheduler tries to avoid the node but may still use it.

### NoExecute

Existing Pods are evicted unless they tolerate the taint.

---

# Q32. What is cordon?

## Answer

Cordoning a node marks it as **unschedulable**.

Existing Pods continue running, but no new Pods are scheduled.

Command:

```bash
kubectl cordon worker-node
```

Use case:

Node maintenance.

---

# Q33. What is drain?

## Answer

Drain safely removes workloads from a node before maintenance.

Command:

```bash
kubectl drain worker-node --ignore-daemonsets
```

Process:

```
Worker Node

↓

Pods Evicted

↓

Node Empty

↓

Maintenance
```

---

# Q34. Difference between cordon and drain?

## Answer

**Cordon**

- Stops new Pods
- Existing Pods continue

**Drain**

- Stops new Pods
- Removes existing Pods

Drain is typically performed before upgrades or maintenance.

---

# Q35. Explain Kubernetes networking.

## Answer

Every Pod receives its own IP address.

Communication types:

```
Pod → Pod

Pod → Service

Service → Pod

Ingress → Service
```

Pods communicate without requiring NAT.

This flat networking model simplifies service communication.

---

# Q36. What is a CNI Plugin?

## Answer

CNI stands for **Container Network Interface**.

It provides networking for Pods.

Popular CNI plugins include:

- Calico
- Flannel
- Cilium
- Weave Net

Without a CNI plugin, Pods cannot communicate across nodes.

---

# Q37. What is a Kubernetes Service?

## Answer

A Service provides a stable endpoint for accessing Pods.

Since Pod IPs change when Pods are recreated, Services expose a consistent virtual IP.

Architecture:

```
Service

      │

      ▼

Pod 1

Pod 2

Pod 3
```

Services automatically load balance requests.

---

# Q38. Explain the different types of Kubernetes Services.

## Answer

### ClusterIP

Internal cluster communication.

### NodePort

Accessible through:

```
NodeIP:Port
```

### LoadBalancer

Creates a cloud load balancer.

### ExternalName

Maps a Service to an external DNS name.

---

# Q39. Which Service type did your project use?

## Answer

Our application was deployed through a Helm chart.

The application Service exposed the Pods internally, while external access was managed through Kubernetes networking and Helm configuration.

The deployment flow was:

```
User

↓

Service

↓

Application Pods
```

---

# Q40. What is CoreDNS?

## Answer

CoreDNS provides internal DNS for Kubernetes.

Example:

Instead of remembering Pod IPs, applications communicate using Service names.

```
database-service

↓

10.96.20.4
```

In one of our earlier KOPS environments, we encountered a **CoreDNS Pending** issue due to insufficient cluster resources. Scaling and resource adjustments resolved the problem.

---

# Q41. What is Ingress?

## Answer

Ingress provides HTTP and HTTPS routing into the cluster.

Instead of exposing every Service individually, Ingress acts as a central entry point.

```
Internet

      │

      ▼

Ingress

      │

      ▼

Service

      │

      ▼

Pods
```

Benefits:

- Host-based routing
- Path-based routing
- SSL termination
- Centralized traffic management

---

# Q42. What is an Ingress Controller?

## Answer

Ingress resources require an Ingress Controller to function.

Popular controllers:

- NGINX Ingress
- AWS Load Balancer Controller
- Traefik
- HAProxy

The controller watches Ingress resources and configures the underlying load balancer or proxy.

---

# Q43. What is a Persistent Volume (PV)?

## Answer

A Persistent Volume is cluster storage independent of Pod lifecycle.

Without PV:

```
Pod Deleted

↓

Data Lost
```

With PV:

```
Pod Deleted

↓

Data Preserved
```

PV provides durable storage for stateful applications.

---

# Q44. What is a Persistent Volume Claim (PVC)?

## Answer

A PVC is a storage request made by a Pod.

Workflow:

```
Application

↓

PVC

↓

Persistent Volume

↓

Storage
```

Developers request storage through PVCs without worrying about the underlying storage implementation.

---

# Q45. What is a StorageClass?

## Answer

A StorageClass enables dynamic provisioning of Persistent Volumes.

Instead of manually creating PVs:

```
PVC Created

↓

StorageClass

↓

Automatic PV Creation
```

This simplifies storage management in cloud environments.

---

# Q46. What is a ConfigMap?

## Answer

ConfigMaps store non-sensitive configuration separately from application code.

Examples:

- Application properties
- Environment variables
- Configuration files

Benefits:

- No image rebuilds
- Centralized configuration
- Easier environment management

---

# Q47. What is a Secret?

## Answer

Secrets store sensitive information securely.

Examples:

- Passwords
- API Keys
- Database credentials
- Tokens

Applications consume Secrets as:

- Environment variables
- Mounted files
- Volumes

Secrets should always be used instead of hardcoding credentials.

---

# Q48. Difference between ConfigMap and Secret?

## Answer

### ConfigMap

Stores non-sensitive data.

Examples:

- URLs
- Feature flags
- Configuration values

### Secret

Stores sensitive information.

Examples:

- Passwords
- Tokens
- Certificates

Using Secrets improves security and reduces accidental exposure of credentials.

---

# Q49. Describe the deployment flow used in your project.

## Answer

The deployment workflow combined GitHub, Jenkins, Docker, Helm, and Kubernetes.

```
Developer

↓

GitHub

↓

Jenkins Pipeline

↓

Maven Build

↓

SonarQube Analysis

↓

Docker Image

↓

Docker Hub

↓

Helm Upgrade

↓

Kubernetes Deployment

↓

ReplicaSet

↓

Pods

↓

Application Running
```

This CI/CD pipeline automated the complete application deployment process.

---

# Q50. What Kubernetes networking and scheduling issues did you troubleshoot during the project?

## Answer

During the project, we encountered and resolved several practical Kubernetes issues:

- CoreDNS remained in Pending due to resource constraints.
- Jenkins deployment initially failed because the KOPS agent was offline.
- The KOPS agent failed to start due to Java 8; upgrading to Java 21 resolved the issue.
- Helm deployment succeeded after the Jenkins agent issue was fixed.
- Pods were successfully updated using `helm upgrade --install`.
- Docker images were pushed to Docker Hub and pulled by Kubernetes.
- Namespace creation and Helm deployments were automated within the Jenkins pipeline.

These troubleshooting exercises provided hands-on experience with Kubernetes operations, scheduling, networking, Helm deployments, and cluster maintenance.

---

End of Chapter-07 (Part-2)

Questions Covered: **26–50**

The next section, **Part-3 (Questions 51–75)**, will focus on:

- Helm Architecture
- Helm Charts
- Templates
- values.yaml
- Helm Upgrade
- Helm Rollback
- KOPS Cluster Architecture
- Rolling Updates
- Scaling
- Resource Requests & Limits
- Liveness & Readiness Probes
- Production deployment strategies
- Real-world troubleshooting scenarios from this project

# Chapter-07-Kubernetes.md
# Part-3

# Helm, KOPS & Production Deployments (Questions 51–75)

---

# Q51. What is Helm?

## Answer

Helm is the package manager for Kubernetes. It simplifies application deployment by packaging all Kubernetes manifests into a reusable unit called a **Chart**.

Instead of applying multiple YAML files individually using `kubectl apply`, Helm deploys the entire application with a single command.

Without Helm:

```
kubectl apply -f deployment.yaml

kubectl apply -f service.yaml

kubectl apply -f configmap.yaml

kubectl apply -f secret.yaml
```

With Helm:

```bash
helm install vprofile-stack helm/vprofilecharts
```

In our project, Jenkins deployed the application using:

```bash
helm upgrade --install vprofile-stack helm/vprofilecharts
```

---

# Q52. Why did you use Helm in your project?

## Answer

Our application consisted of multiple Kubernetes resources.

These included:

- Deployment
- Service
- ConfigMap
- Secret
- Values
- Templates

Managing them manually would have been difficult.

Helm provided:

- Versioning
- Parameterization
- Easy upgrades
- Easy rollback
- Reusable templates
- Environment-specific configurations

Helm became the deployment engine in our CI/CD pipeline.

---

# Q53. What is a Helm Chart?

## Answer

A Helm Chart is a package containing all Kubernetes manifests required to deploy an application.

Typical structure:

```
vprofilecharts/

├── Chart.yaml

├── values.yaml

├── templates/

│     deployment.yaml

│     service.yaml

│     ingress.yaml

│     configmap.yaml

│     secret.yaml

└── charts/
```

In our project, Jenkins deployed this chart automatically.

---

# Q54. Explain the purpose of Chart.yaml.

## Answer

Chart.yaml contains metadata about the Helm Chart.

Example:

```yaml
apiVersion: v2

name: vprofile

version: 1.0.0

description: VProfile Application
```

It identifies the chart version and basic information.

---

# Q55. What is values.yaml?

## Answer

values.yaml stores configurable parameters used by templates.

Example:

```yaml
replicaCount: 2

image:

  repository: aroy0509/vprofileapp

  tag: latest
```

Templates dynamically read these values during deployment.

---

# Q56. Why is values.yaml important?

## Answer

Without values.yaml:

Configuration must be hardcoded.

With values.yaml:

Different environments use different configurations.

Example:

Development

```
replicas = 1
```

Production

```
replicas = 5
```

No template modifications are required.

---

# Q57. What are Helm Templates?

## Answer

Templates are Kubernetes YAML files containing variables.

Example:

```yaml
image:

  repository: {{ .Values.image.repository }}

  tag: {{ .Values.image.tag }}
```

During deployment Helm replaces these placeholders with actual values.

---

# Q58. What command did Jenkins execute to deploy your application?

## Answer

Jenkins executed:

```bash
helm upgrade --install vprofile-stack helm/vprofilecharts \
--namespace prod \
--create-namespace \
--set appimage=aroy0509/vprofileapp:V${BUILD_NUMBER}
```

This command:

- Creates the release if it doesn't exist.
- Upgrades it if it already exists.
- Deploys the latest Docker image.

---

# Q59. Explain the Helm deployment flow in your project.

## Answer

```
GitHub

↓

Jenkins

↓

Docker Build

↓

Docker Hub

↓

Helm Upgrade

↓

Deployment Updated

↓

ReplicaSet

↓

Pods

↓

Application Running
```

Helm was the final deployment stage after the Docker image was published.

---

# Q60. Difference between helm install and helm upgrade?

## Answer

### helm install

Creates a new release.

Example:

```bash
helm install
```

### helm upgrade

Updates an existing release.

Example:

```bash
helm upgrade
```

### helm upgrade --install

If the release exists:

```
Upgrade
```

If not:

```
Install
```

This was the command used in our pipeline.

---

# Q61. What is a Helm Release?

## Answer

A Release is a deployed instance of a Helm Chart.

Example:

```
Chart

↓

Release

↓

Running Application
```

Multiple releases can use the same chart with different configurations.

---

# Q62. How does Helm rollback work?

## Answer

Helm stores deployment history.

View history:

```bash
helm history vprofile-stack
```

Rollback:

```bash
helm rollback vprofile-stack 2
```

This restores a previous deployment version.

---

# Q63. How can you list deployed Helm releases?

## Answer

Command:

```bash
helm list
```

For all namespaces:

```bash
helm list -A
```

Useful information:

- Release Name
- Namespace
- Revision
- Status
- Chart Version

---

# Q64. How do you inspect Helm release history?

## Answer

Command:

```bash
helm history vprofile-stack
```

Sample output:

```
REVISION

1

2

3
```

Each revision represents a deployment.

---

# Q65. What is KOPS?

## Answer

KOPS (Kubernetes Operations) is a tool used to create and manage production-grade Kubernetes clusters on AWS.

It automates:

- EC2 provisioning
- VPC configuration
- IAM setup
- Auto Scaling Groups
- Control Plane
- Worker Nodes

Our project used a KOPS-managed Kubernetes cluster.

---

# Q66. Why did you choose KOPS instead of Minikube?

## Answer

Minikube is suitable for local development.

KOPS provides:

- Multi-node clusters
- Production architecture
- High availability
- Cloud networking
- Persistent infrastructure

Since our goal was to simulate a production deployment, KOPS was the appropriate choice.

---

# Q67. Describe the architecture of your KOPS cluster.

## Answer

```
AWS

│

├── Control Plane

│      kube-apiserver

│      etcd

│      Scheduler

│

├── Worker Node 1

│

├── Worker Node 2

│

└── Worker Node 3
```

Jenkins deployed the application onto this cluster using Helm.

---

# Q68. What was the role of Jenkins in the Kubernetes deployment?

## Answer

Jenkins automated the deployment process.

Pipeline stages:

```
Checkout

↓

Maven Build

↓

Tests

↓

SonarQube

↓

Docker Build

↓

Docker Push

↓

Helm Deployment
```

After a successful build, Helm deployed the updated image.

---

# Q69. Explain Rolling Updates.

## Answer

Rolling Update replaces old Pods gradually without downtime.

Example:

```
Old Pods

↓

One Pod Replaced

↓

Health Check

↓

Next Pod Replaced

↓

Deployment Complete
```

Users experience uninterrupted service.

---

# Q70. What happens during a Helm upgrade?

## Answer

Helm compares:

Current state

vs

Desired state

Only changed resources are updated.

Example:

```
Docker Image

↓

Deployment Updated

↓

New ReplicaSet

↓

New Pods

↓

Old Pods Removed
```

---

# Q71. What is a Rolling Restart?

## Answer

Rolling Restart recreates Pods without changing application configuration.

Command:

```bash
kubectl rollout restart deployment vprofile
```

Pods restart one by one, minimizing downtime.

---

# Q72. Explain ImagePullPolicy.

## Answer

ImagePullPolicy controls when Kubernetes downloads container images.

Options:

### Always

Always pull latest image.

### IfNotPresent

Reuse local image if available.

### Never

Never download images.

In CI/CD pipelines, **Always** is commonly used to ensure new images are deployed.

---

# Q73. How did your application receive the latest Docker image?

## Answer

Jenkins built:

```
aroy0509/vprofileapp:V7
```

Then pushed it to Docker Hub.

Helm updated the deployment using:

```bash
--set appimage=aroy0509/vprofileapp:V7
```

Kubernetes then pulled the latest tagged image and created new Pods.

---

# Q74. What production issues did you encounter during deployment?

## Answer

During this project we solved several real-world deployment problems:

- Jenkins agent offline
- Java 8 incompatible with Jenkins Remoting
- Upgraded KOPS agent to Java 21
- Docker build failure because `openjdk:11` image no longer existed
- Updated Dockerfile to supported base images
- Sonar Quality Gate failure
- Temporarily bypassed Quality Gate for training
- Docker Hub authentication issues
- SSH authentication problems with GitHub
- Helm deployment verification
- Namespace creation
- Agent label mismatch
- Image tag management
- Docker cleanup after deployment

These troubleshooting scenarios closely resemble production support activities.

---

# Q75. Summarize the Kubernetes deployment pipeline used in this project.

## Answer

The complete deployment architecture was:

```
Developer

↓

GitHub Repository

↓

Webhook

↓

Jenkins Pipeline

↓

Checkout Source Code

↓

Maven Build

↓

Unit Test

↓

Integration Test

↓

Checkstyle

↓

SonarQube Analysis

↓

Docker Build

↓

Docker Hub Push

↓

Helm Upgrade

↓

KOPS Cluster

↓

Deployment

↓

ReplicaSet

↓

Pods

↓

Running Application
```

This pipeline automated the entire software delivery lifecycle—from source code commit to a running application on a production-style Kubernetes cluster. It demonstrated practical use of CI/CD, containerization, Kubernetes orchestration, Helm package management, and AWS infrastructure, closely matching real-world enterprise deployment workflows.

---

End of Chapter-07 (Part-3)

Questions Covered: **51–75**

Next: **Part-4 (Questions 76–100)**

Topics include:

- Resource Requests & Limits
- Liveness Probes
- Readiness Probes
- Startup Probes
- Horizontal Pod Autoscaler (HPA)
- Cluster Autoscaler
- RBAC
- Service Accounts
- Network Policies
- Kubernetes Security
- Monitoring
- Logging
- Disaster Recovery
- Production Best Practices
- Advanced FAANG-Level Kubernetes Design Questions
# Chapter-07-Kubernetes.md
# Part-4

# Kubernetes Security, Monitoring & Production Best Practices (Questions 76–100)

---

# Q76. What are Resource Requests in Kubernetes?

## Answer

Resource Requests define the minimum CPU and memory required by a container.

Example:

```yaml
resources:
  requests:
    cpu: "250m"
    memory: "256Mi"
```

The scheduler uses these values to decide where a Pod can run.

Benefits:

- Prevents resource starvation
- Improves scheduling
- Ensures application stability

---

# Q77. What are Resource Limits?

## Answer

Resource Limits define the maximum CPU and memory a container can consume.

Example:

```yaml
resources:
  limits:
    cpu: "1000m"
    memory: "1Gi"
```

If the container exceeds:

- CPU → it is throttled.
- Memory → it may be terminated (OOMKilled).

---

# Q78. Difference between Requests and Limits?

## Answer

**Requests**

- Minimum guaranteed resources.
- Used by the scheduler.

**Limits**

- Maximum allowed resources.
- Enforced by Kubernetes.

Example:

```
Request:
CPU = 250m

Limit:
CPU = 1000m
```

---

# Q79. What is a Liveness Probe?

## Answer

A Liveness Probe determines whether an application is still running correctly.

If the probe fails repeatedly, Kubernetes automatically restarts the container.

Example:

```yaml
livenessProbe:
  httpGet:
    path: /
    port: 8080
```

Benefits:

- Automatic recovery
- Eliminates manual intervention
- Improves application availability

---

# Q80. What is a Readiness Probe?

## Answer

A Readiness Probe checks whether a container is ready to receive user traffic.

If the probe fails:

- The Pod continues running.
- The Service temporarily removes it from load balancing.

Example:

```yaml
readinessProbe:
  httpGet:
    path: /
    port: 8080
```

This prevents users from accessing an application before it is fully initialized.

---

# Q81. Difference between Liveness and Readiness Probes?

## Answer

### Liveness Probe

- Checks whether the application is alive.
- Failure results in container restart.

### Readiness Probe

- Checks whether the application is ready.
- Failure removes the Pod from the Service without restarting it.

Both probes are commonly used together in production deployments.

---

# Q82. What is a Startup Probe?

## Answer

Some applications require significant startup time.

A Startup Probe allows Kubernetes to wait until the application has fully started before running liveness or readiness checks.

Benefits:

- Prevents premature restarts.
- Useful for Java or Spring Boot applications.
- Improves stability during startup.

---

# Q83. What is Horizontal Pod Autoscaler (HPA)?

## Answer

The Horizontal Pod Autoscaler automatically adjusts the number of Pods based on resource utilization.

Example:

```
CPU > 70%

↓

Increase Pods

↓

Traffic Reduced

↓

Decrease Pods
```

Typical command:

```bash
kubectl autoscale deployment vprofile --cpu-percent=70 --min=2 --max=10
```

---

# Q84. What is Cluster Autoscaler?

## Answer

Cluster Autoscaler automatically adds or removes worker nodes based on workload demand.

Workflow:

```
Pods Pending

↓

Add Worker Node

↓

Schedule Pods

↓

Traffic Drops

↓

Remove Unused Node
```

This helps optimize infrastructure costs and cluster capacity.

---

# Q85. What is RBAC?

## Answer

RBAC stands for **Role-Based Access Control**.

It controls who can perform specific actions within the Kubernetes cluster.

Components:

- Role
- ClusterRole
- RoleBinding
- ClusterRoleBinding

RBAC enhances cluster security by enforcing the principle of least privilege.

---

# Q86. What is the difference between Role and ClusterRole?

## Answer

**Role**

- Namespace-scoped.
- Permissions apply only within a specific namespace.

**ClusterRole**

- Cluster-wide.
- Permissions apply across all namespaces.

Use Roles for application teams and ClusterRoles for administrators.

---

# Q87. What is a Service Account?

## Answer

A Service Account provides an identity for Pods.

Instead of using human user credentials, applications authenticate to the Kubernetes API using Service Accounts.

Example:

```
Application Pod

↓

Service Account

↓

Kubernetes API
```

This is the recommended authentication method for workloads.

---

# Q88. What are Network Policies?

## Answer

Network Policies define which Pods may communicate with each other.

Without Network Policies:

```
Every Pod

↓

Can communicate with every other Pod
```

With Network Policies:

```
Only approved traffic is allowed.
```

They provide micro-segmentation and improve cluster security.

---

# Q89. How should Secrets be managed in production?

## Answer

Production best practices include:

- Never hardcode passwords.
- Store credentials in Kubernetes Secrets.
- Encrypt Secrets at rest.
- Rotate credentials regularly.
- Restrict access using RBAC.

Examples of Secrets:

- Database passwords
- API tokens
- TLS certificates
- SSH keys

---

# Q90. How can Kubernetes applications be monitored?

## Answer

Common monitoring stack:

```
Application

↓

Prometheus

↓

Metrics

↓

Grafana Dashboard
```

Metrics collected include:

- CPU utilization
- Memory utilization
- Pod status
- Node health
- Network traffic

Monitoring enables proactive issue detection.

---

# Q91. How can Kubernetes logs be collected?

## Answer

Basic logging:

```bash
kubectl logs pod-name
```

Production logging stack:

```
Pods

↓

Fluent Bit / Fluentd

↓

Elasticsearch

↓

Kibana
```

Centralized logging simplifies troubleshooting across multiple Pods.

---

# Q92. How do you troubleshoot a Pod that is not starting?

## Answer

Typical troubleshooting steps:

Check Pod status:

```bash
kubectl get pods
```

Describe the Pod:

```bash
kubectl describe pod pod-name
```

Check logs:

```bash
kubectl logs pod-name
```

Verify:

- Image availability
- Events
- Resource limits
- Secrets
- ConfigMaps
- Node health

These commands usually identify the root cause.

---

# Q93. What production issues did you resolve during this Kubernetes project?

## Answer

During this project, we encountered and resolved several real-world issues:

- Jenkins KOPS agent remained offline.
- Jenkins Remoting failed because Java 8 was installed.
- Upgraded the agent to Java 21.
- GitHub SSH authentication issues.
- Docker build failed due to deprecated base image.
- Updated Dockerfile to supported OpenJDK/Tomcat images.
- SonarQube Quality Gate blocked the pipeline.
- Modified the training pipeline to continue after Sonar analysis.
- Docker Hub authentication configuration.
- Successful Helm deployment after infrastructure fixes.
- Deployment verification using Helm releases.

These scenarios closely resemble enterprise production troubleshooting.

---

# Q94. What Kubernetes commands did you frequently use?

## Answer

Some commonly used commands include:

```bash
kubectl get pods

kubectl get nodes

kubectl get svc

kubectl describe pod pod-name

kubectl logs pod-name

kubectl exec -it pod-name -- bash

kubectl delete pod pod-name

kubectl rollout restart deployment deployment-name

kubectl get events

kubectl top pods

kubectl top nodes
```

These commands are essential for day-to-day Kubernetes administration.

---

# Q95. How would you make this Kubernetes deployment production-ready?

## Answer

Enhancements include:

- Multiple worker nodes
- High Availability control plane
- Horizontal Pod Autoscaler
- Cluster Autoscaler
- Resource Requests & Limits
- Liveness and Readiness Probes
- RBAC
- Network Policies
- TLS/HTTPS
- External Secrets Management
- Monitoring with Prometheus
- Logging with EFK/Loki
- Backup and Disaster Recovery
- GitOps using ArgoCD or Flux

---

# Q96. How would you secure this Kubernetes cluster?

## Answer

Recommended security measures:

- Enable RBAC
- Use Namespaces for isolation
- Apply Network Policies
- Restrict Service Accounts
- Scan Docker images
- Keep Kubernetes updated
- Store secrets securely
- Enable audit logging
- Use Pod Security Standards
- Apply least-privilege access

Security should be implemented at every layer of the cluster.

---

# Q97. Explain the complete CI/CD workflow of your project.

## Answer

```
Developer

↓

GitHub

↓

Webhook

↓

Jenkins

↓

Checkout

↓

Maven Build

↓

Testing

↓

Checkstyle

↓

SonarQube

↓

Docker Build

↓

Docker Hub

↓

Helm Upgrade

↓

KOPS Kubernetes Cluster

↓

Deployment

↓

ReplicaSet

↓

Pods

↓

Running Application
```

This workflow automated software delivery from source code commit to deployment.

---

# Q98. If this application suddenly becomes unavailable, how would you troubleshoot it?

## Answer

A structured troubleshooting approach:

1. Check Jenkins deployment history.
2. Verify Helm release status.
3. Check Deployment status.
4. Verify Pod health.
5. Inspect Pod logs.
6. Confirm Service configuration.
7. Verify Endpoints.
8. Check Ingress.
9. Verify Node health.
10. Review cluster Events.

Commands:

```bash
helm list

kubectl get deployments

kubectl get pods

kubectl logs

kubectl describe

kubectl get svc

kubectl get ingress

kubectl get events
```

This systematic approach minimizes downtime.

---

# Q99. If asked to explain your Kubernetes project in an interview, what would you say?

## Answer

"I developed a complete CI/CD pipeline where application code was stored in GitHub. Jenkins automatically built the project using Maven, executed unit and integration tests, performed static code analysis using Checkstyle and SonarQube, built a Docker image, pushed it to Docker Hub, and finally deployed the latest version to a KOPS-based Kubernetes cluster using Helm.

During the project, I resolved several production-like issues including Java compatibility on Jenkins agents, Docker image build failures, SonarQube Quality Gate failures, GitHub authentication problems, and Helm deployment troubleshooting. This project provided practical experience across the entire DevOps lifecycle from code commit to Kubernetes deployment."

---

# Q100. What were your biggest learnings from this Kubernetes project?

## Answer

This project provided hands-on experience with:

- Kubernetes architecture
- KOPS cluster administration
- Helm package management
- Docker image lifecycle
- Jenkins CI/CD pipelines
- Maven build automation
- SonarQube integration
- Production deployment strategies
- Troubleshooting real deployment failures
- AWS infrastructure
- CI/CD automation
- Kubernetes operations
- Cluster administration
- Infrastructure debugging
- End-to-end DevOps workflows

More importantly, it demonstrated how multiple DevOps tools integrate to automate software delivery in a production-style environment.

---

# End of Chapter-07

## Questions Covered

Questions **1–100**

This chapter covered:

- Kubernetes Fundamentals
- Scheduling
- Networking
- Storage
- Services
- Ingress
- CoreDNS
- ConfigMaps
- Secrets
- Helm
- KOPS
- CI/CD Integration
- Rolling Updates
- Resource Management
- Probes
- Autoscaling
- RBAC
- Security
- Monitoring
- Logging
- Production Best Practices
- Real-world troubleshooting
- Enterprise deployment architecture

This completes the Kubernetes chapter of your interview guide and provides a strong foundation for discussing real-world Kubernetes deployments in technical interviews.
