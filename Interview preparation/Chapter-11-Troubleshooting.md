# Chapter-11-Troubleshooting.md
# Part-1

# Linux, Git & Jenkins Troubleshooting (Questions 1–25)

---

# Q1. Your Jenkins pipeline suddenly fails. What is your first troubleshooting step?

## Answer

The first step is **not to guess** the cause.

Instead, follow a structured troubleshooting approach.

Step 1

Check the Jenkins Console Output.

```
Pipeline

↓

Failed Stage

↓

Console Output

↓

Error Message

↓

Root Cause
```

Console logs usually reveal:

- Missing files
- Authentication errors
- Java exceptions
- Docker failures
- Network issues
- Permission errors

Never start changing configurations until the actual error has been identified.

---

# Q2. One of your Jenkins stages is stuck forever. How do you troubleshoot it?

## Answer

Possible reasons include:

- Offline Jenkins Agent
- Waiting for Executor
- Deadlock
- Network issue
- Long-running process

Checklist

```
Check Build Queue

↓

Check Jenkins Agent

↓

Check Executor Availability

↓

Review Console Logs

↓

Review System Logs
```

In our project, the deployment stage was stuck because:

```
Still waiting to schedule task

'kops' is offline
```

The deployment agent had gone offline.

---

# Q3. Your Jenkins agent is offline. How do you troubleshoot it?

## Answer

Start with basic connectivity.

Step 1

```
Ping Agent
```

Step 2

```
SSH into Agent
```

Step 3

Check Java

```
java -version
```

Step 4

Verify Jenkins Agent

```
ps -ef | grep remoting
```

Step 5

Restart Agent

Common causes:

- Java mismatch
- SSH failure
- Wrong credentials
- Network problem
- Agent process stopped

---

# Q4. Your Jenkins agent shows "UnsupportedClassVersionError". What does it mean?

## Answer

This happened in our project.

Error:

```
UnsupportedClassVersionError
```

Meaning:

The application was compiled using a newer Java version than the runtime.

Example:

```
Jenkins Agent

↓

Java 8

↓

Remoting.jar

↓

Requires Java 17+

↓

Failure
```

Resolution

Install Java 21

```
sudo apt install openjdk-21-jdk
```

Update alternatives

```
sudo update-alternatives --config java

sudo update-alternatives --config javac
```

Verify

```
java -version
```

After upgrading to Java 21, the agent connected successfully.

---

# Q5. How did you troubleshoot the Java compatibility issue in your project?

## Answer

Observed error:

```
UnsupportedClassVersionError
```

Verification:

```
java -version
```

Output showed:

```
Java 8
```

Jenkins Remoting required:

```
Java 17+
```

Resolution:

- Installed Java 21
- Changed Java alternatives
- Restarted Jenkins Agent

Problem solved.

---

# Q6. Jenkins cannot clone the GitHub repository. How do you troubleshoot?

## Answer

Check:

- Repository URL
- Internet connectivity
- Credentials
- SSH Keys
- Git installation

Commands:

```
git --version

ssh -T git@github.com
```

Typical causes:

- Invalid SSH key
- Wrong repository URL
- Missing credentials
- Repository permissions

---

# Q7. SSH authentication to GitHub fails. What do you check?

## Answer

Verify:

```
~/.ssh
```

Check keys

```
ls ~/.ssh
```

Test connection

```
ssh -T git@github.com
```

Verify config

```
cat ~/.ssh/config
```

In our project, multiple SSH keys existed.

The SSH configuration had to be cleaned up to ensure GitHub used the correct private key.

---

# Q8. How do you troubleshoot Git conflicts during pipeline execution?

## Answer

Possible issues:

```
Local Changes

↓

Merge Conflict

↓

Pipeline Failure
```

Resolution:

```
git status

git fetch

git pull

git reset --hard origin/main
```

Always ensure the workspace contains a clean copy before building.

---

# Q9. Jenkins reports "workspace not clean." What do you do?

## Answer

Workspace corruption can happen after failed builds.

Solutions:

```
Clean Workspace Plugin
```

or

```
Delete Workspace
```

or

```
cleanWs()
```

inside the Jenkins Pipeline.

Our project automatically cleaned the workspace after successful builds.

---

# Q10. Jenkins cannot find Git. How do you troubleshoot?

## Answer

Check installation.

```
git --version
```

Check path.

```
which git
```

Verify Jenkins Tool Configuration.

Sometimes the Jenkins configuration references a non-existent Git installation.

---

# Q11. Jenkins build fails because Java is missing. What do you do?

## Answer

Verify Java.

```
java -version
```

Install Java if missing.

Ubuntu

```
sudo apt install openjdk-21-jdk
```

Configure alternatives.

```
sudo update-alternatives --config java
```

Verify

```
javac -version
```

---

# Q12. Jenkins service refuses to start. How do you troubleshoot?

## Answer

Check service status.

```
sudo systemctl status jenkins
```

View logs.

```
journalctl -u jenkins
```

Check:

