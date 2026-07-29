# Chapter 01 - Linux
## FAANG-Level DevOps & MLOps Interview Handbook

**Chapter:** Linux Fundamentals for DevOps Engineers

**Difficulty:** Beginner → Intermediate → Advanced

**Total Questions:** 60

---

# Introduction

Linux is the backbone of modern cloud infrastructure. Almost every Kubernetes cluster, Docker host, Jenkins server, GitLab Runner, AWS EC2 instance, and production application runs on Linux.

During our projects we worked extensively with Linux while configuring:

- Jenkins Server
- SonarQube Server
- Docker Host
- KOPS Kubernetes Cluster
- Jenkins Agent
- EC2 Instances
- Maven
- Helm
- Git
- SSH
- Docker

This chapter contains carefully selected Linux interview questions frequently asked by companies such as Amazon, Google, Microsoft, Meta, Netflix, Uber, Atlassian, Oracle, VMware, and Red Hat.

---

# Question 1

## Why is Linux the preferred operating system for DevOps?

### Answer

Linux provides:

- Stability
- Security
- Open-source ecosystem
- Powerful command-line tools
- Excellent networking stack
- Automation support
- Package managers
- Container support
- Kubernetes native support

Nearly every cloud provider officially supports Linux as the primary server operating system.

### From Our Project

Our infrastructure consisted of:

- Jenkins Server (Ubuntu)
- SonarQube Server (Ubuntu)
- KOPS Cluster Nodes (Ubuntu)
- Jenkins Agent (Ubuntu)

Every deployment was performed from Linux.

---

# Question 2

## What happens internally when Linux boots?

### Answer

Boot process:

1. BIOS/UEFI
2. GRUB Bootloader
3. Linux Kernel
4. initramfs
5. systemd
6. Services
7. Login Prompt

Interviewers frequently ask this to understand system initialization.

---

# Question 3

## What is the Linux Kernel?

### Answer

The Linux Kernel is the core component of the operating system.

It manages:

- CPU Scheduling
- Memory
- File Systems
- Drivers
- Networking
- Processes

Without the kernel the operating system cannot function.

---

# Question 4

## What is the difference between Kernel Space and User Space?

### Answer

Kernel Space

- Full hardware access
- Device drivers
- Process scheduling
- Memory management

User Space

- Applications
- Shell
- Editors
- Browsers
- Jenkins
- Docker CLI

Applications request kernel services using system calls.

---

# Question 5

## What is a Shell?

### Answer

A shell is a command interpreter.

Common shells:

- bash
- zsh
- sh
- fish
- ksh

Our projects used Bash.

Example:

```bash
echo Hello
pwd
ls
```

---

# Question 6

## Explain the Linux directory structure.

### Answer

| Directory | Purpose |
|------------|----------|
| / | Root |
| /home | User files |
| /etc | Configuration |
| /usr | Installed software |
| /var | Logs |
| /tmp | Temporary files |
| /opt | Optional software |
| /bin | Essential binaries |
| /sbin | System binaries |

### Project Example

Jenkins Agent

```
/opt/jenkins-slave
```

Jenkins logs

```
/var/log/jenkins
```

---

# Question 7

## Difference between /bin and /usr/bin?

### Answer

/bin

Essential commands required during boot.

Examples:

```
ls
cp
mv
cat
```

/usr/bin

Regular user applications.

---

# Question 8

## What is PATH?

### Answer

PATH tells Linux where executables are located.

Example

```bash
echo $PATH
```

Output

```
/usr/local/bin
/usr/bin
/bin
```

---

# Question 9

## What does pwd do?

### Answer

Displays the current working directory.

Example

```bash
pwd
```

Output

```
/home/ubuntu
```

---

# Question 10

## Difference between absolute and relative paths?

### Answer

Absolute

```
/home/ubuntu/project
```

Relative

```
project/
```

---

# Question 11

## Explain ls options.

Common options

```
ls

ls -l

ls -a

ls -lh

ls -lrt
```

Project example

```bash
ls
```

Output

```
Dockerfile
helm
Jenkinsfile
pom.xml
src
```

---

# Question 12

## Difference between cp and mv?

cp

Copies files

mv

Moves or renames files

---

# Question 13

## What is rm -rf?

### Answer

Deletes directories recursively without confirmation.

Dangerous command.

Never execute:

```bash
rm -rf /
```

---

# Question 14

## What is mkdir -p?

Creates nested directories.

Example

```bash
mkdir -p /opt/jenkins-slave/workspace
```

---

# Question 15

## Explain file permissions.

Example

```
-rwxr-xr-x
```

Breakdown

Owner

Group

Others

Permissions

Read

Write

Execute

---

# Question 16

## What does chmod do?

Example

```bash
chmod 755 script.sh
```

Meaning

Owner

Read Write Execute

Others

Read Execute

---

# Question 17

## Difference between chmod 755 and 777?

755

Safe

777

Everyone has full permissions

Never use in production unless absolutely necessary.

---

# Question 18

## What does chown do?

Example

```bash
sudo chown ubuntu:ubuntu /opt/jenkins-slave -R
```

This command was used during our Jenkins Agent setup.

---

# Question 19

## Difference between chown and chmod?

chmod

Changes permissions

chown

Changes ownership

---

# Question 20

## What is sudo?

Runs commands with elevated privileges.