- Java version
- Port conflicts
- Disk space
- Memory
- Permissions

---

# Q13. Jenkins UI is inaccessible. What could be wrong?

## Answer

Possible causes:

- Jenkins stopped
- Port 8080 blocked
- Security Group issue
- Firewall
- Reverse proxy failure

Verification:

```
systemctl status jenkins
```

Check port.

```
ss -tulpn
```

Check EC2 Security Group.

---

# Q14. Your EC2 disk becomes full. How do you troubleshoot?

## Answer

Check disk usage.

```
df -h
```

Find large directories.

```
du -sh *
```

Common consumers:

- Docker images
- Jenkins workspace
- Maven repository
- Logs

Our Jenkins server required an EBS volume expansion during the project because Docker images and build artifacts exhausted available storage.

---

# Q15. How did you increase disk space in your project?

## Answer

Steps:

1. Increase EBS volume in AWS.
2. Extend partition.

```
growpart
```

3. Resize filesystem.

```
resize2fs
```

Verify

```
df -h
```

This expanded storage without rebuilding the server.

---

# Q16. SSH to an EC2 instance fails. What should you check?

## Answer

Verify:

- Security Group
- Key Pair
- Public IP
- Instance state
- SSH service

Commands:

```
systemctl status ssh
```

Port

```
22
```

must be open.

---

# Q17. Jenkins build suddenly becomes very slow. How do you investigate?

## Answer

Possible reasons:

- High CPU
- Memory exhaustion
- Disk full
- Too many executors
- Network latency

Useful commands:

```
top

free -h

df -h
```

Our Jenkins instance was upgraded to a larger EC2 instance after performance degradation.

---

# Q18. Linux package installation fails. How do you troubleshoot?

## Answer

Update repositories.

```
sudo apt update
```

Check internet connectivity.

Verify package name.

Review error messages carefully.

Sometimes repositories need refreshing before installation.

---

# Q19. A Linux command returns "Permission denied." What does it mean?

## Answer

Possible reasons:

- Missing execute permission
- Wrong ownership
- Root privileges required

Commands:

```
ls -l

chmod +x

sudo
```

Always verify permissions before changing ownership.

---

# Q20. How do you identify high CPU usage on Linux?

## Answer

Commands:

```
top
```

or

```
htop
```

or

```
ps -ef
```

Identify the process consuming CPU before taking action.

---

# Q21. How do you identify memory issues?

## Answer

Commands:

```
free -h
```

```
vmstat
```

```
top
```

Look for:

- Low available memory
- High swap usage
- Out-of-memory events

---

# Q22. Why is checking logs the most important troubleshooting step?

## Answer

Logs provide factual evidence.

Instead of guessing:

```
Problem

↓

Logs

↓

Evidence

↓

Root Cause

↓

Fix
```

Useful logs:

- Jenkins Console Output
- System Logs
- Application Logs
- Docker Logs
- Kubernetes Logs

---

# Q23. Describe a real troubleshooting issue you solved during this project.

## Answer

Problem:

The Kubernetes deployment stage remained pending.

Message:

```
Still waiting to schedule task

'kops' is offline
```

Investigation:

- Verified SSH connectivity.
- Reviewed Jenkins agent logs.
- Found `UnsupportedClassVersionError`.
- Checked Java version.
- Identified Java 8 on the deployment agent.

Resolution:

- Installed Java 21.
- Updated Java alternatives.
- Restarted the Jenkins agent.

The deployment completed successfully.

---

# Q24. What troubleshooting methodology do you follow?

## Answer

I use a structured process:

```
Identify Problem

↓

Collect Logs

↓

Reproduce Issue

↓

Find Root Cause

↓

Apply Fix

↓

Validate Solution

↓

Document Lessons Learned
```

This avoids unnecessary changes and makes troubleshooting repeatable.

---

# Q25. What were the most important Linux, Git, and Jenkins troubleshooting lessons from this project?

## Answer

Key lessons:

- Always start with logs.
- Verify Java versions before troubleshooting Jenkins agents.
- Keep Git workspaces clean.
- Validate SSH connectivity before deployment.
- Monitor disk usage proactively.
- Separate Jenkins Controller and Agents.
- Use version-controlled pipeline definitions.
- Document every issue and its resolution.

These practical experiences significantly strengthened my understanding of CI/CD operations and production troubleshooting.

---

# End of Part-1

## Questions Covered

**Questions 1–25**

Next:

**Part-2 (Questions 26–50): Maven, SonarQube & Docker Troubleshooting**

Topics include:

- Maven build failures
- Dependency resolution issues
- Java compatibility
- SonarQube authentication
- Quality Gate failures
- Docker build errors
- Docker Hub authentication
- Image optimization
- Multi-stage Docker troubleshooting
- Real issues encountered in this project

- # Chapter-11-Troubleshooting.md
# Part-2

# Maven, SonarQube & Docker Troubleshooting (Questions 26–50)

---

# Q26. Maven build fails with "Could not resolve dependencies." How do you troubleshoot?

## Answer

This error usually indicates that Maven cannot download one or more required dependencies.

Common causes:

- Internet connectivity issue
- Incorrect repository URL
- Corrupted local Maven cache
- Missing dependency version
- Proxy or firewall restrictions

Troubleshooting steps:

```
Check Internet

↓

Verify pom.xml

↓

Check Maven Repository

↓

Clean Local Cache

↓

Rebuild Project
```

Useful commands:

```bash
mvn clean install

mvn dependency:tree
```

If the local cache is corrupted:

```bash
rm -rf ~/.m2/repository
```

Then rebuild the project.

---

# Q27. Maven build fails after updating Java. What should you check?

## Answer

Verify that Maven is using the expected Java version.

Commands:

```bash
java -version

javac -version

mvn -version
```

Example output:

```
Java 21

Maven 3.9.x
```

If Maven still uses Java 8, update:

```
JAVA_HOME
```

and verify:

```bash
echo $JAVA_HOME
```

This issue frequently occurs after upgrading Java.

---

# Q28. Maven reports "Compilation Failure." How do you troubleshoot?

## Answer

Compilation failures usually indicate source code problems.

Possible causes:

- Syntax errors
- Missing imports
- Incorrect Java version
- Missing dependencies

Approach:

```
Compilation Error

↓

Read Exact Line Number

↓

Open Source File

↓

Correct Code

↓

Rebuild
```

Never ignore compiler messages—they usually identify the precise location of the problem.

---

# Q29. Maven tests are failing. How do you investigate?

## Answer

Run the tests separately.

```bash
mvn test
```

Review:

- Stack trace
- Failed assertions
- Test reports

Check reports:

```
target/surefire-reports
```

Determine whether the issue is:

- Application bug
- Test bug
- Environment problem

---

# Q30. Maven build is very slow. How can it be optimized?

## Answer

Optimization techniques:

- Enable dependency caching
- Parallel builds
- Incremental builds
- Faster SSD storage
- Reduce unnecessary plugins
- Build only affected modules

Useful command:

```bash
mvn -T 1C clean install
```

This uses one thread per available CPU core.

---

# Q31. SonarQube scanner reports "Not Authorized." How do you troubleshoot?

## Answer

Possible causes:

- Invalid token
- Incorrect project key
- Wrong organization
- Expired credentials

Checklist:

```
Verify Token

↓

Verify URL

↓

Verify Project Key

↓

Verify Organization
```

In earlier project work, authentication mismatches between the project and token caused this error.

---

# Q32. SonarQube analysis succeeds, but the Quality Gate fails. What does this mean?

## Answer

The scan completed successfully, but the project did not meet predefined quality standards.

Possible reasons:

- High code duplication
- Low test coverage
- Security vulnerabilities
- Too many bugs
- Excessive code smells

Pipeline:

```
Build

↓

Sonar Analysis

↓

Quality Gate

↓

Pass / Fail
```

The code should be improved rather than bypassing the Quality Gate in production.

---

# Q33. SonarQube reports "Project not found." How do you troubleshoot?

## Answer

Verify:

- Project key
- Organization
- Sonar URL
- Authentication token

Compare:

```
sonar-project.properties
```

with the project configured in SonarQube.

A small mismatch in the project key is often enough to trigger this error.

---

# Q34. SonarQube analysis is extremely slow. What could be the reasons?

## Answer

Possible causes:

- Large codebase
- Low system memory
- Slow disk
- Heavy plugin processing
- Network latency

Investigate:

```
CPU

↓

Memory

↓

Disk

↓

Network

↓

Scanner Logs
```

Optimize the server before increasing hardware.

---

# Q35. Docker build fails immediately. How do you troubleshoot?

## Answer

First identify which build step failed.

Run:

```bash
docker build .
```

Review:

- Build context
- Dockerfile syntax
- Missing files
- Invalid COPY commands
- Base image availability

Never modify multiple things at once.

---

# Q36. Docker reports "COPY failed." What usually causes this?

## Answer

Common causes:

- File does not exist
- Wrong relative path
- Incorrect build context
- Typographical error

Example:

```
COPY app.war /usr/local/tomcat/webapps/
```

Verify the file actually exists before running the build.

---

# Q37. Docker cannot pull the base image. How do you troubleshoot?

## Answer

Check:

- Internet connectivity
- Docker Hub availability
- Image name
- Image tag

Example:

```bash
docker pull eclipse-temurin:21-jdk
```

If the image does not exist, select a supported tag.

---

# Q38. Your Docker image becomes excessively large. How do you optimize it?

## Answer

Techniques:

- Multi-stage builds
- Smaller base images
- Remove temporary files
- Combine RUN commands
- Clean package cache

Example:

```
Build Stage

↓

Copy Artifacts

↓

Runtime Image
```

Only the runtime artifacts should be included in the final image.

---

# Q39. Docker build fails because Java is missing inside the container. How do you troubleshoot?

## Answer

Verify the base image.

Example:

```dockerfile
FROM eclipse-temurin:21-jdk
```