Example

```bash
sudo apt update
```

---

# Question 21

## Difference between apt update and apt upgrade?

update

Refresh package index.

upgrade

Installs newer versions.

---

# Question 22

## How do you install software?

Example

```bash
sudo apt install docker.io
```

---

# Question 23

## What is systemctl?

Controls Linux services.

Examples

```bash
systemctl status docker

systemctl restart docker

systemctl enable docker
```

---

# Question 24

## Difference between restart and reload?

Restart

Stops and starts service.

Reload

Reloads configuration without stopping.

---

# Question 25

## How do you check running services?

```bash
systemctl list-units --type=service
```

---

# Question 26

## How do you view logs?

```bash
journalctl

journalctl -u docker

journalctl -xe
```

---

# Question 27

## What is top?

Displays running processes.

---

# Question 28

## Difference between top and htop?

htop

Interactive

Colorful

Easy to use

---

# Question 29

## How do you find processes?

```bash
ps -ef

ps aux
```

---

# Question 30

## How do you kill a process?

```bash
kill PID

kill -9 PID
```

---

# Question 31

## What is grep?

Searches text.

Example

```bash
grep docker file.txt
```

---

# Question 32

## What is find?

Searches files.

Example

```bash
find / -name Jenkinsfile
```

---

# Question 33

## Difference between grep and find?

find

Searches files.

grep

Searches contents.

---

# Question 34

## What is tail?

View last lines.

```bash
tail -f logfile
```

---

# Question 35

## What is head?

Shows first lines.

---

# Question 36

## Explain pipes.

Example

```bash
ps -ef | grep java
```

---

# Question 37

## Explain redirection.

```
>

>>

2>

&
```

---

# Question 38

## How do you check disk usage?

```bash
df -h
```

Used frequently during our Docker storage troubleshooting.

---

# Question 39

## How do you check directory size?

```bash
du -sh *
```

---

# Question 40

## How do you identify large files?

```bash
find / -size +500M
```

---

# Question 41

## How do you check memory?

```bash
free -h
```

---

# Question 42

## How do you check CPU?

```bash
lscpu
```

---

# Question 43

## How do you check hostname?

```bash
hostname
```

---

# Question 44

## What is SSH?

Secure Shell

Used for remote administration.

---

# Question 45

## SSH authentication methods.

- Password
- SSH Keys

Our GitHub integration eventually used Personal Access Tokens for HTTPS, while SSH keys are another common authentication method.

---

# Question 46

## What is ~/.ssh?

Stores:

- id_rsa
- id_ed25519
- authorized_keys
- known_hosts

---

# Question 47

## Difference between SCP and SFTP?

SCP

Copy files.

SFTP

Interactive file transfer.

---

# Question 48

## What is curl?

Downloads content.

Example

```bash
curl https://example.com
```

---

# Question 49

## What is wget?

Downloads files.

---

# Question 50

## What is tar?

Creates archives.

```bash
tar -czvf backup.tar.gz folder
```

---

# Question 51

## Difference between gzip and zip?

gzip

Compresses one file.

zip

Compresses multiple files.

---

# Question 52

## What is crontab?

Schedules jobs.

Example

```bash
crontab -e
```

---

# Question 53

## What is an Environment Variable?

Example

```bash
echo $JAVA_HOME
```

---

# Question 54

## What is JAVA_HOME?

Points to Java installation.

Essential for Jenkins.

---

# Question 55

## Explain symbolic links.

Example

```bash
ln -s source target
```

---

# Question 56

## What is mount?

Attaches storage.

---

# Question 57

## Difference between hard link and soft link?

Hard Link

Same inode.

Soft Link

Pointer.

---

# Question 58

## Explain Linux package managers.

Ubuntu

apt

RHEL

yum

dnf

---

# Question 59

## What Linux troubleshooting commands do you use daily?

- ps
- top
- free
- df
- du
- journalctl
- systemctl
- netstat
- ss
- curl
- grep
- tail
- find

---

# Question 60

## Describe a real Linux troubleshooting issue you solved.

### Interview Answer

During our Jenkins Kubernetes CI/CD project, the Jenkins agent repeatedly failed to connect.

The error was:

```
UnsupportedClassVersionError
```

Investigation steps:

1. Checked Java version.

```bash
java -version
```

Found Java 8 installed.

2. Installed OpenJDK 21.

3. Switched the default Java.

```bash
sudo update-alternatives --config java
sudo update-alternatives --config javac
```

4. Verified:

```bash
java -version
```

Output:

```
OpenJDK 21
```

5. Reconnected the Jenkins agent.

The agent connected successfully and the Kubernetes deployment stage completed without errors.

### Why Interviewers Like This Question

This answer demonstrates:

- Practical troubleshooting
- Linux command-line proficiency
- Java runtime management
- Jenkins agent debugging
- Root cause analysis
- Validation after implementing the fix

---

# Chapter Summary

After completing this chapter, you should be comfortable with:

- Linux command-line operations
- File system hierarchy
- Permissions and ownership
- Package management
- Process management
- Service management
- SSH
- Disk and memory monitoring
- Log analysis
- Environment variables
- Java configuration
- Linux troubleshooting for DevOps environments

These Linux fundamentals form the foundation for the remaining chapters on Git, Jenkins, Docker, Kubernetes, Helm, and AWS.