Avoid using images that do not contain the required Java runtime.

Inspect the image:

```bash
docker run --rm image_name java -version
```

---

# Q40. Docker login fails. How do you investigate?

## Answer

Verify:

```bash
docker login
```

Check:

- Username
- Password or access token
- Internet connectivity
- Registry availability

For CI/CD pipelines, credentials should be stored securely in Jenkins Credentials rather than hardcoded.

---

# Q41. Docker push to Docker Hub fails. What should you check?

## Answer

Possible causes:

- Authentication failure
- Repository does not exist
- Wrong repository name
- Network interruption

Verify:

```bash
docker images

docker login

docker push repository/image:tag
```

Confirm that the repository exists before pushing.

---

# Q42. Docker reports "Image not found." How do you troubleshoot?

## Answer

List available images:

```bash
docker images
```

Verify:

- Repository name
- Tag
- Build success

If the image was never created, rebuild it before pushing.

---

# Q43. Why should Docker images be tagged with versions?

## Answer

Example:

```
v5

↓

v6

↓

v7

↓

latest
```

Benefits:

- Easier rollback
- Release tracking
- Repeatable deployments
- Better debugging

Version tags should always accompany the `latest` tag.

---

# Q44. Your Docker container exits immediately after starting. What do you check?

## Answer

Inspect logs:

```bash
docker logs container_id
```

Verify:

- Startup command
- Application errors
- Missing configuration
- Port conflicts

Container logs usually reveal the exact reason for termination.

---

# Q45. Docker container is running, but the application is unreachable. How do you troubleshoot?

## Answer

Verify:

- Container status

```bash
docker ps
```

- Port mapping

```bash
docker port container_id
```

- Application listening port
- Firewall rules

Confirm that the application is listening on the expected interface.

---

# Q46. How do you inspect a running Docker container?

## Answer

Useful commands:

```bash
docker exec -it container_id bash
```

or

```bash
docker exec -it container_id sh
```

Then inspect:

- Files
- Logs
- Environment variables
- Running processes

This is one of the fastest ways to diagnose container issues.

---

# Q47. How do you clean up unused Docker resources?

## Answer

Useful commands:

```bash
docker image prune
```

or

```bash
docker system prune
```

or

```bash
docker system prune -a
```

Be cautious, as these commands remove unused resources.

---

# Q48. Describe a real Docker troubleshooting issue from your project.

## Answer

During the project, the Docker build failed because the selected Java image was incompatible with the application's requirements.

Investigation:

```
Docker Build

↓

Image Pull

↓

Build Failure

↓

Review Dockerfile

↓

Verify Base Image
```

Resolution:

- Updated the Dockerfile to use a supported Java 21 base image.
- Rebuilt the image.
- Successfully pushed the versioned image to Docker Hub.

This resolved the pipeline failure.

---

# Q49. What troubleshooting methodology do you follow for Maven, SonarQube, and Docker issues?

## Answer

I follow a structured process:

```
Read Error

↓

Verify Configuration

↓

Check Logs

↓

Validate Dependencies

↓

Reproduce Issue

↓

Apply Minimal Fix

↓

Retest

↓

Document Resolution
```

This approach avoids unnecessary changes and ensures the true root cause is identified.

---

# Q50. What were the biggest Maven, SonarQube, and Docker lessons from this project?

## Answer

Key lessons learned:

- Always verify the Java version used by Maven.
- Keep `JAVA_HOME` consistent across build servers.
- Read Maven compiler errors carefully before making changes.
- Secure SonarQube authentication tokens.
- Treat Quality Gate failures as quality improvements, not obstacles.
- Use optimized, supported Docker base images.
- Version every Docker image.
- Store registry credentials securely.
- Review Docker build logs step by step.
- Document every issue and its resolution for future reference.

These experiences strengthened my understanding of enterprise CI/CD troubleshooting and prepared me for real-world production support scenarios.

---

# End of Part-2

## Questions Covered

**Questions 26–50**

Next:

**Part-3 (Questions 51–75): Kubernetes, Helm & AWS Troubleshooting**

Topics include:

- Pod failures
- CrashLoopBackOff
- ImagePullBackOff
- Pending Pods
- Helm upgrade failures
- Helm rollback
- KOPS troubleshooting
- EC2 issues
- IAM problems
- Security Groups
- Jenkins deployment agent troubleshooting
- Real production issues from this project
# Chapter-11-Troubleshooting.md
# Part-3

# Kubernetes, Helm & AWS Troubleshooting (Questions 51–75)

---

# Q51. A Kubernetes Pod is stuck in the Pending state. How do you troubleshoot it?

## Answer

A Pod remains in the **Pending** state when Kubernetes cannot schedule it onto a worker node.

Common causes:

- Insufficient CPU
- Insufficient Memory
- No available nodes
- PVC not bound
- Taints and tolerations
- Node selector mismatch

Troubleshooting process:

```
Pod Pending

↓

kubectl describe pod

↓

Scheduler Events

↓

Identify Root Cause

↓

Apply Fix
```

Useful commands:

```bash
kubectl get pods

kubectl describe pod <pod-name>

kubectl get nodes
```

---

# Q52. What is CrashLoopBackOff, and how do you troubleshoot it?

## Answer

CrashLoopBackOff means that Kubernetes repeatedly starts the container, but the application crashes shortly after startup.

Workflow:

```
Container Starts

↓

Application Crashes

↓

Restart

↓

Crash Again

↓

CrashLoopBackOff
```

Investigation:

```bash
kubectl logs <pod-name>

kubectl describe pod <pod-name>
```

Common causes:

- Application exception
- Incorrect environment variables
- Database connection failure
- Missing configuration
- Incorrect startup command

---

# Q53. What is ImagePullBackOff?

## Answer

ImagePullBackOff occurs when Kubernetes cannot download the Docker image.

Possible causes:

- Incorrect image name
- Wrong image tag
- Private registry authentication failure
- Docker Hub unavailable
- Network issue

Verify:

```bash
kubectl describe pod <pod-name>
```

Example event:

```
Failed to pull image

↓

ImagePullBackOff
```

---

# Q54. Pods are running, but the application is inaccessible. What do you check?

## Answer

Investigate the networking components.

```
Pod

↓

Service

↓

Ingress

↓

Load Balancer

↓

User
```

Commands:

```bash
kubectl get svc

kubectl get ingress

kubectl describe svc

kubectl describe ingress
```

Verify:

- Service selector
- TargetPort
- Port
- Endpoints
- DNS

---

# Q55. How do you troubleshoot Kubernetes Services?

## Answer

Check whether the Service has active endpoints.

Commands:

```bash
kubectl get svc

kubectl describe svc

kubectl get endpoints
```

If the endpoint list is empty, the Service selector probably does not match the Pod labels.

---

# Q56. Pods are restarting continuously. What should you investigate?

## Answer

Check:

- Application logs
- Liveness probe
- Readiness probe
- Resource limits
- OOMKilled events

Commands:

```bash
kubectl logs

kubectl describe pod
```

Review restart count:

```bash
kubectl get pods
```

---

# Q57. What is OOMKilled?

## Answer

OOMKilled means the container exceeded its allocated memory.

Example:

```
Application

↓

Memory Usage

↓

Memory Limit Exceeded

↓

OOMKilled

↓

Restart
```

Resolution:

Increase memory limits or optimize the application.

---

# Q58. Helm upgrade fails. How do you troubleshoot?

## Answer

Check:

```bash
helm list

helm status <release>

helm history <release>
```

Review Kubernetes events.

Validate templates.

```bash
helm lint

helm template
```

Fix configuration errors before upgrading.

---

# Q59. How do you validate a Helm chart before deployment?

## Answer

Use:

```bash
helm lint

helm template
```

These commands validate:

- YAML syntax
- Template rendering
- Missing values
- Invalid manifests

Always validate locally before deploying to Kubernetes.

---

# Q60. How do you roll back a failed Helm deployment?

## Answer

View revision history:

```bash
helm history vprofile-stack
```

Rollback:

```bash
helm rollback vprofile-stack 2
```

Workflow:

```
Revision 1

↓

Revision 2

↓

Revision 3 (Failed)

↓

Rollback

↓

Revision 2
```

---

# Q61. Describe a Helm issue you encountered during this project.

## Answer

Initially, Helm deployments failed because the deployment agent was offline.

Console output:

```
Still waiting to schedule task

'kops' is offline
```

Investigation showed that the Jenkins deployment agent could not start because it was running Java 8 while Jenkins Remoting required Java 17 or later.

After installing Java 21 and restarting the agent, the Helm deployment completed successfully.

---

# Q62. Kubernetes deployment succeeds, but Pods never become Ready. What do you do?

## Answer

Check:

```bash
kubectl describe pod

kubectl logs
```

Investigate:

- Readiness probe
- Startup time
- Configuration
- Database connectivity
- Application logs

A Pod that never becomes Ready does not receive traffic.

---

# Q63. kubectl cannot connect to the cluster. How do you troubleshoot?

## Answer

Verify:

```bash
kubectl cluster-info

kubectl config current-context

kubectl get nodes
```

Possible causes:

- Invalid kubeconfig
- Expired credentials
- Cluster unavailable
- Network connectivity

---

# Q64. Worker Nodes show NotReady. What should you investigate?

## Answer

Possible reasons:

- kubelet stopped
- Network failure
- Disk pressure
- Memory pressure
- Node reboot

Commands:

```bash
kubectl get nodes

kubectl describe node

systemctl status kubelet
```

---

# Q65. How do you troubleshoot Ingress issues?

## Answer

Verify:

```bash
kubectl get ingress

kubectl describe ingress
```

Check:

- DNS
- Ingress Controller
- Backend Service
- TLS
- Load Balancer

Request flow:

```
DNS

↓

Ingress

↓

Service

↓

Pod
```

---

# Q66. Describe an AWS issue you encountered during this project.

## Answer

One practical issue involved insufficient EC2 disk space on the Jenkins server.

Symptoms:

- Docker builds failed
- Workspace filled rapidly
- Pipeline instability

Resolution:

1. Increased the EBS volume.
2. Extended the partition.
3. Resized the filesystem.
4. Verified available disk space.

Commands:

```bash
df -h

growpart

resize2fs
```

This restored normal pipeline operation.

---

# Q67. An EC2 instance cannot be accessed using SSH. What do you check?

## Answer

Verify:

- Security Group
- Port 22
- Public IP
- Key Pair
- Instance status

Commands:

```bash
ping

ssh

systemctl status ssh
```

Network access should always be verified before assuming an application issue.

---

# Q68. Your application cannot communicate with AWS services. What do you investigate?

## Answer

Check:

- IAM Role
- IAM Policy
- AWS Credentials
- Region
- Network

Commands:

```bash
aws sts get-caller-identity
```

Verify that the EC2 instance has the appropriate IAM permissions.

---

# Q69. Security Group configuration appears correct, but the application is still unreachable. What else should you verify?

## Answer

Check:

- Network ACLs
- Route Tables
- Internet Gateway
- Service ports
- Application binding

Network troubleshooting should always move layer by layer rather than assuming a single cause.

---

# Q70. Describe the Java compatibility issue that affected your deployment.

## Answer

The deployment stage remained queued because the Jenkins deployment agent failed to start.

Investigation:

```
Offline Agent

↓

Remoting Logs

↓

UnsupportedClassVersionError

↓

Java 8 Detected

↓

Install Java 21

↓

Restart Agent

↓

Deployment Successful
```

This was one of the most valuable troubleshooting exercises in the project.

---

# Q71. How do you troubleshoot Kubernetes deployments systematically?

## Answer

Recommended workflow:

```
Deployment

↓

Pods

↓

Logs

↓

Events

↓

Services

↓

Ingress

↓

Application
```

Useful commands:

```bash
kubectl get all

kubectl describe deployment

kubectl logs

kubectl get events
```

---

# Q72. What commands do you use most frequently while troubleshooting Kubernetes?

## Answer

Common commands:

```bash
kubectl get pods

kubectl get svc

kubectl get ingress

kubectl describe pod

kubectl describe deployment

kubectl logs

kubectl exec

kubectl get events

kubectl get nodes

kubectl top pods
```

These commands solve the majority of production Kubernetes issues.

---

# Q73. What lessons did Helm teach you during this project?

## Answer

Important lessons:

- Validate charts before deployment.
- Track release revisions.
- Parameterize deployments.
- Use versioned Docker images.
- Keep Helm values separate from templates.
- Learn rollback procedures before deploying to production.

---

# Q74. What lessons did AWS infrastructure troubleshooting teach you?

## Answer

Key takeaways:

- Monitor disk utilization proactively.
- Configure Security Groups carefully.
- Keep IAM permissions minimal.
- Monitor EC2 resource usage.
- Verify networking before troubleshooting applications.
- Use infrastructure monitoring to detect issues early.

---

# Q75. Summarize the Kubernetes, Helm, and AWS troubleshooting experience from this project.

## Answer

This project provided practical experience troubleshooting production-style infrastructure across Kubernetes, Helm, Jenkins, and AWS.

Major issues resolved included:

- Pending Pods
- Helm deployment failures
- Jenkins deployment agent connectivity
- Java compatibility (Java 8 vs Java 21)
- EC2 disk expansion
- Kubernetes networking validation
- Service and Ingress verification
- Docker image deployment issues
- Helm release management
- AWS infrastructure diagnostics

Rather than relying on trial and error, every issue was resolved using a structured methodology:

```
Observe

↓

Collect Logs

↓

Identify Root Cause

↓

Apply Minimal Fix

↓

Validate

↓

Document
```

This disciplined troubleshooting process is directly applicable to enterprise DevOps, SRE, Cloud Engineering, Platform Engineering, and MLOps roles.

---

# End of Part-3

## Questions Covered

**Questions 51–75**

Next:

**Part-4 (Questions 76–100): Enterprise Production Troubleshooting**

Topics include:

- Production incidents
- Root Cause Analysis (RCA)
- Major outage response
- High Availability
- Disaster Recovery
- Performance tuning
- Observability
- Monitoring
- Logging
- Security incidents
- FAANG-level production troubleshooting scenarios
# Chapter-11-Troubleshooting.md
# Part-4

# Enterprise Production Troubleshooting (Questions 76–100)

---

# Q76. A production deployment has failed. What is your first action?

## Answer

The first priority is **service restoration**, not assigning blame.

A structured response should be:

```
Incident Reported

↓

Confirm the Impact

↓

Identify the Failed Deployment

↓

Check Monitoring Dashboards

↓

Review Logs

↓

Decide Rollback or Fix
```

Checklist:

- Is production unavailable?
- How many users are affected?
- Which deployment introduced the issue?
- Can the service be restored quickly?

Always minimize customer impact first.

---

# Q77. What is the difference between symptom, root cause, and resolution?

## Answer

Many engineers confuse these three concepts.

Example:

```
Users cannot access application
```

Symptom:

```
HTTP 503 Errors
```

Root Cause:

```
Pods failed readiness checks because the database connection string was incorrect.
```

Resolution:

```
Correct configuration.

Redeploy application.

Verify health.
```

Finding the real root cause prevents repeated incidents.

---

# Q78. What is Root Cause Analysis (RCA)?

## Answer

Root Cause Analysis is a structured investigation to determine **why** an incident occurred and how to prevent it.

Typical RCA template:

```
Incident

↓

Timeline

↓

Evidence

↓

Root Cause

↓

Corrective Actions

↓

Preventive Actions
```

A good RCA focuses on improving systems rather than assigning blame.

---

# Q79. What should be included in an RCA document?

## Answer

A complete RCA generally includes:

- Incident summary
- Timeline
- Systems affected
- Customer impact
- Root cause
- Contributing factors
- Resolution
- Recovery time
- Preventive measures
- Action items
- Owners
- Target completion dates

This document becomes a valuable operational reference.

---

# Q80. A deployment succeeded, but users report failures. What should you check?

## Answer

Successful deployment does not always mean a healthy application.

Investigate:

```
Deployment

↓

Pods

↓

Readiness

↓

Application Logs

↓

Database

↓

API Responses

↓

User Experience
```

Possible causes:

- Database unavailable
- Configuration error
- External API failure
- Load balancer issue
- DNS problem

---

# Q81. How do you troubleshoot high CPU utilization in production?

## Answer

Investigation:

```
Monitoring

↓

CPU Metrics

↓

Affected Pods

↓

Application Logs

↓

Recent Deployments
```

Useful commands:

```bash
kubectl top pods

kubectl top nodes

top

htop
```

Common causes:

- Infinite loops
- High traffic
- Memory leaks
- Inefficient queries

---

# Q82. How do you troubleshoot high memory usage?

## Answer

Review:

- Memory graphs
- Container limits
- Heap utilization
- Recent deployments

Commands:

```bash
kubectl top pods

free -h

vmstat
```

If containers are repeatedly OOMKilled, adjust resource limits or optimize the application.

---

# Q83. Production latency suddenly increases. What should you investigate?

## Answer

Potential causes:

- CPU saturation
- Memory pressure
- Database bottlenecks
- Network congestion
- External API delays

Workflow:

```
Latency Alert

↓

Application Metrics

↓

Infrastructure Metrics

↓

Database Metrics

↓

Root Cause
```

Avoid assuming the application is always responsible.

---

# Q84. Users report intermittent failures. How do you investigate?

## Answer

Intermittent issues are often more difficult than complete outages.

Check:

- Load balancer
- Multiple replicas
- DNS
- Pod restarts
- Node health
- Network connectivity

Collect evidence before restarting services.

---

# Q85. What is observability?

## Answer

Observability is the ability to understand the internal state of a system using:

- Metrics
- Logs
- Traces

```
Metrics

+

Logs

+

Distributed Traces

↓

Observability
```

Observability allows engineers to diagnose unknown failures more quickly.

---

# Q86. What metrics should every production system monitor?

## Answer

Infrastructure metrics:

- CPU
- Memory
- Disk
- Network

Application metrics:

- Request count
- Response time
- Error rate
- Throughput

Pipeline metrics:

- Build success rate
- Deployment success rate
- Rollback frequency

---

# Q87. What logging strategy would you recommend?

## Answer

Logs should be centralized.

Example architecture:

```
Application

↓

Container Logs

↓

Log Collector

↓

Central Log Platform

↓

Dashboard
```

Benefits:

- Faster searches
- Correlation
- Historical analysis
- Easier debugging

---

# Q88. Why should monitoring and alerting be separate?

## Answer

Monitoring collects information.

Alerting notifies engineers when thresholds are exceeded.

```
Monitoring

↓

Threshold

↓

Alert

↓

Engineer
```

Separating responsibilities reduces alert fatigue.

---

# Q89. What is alert fatigue?

## Answer

Alert fatigue occurs when engineers receive too many unnecessary alerts.

Consequences:

- Ignored alerts
- Delayed response
- Increased outage duration

Good alerts should be:

- Actionable
- Accurate
- Prioritized

---

# Q90. How would you troubleshoot a major production outage?

## Answer

Recommended approach:

```
Detect

↓

Assess Impact

↓

Assemble Response Team

↓

Collect Logs

↓

Restore Service

↓

Perform RCA

↓

Implement Prevention
```

Avoid making multiple uncontrolled changes during an incident.

---

# Q91. What is Disaster Recovery (DR)?

## Answer

Disaster Recovery is the process of restoring services after catastrophic failures.

Examples:

- Region outage
- Data center failure
- Database corruption
- Accidental deletion

A DR plan should include:

- Backups
- Recovery procedures
- Recovery testing
- Communication plan

---

# Q92. What are RTO and RPO?

## Answer

**RTO (Recovery Time Objective)**

Maximum acceptable time to restore service.

Example:

```
Target

↓

Restore within 30 minutes
```

**RPO (Recovery Point Objective)**

Maximum acceptable amount of data loss.

Example:

```
Backups every 15 minutes

↓

Maximum Data Loss = 15 minutes
```

These objectives drive backup and recovery strategies.

---

# Q93. How would you handle an incident caused by a bad deployment?

## Answer

Workflow:

```
Deployment

↓

Incident

↓

Health Validation

↓

Rollback

↓

Verify Recovery

↓

RCA

↓

Prevent Recurrence
```

Fast rollback is often preferable to debugging directly in production.

---

# Q94. What should happen after every production incident?

## Answer

Conduct a post-incident review.

Include:

- Timeline
- Impact
- Root cause
- Resolution
- Lessons learned
- Action items

The goal is continuous improvement.

---

# Q95. What production best practices did you learn from this project?

## Answer

Important lessons:

- Validate changes before deployment.
- Monitor infrastructure continuously.
- Keep detailed logs.
- Automate deployments.
- Version all artifacts.
- Document troubleshooting steps.
- Separate CI from CD responsibilities.
- Test rollback procedures.

These practices improve reliability and reduce operational risk.

---

# Q96. Which real troubleshooting experiences from this project are most valuable in interviews?

## Answer

Examples include:

- Jenkins deployment agent offline
- Java 8 to Java 21 compatibility issue
- UnsupportedClassVersionError
- Docker build failures
- Docker Hub authentication
- EC2 storage expansion
- Helm deployment troubleshooting
- Kubernetes deployment verification
- SSH authentication cleanup
- Git workspace cleanup
- Jenkins pipeline optimization

These demonstrate hands-on operational experience rather than theoretical knowledge.

---

# Q97. How do senior DevOps engineers troubleshoot differently from beginners?

## Answer

Senior engineers:

- Gather evidence first.
- Read logs before changing configurations.
- Reproduce issues when possible.
- Make one controlled change at a time.
- Validate every fix.
- Document findings.
- Think in terms of systems rather than individual components.

This systematic approach minimizes risk during production incidents.

---

# Q98. During an interview, how would you explain your troubleshooting methodology?

## Answer

I follow a repeatable process:

```
Understand the Problem

↓

Measure Impact

↓

Collect Logs

↓

Analyze Metrics

↓

Identify Root Cause

↓

Implement Minimal Fix

↓

Validate

↓

Monitor

↓

Document

↓

Prevent Recurrence
```

This methodology works across Linux, Jenkins, Docker, Kubernetes, Helm, AWS, and CI/CD systems.

---

# Q99. If you could redesign this project today, what operational improvements would you add?

## Answer

I would enhance the platform with:

- Prometheus monitoring
- Grafana dashboards
- Alertmanager
- Centralized logging (Loki or ELK)
- Argo CD (GitOps)
- Amazon ECR
- Amazon EKS
- HashiCorp Vault or AWS Secrets Manager
- Trivy image scanning
- Policy enforcement
- Automated rollback
- Slack or Microsoft Teams notifications

These additions would make the platform closer to enterprise production standards.

---

# Q100. Summarize everything you learned about troubleshooting from this project.

## Answer

This project provided end-to-end troubleshooting experience across the complete CI/CD lifecycle.

Major areas included:

- Linux administration
- Git and GitHub authentication
- Jenkins installation and pipeline failures
- Distributed Jenkins agents
- Java compatibility management
- Maven build troubleshooting
- SonarQube integration
- Docker image creation and registry management
- Kubernetes deployments
- Helm release management
- AWS EC2 administration
- Storage expansion
- SSH configuration
- Production deployment verification

The biggest lesson was that successful troubleshooting is not about memorizing commands—it is about following a disciplined process:

```
Observe

↓

Collect Evidence

↓

Analyze

↓

Identify Root Cause

↓

Implement Controlled Fix

↓

Validate

↓

Document

↓

Improve the System
```

Developing this mindset is what distinguishes experienced DevOps, Platform Engineering, SRE, Cloud, and MLOps engineers. The real-world issues solved during this project provide strong examples for discussing troubleshooting, incident response, and production operations in technical interviews.

---

# End of Chapter-11

## Questions Covered

**Questions 1–100**

### Topics Covered

- Linux Troubleshooting
- Git & GitHub Issues
- Jenkins Failures
- Maven Build Errors
- SonarQube Problems
- Docker Troubleshooting
- Kubernetes Pod Issues
- Helm Deployment Failures
- AWS Infrastructure Problems
- SSH & Networking
- Production Incident Management
- Root Cause Analysis (RCA)
- Disaster Recovery
- Observability
- Monitoring & Alerting
- Performance Optimization
- High Availability
- Enterprise Operational Best Practices
- FAANG-Level Production Troubleshooting

This completes **Chapter-11: Troubleshooting**, providing a comprehensive set of 100 real-world interview questions and answers drawn from practical CI/CD and cloud infrastructure experience.  
