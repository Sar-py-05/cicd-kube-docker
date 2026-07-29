# Chapter 02 - Git & GitHub: Chapters 1 and 2 of Git
## FAANG-Level DevOps & MLOps Interview Handbook

**Chapter:** Git & GitHub

**Part:** 1 of 3

**Difficulty:** Beginner → Intermediate

**Questions Covered:** 1 – 20

---

# Introduction

Git is the most widely used Version Control System (VCS) in the software industry. Every DevOps engineer uses Git daily for source code management, CI/CD pipelines, Infrastructure as Code (IaC), Kubernetes manifests, Helm charts, and configuration management.

Throughout our projects, Git was used extensively with:

- Jenkins Pipelines
- GitHub Repositories
- Helm Charts
- Kubernetes Manifests
- Dockerfiles
- Maven Projects
- Jenkinsfiles
- SonarQube Integration
- CI/CD Automation

This chapter covers Git fundamentals and practical interview questions frequently asked by companies like Amazon, Google, Microsoft, Meta, Netflix, Uber, Atlassian, VMware, Oracle, and Red Hat.

---

# Question 1

## What is Git?

### Answer

Git is a **Distributed Version Control System (DVCS)** used to track changes in source code and collaborate efficiently among developers.

Git allows developers to:

- Track code changes
- Maintain version history
- Create branches
- Merge code safely
- Collaborate with teams
- Roll back to previous versions

Unlike centralized systems, every developer has a complete copy of the repository.

### Project Example

Throughout our CI/CD projects, Git stored:

- Jenkinsfile
- Dockerfile
- Helm Charts
- Kubernetes YAML files
- Java Source Code
- README.md
- Architecture documentation

---

# Question 2

## What is Version Control?

### Answer

Version Control is the practice of tracking modifications made to files over time.

Benefits include:

- History tracking
- Collaboration
- Rollback capability
- Conflict resolution
- Audit trail

Without version control, multiple developers would overwrite each other's changes.

---

# Question 3

## What is the difference between Git and GitHub?

### Answer

| Git | GitHub |
|------|---------|
| Version Control System | Cloud hosting platform |
| Installed locally | Hosted online |
| Tracks changes | Stores repositories |
| Works offline | Requires internet |
| Open source | Commercial service (with free tier) |

### Interview Tip

Many candidates incorrectly say Git and GitHub are the same. They are not.

---

# Question 4

## What is a Repository?

### Answer

A repository (repo) stores:

- Source code
- Commit history
- Branches
- Tags
- Configuration files

Repositories may be:

- Local
- Remote

### Our Projects

Examples:

```
cicd-kube-docker

vprofile-project

vprofile-helm
```

---

# Question 5

## What is a Commit?

### Answer

A commit is a snapshot of your project at a specific point in time.

Example:

```
Updated Dockerfile

Fixed Jenkins Pipeline

Added Helm Chart

Updated README
```

Every commit receives a unique SHA hash.

---

# Question 6

## What is a Commit Hash?

### Answer

Every Git commit has a unique 40-character SHA-1 identifier.

Example:

```
764098c4b2a176ef2efeba7b5a0f8b87d30e62d5
```

This uniquely identifies a commit.

---

# Question 7

## Explain the Git Architecture.

### Answer

Git consists of three major areas:

```
Working Directory

↓

Staging Area

↓

Local Repository

↓

Remote Repository
```

Workflow:

```
Edit

↓

git add

↓

git commit

↓

git push
```

---

# Question 8

## What is the Working Directory?

### Answer

The Working Directory contains files currently being edited.

Example:

```
Jenkinsfile

Dockerfile

README.md
```

Changes here are not yet tracked until staged.

---

# Question 9

## What is the Staging Area?

### Answer

The Staging Area (Index) is an intermediate step before committing.

Example:

```bash
git add Jenkinsfile
```

Only staged files become part of the next commit.

---

# Question 10

## What is the Local Repository?

### Answer

The Local Repository stores commits on your machine.

It contains:

- Commit history
- Branches
- Tags
- Logs

Location:

```
.git/
```

---

# Question 11

## What is a Remote Repository?

### Answer

A Remote Repository is hosted on platforms such as:

- GitHub
- GitLab
- Bitbucket
- Azure DevOps

Developers synchronize local changes with remotes.

---

# Question 12

## Explain the Git Workflow.

### Answer

Typical workflow:

```bash
git status

git add .

git commit -m "Updated Dockerfile"

git push origin main
```

This is the workflow we followed throughout our CI/CD project.

---

# Question 13

## What does `git init` do?

### Answer

Initializes a new Git repository.

Example:

```bash
git init
```

Creates:

```
.git/
```

which stores all repository metadata.

---

# Question 14

## What does `git clone` do?

### Answer

Downloads a remote repository to the local machine.

Example:

```bash
git clone https://github.com/Sar-py-05/cicd-kube-docker.git
```

Our Jenkins jobs also performed repository clones before every build.

---

# Question 15

## What does `git status` do?

### Answer

Shows:

- Current branch
- Modified files
- Staged files
- Untracked files

Example:

```bash
git status
```

Typical output:

```
On branch main

nothing to commit

working tree clean
```

---

# Question 16

## What does `git add` do?

### Answer

Moves changes from the Working Directory to the Staging Area.

Examples:

```bash
git add Jenkinsfile

git add Dockerfile

git add .

git add helm/
```

---

# Question 17

## What does `git commit` do?

### Answer

Creates a permanent snapshot.

Example:

```bash
git commit -m "Updated Dockerfile"
```

Commit messages should clearly describe the change.

Good:

```
Fixed Helm deployment

Updated Jenkins Pipeline

Added SonarQube stage
```

Bad:

```
changes

update

test
```

---

# Question 18

## What does `git push` do?

### Answer

Uploads local commits to the remote repository.

Example:

```bash
git push origin main
```

### Project Scenario

Initially, we encountered authentication failures while pushing using HTTPS. After configuring credentials correctly, the push succeeded and Jenkins could fetch the latest code from GitHub during pipeline execution.

---

# Question 19

## What does `git pull` do?

### Answer

Downloads changes from the remote repository and merges them into the current branch.

Internally:

```
git fetch

+

git merge
```

Example:

```bash
git pull origin main
```

---

# Question 20

## Describe a real Git issue that you solved during the project.

### Answer

While working on the Kubernetes CI/CD project, I attempted to push changes using:

```bash
git push origin main
```

Git prompted for authentication, but the push failed because GitHub no longer accepts account passwords for HTTPS authentication.

### Investigation

I verified:

```bash
git status
```

Then confirmed the remote:

```bash
git remote -v
```

The remote was configured correctly, but authentication was failing.

### Resolution

I generated a **GitHub Personal Access Token (PAT)** with the required repository permissions.

During the next push:

```bash
Username:
Sar-py-05

Password:
<GitHub Personal Access Token>
```

The push completed successfully:

```text
Enumerating objects...

Writing objects...

To https://github.com/Sar-py-05/cicd-kube-docker.git

main -> main
```

### Interview Follow-up Questions

- Why doesn't GitHub accept passwords anymore?
- What scopes are required for a PAT?
- Is SSH a better alternative?
- How would Jenkins authenticate to GitHub securely?
- Where should Git credentials be stored in a CI/CD pipeline?

### FAANG Tip

Interviewers appreciate candidates who explain:

- The root cause
- How they diagnosed the issue
- Why the fix worked
- How they would prevent the issue in the future

---

# Chapter Summary (Part 1)

In this section, we covered:

- Git fundamentals
- Version Control concepts
- Git architecture
- Working Directory
- Staging Area
- Local Repository
- Remote Repository
- Repository creation
- Cloning
- Adding files
- Committing changes
- Pushing to GitHub
- Pulling updates
- Real-world Git authentication troubleshooting

---

# Chapter 02 — Git

## Introduction

Git is the most widely used distributed version control system. It allows developers to track code changes, collaborate efficiently, maintain history, and automate software delivery pipelines.

During this project Git was used for:

- Source code management
- Jenkins Pipeline
- Dockerfile versioning
- Helm chart versioning
- Kubernetes manifests
- CI/CD automation
- GitHub integration

This chapter contains interview questions ranging from beginner to FAANG-level.

---

# Question 1

## What is Version Control?

### Answer

Version Control is a system that records every change made to source code over time.

It allows developers to:

- Track history
- Restore previous versions
- Compare changes
- Collaborate safely
- Audit modifications

Without Version Control, teams overwrite each other's work.

Examples:

- Git
- SVN
- Mercurial

Git is the industry standard.

---

# Question 2

## What is Git?

### Answer

Git is a Distributed Version Control System (DVCS).

Created by:

Linus Torvalds (2005)

Git stores the complete repository history on every developer machine.

Advantages:

- Fast
- Offline work
- Easy branching
- Easy merging
- Reliable
- Distributed

---

# Question 3

## What is the difference between Git and GitHub?

### Answer

Git:

- Version Control System
- Installed locally
- Tracks code

GitHub:

- Cloud hosting service
- Stores Git repositories
- Collaboration platform

Git works without GitHub.

GitHub uses Git internally.

---

# Question 4

## Explain Distributed Version Control.

### Answer

Every developer has:

- Entire repository
- Complete commit history
- All branches

Unlike centralized systems, no single server is required.

Benefits:

- Offline commits
- Better backup
- Faster operations

---

# Question 5

## Explain Git Architecture.

### Answer

Git has three major areas:

Working Directory

↓

Staging Area (Index)

↓

Repository (.git)

Flow:

Working Directory

↓

git add

↓

Staging Area

↓

git commit

↓

Repository

---

# Question 6

## What happens during git init?

### Answer

git init creates

.git/

inside the current directory.

The .git folder stores:

- Objects
- Refs
- Branches
- Logs
- Configuration
- Commit history

---

# Question 7

## What is the .git directory?

### Answer

.git is the heart of Git.

It contains:

HEAD

objects/

refs/

logs/

hooks/

config

index

Without .git, the folder is no longer a Git repository.

---

# Question 8

## Explain the Git Object Model.

### Answer

Git stores everything as objects.

There are four object types.

Blob

Stores file contents.

Tree

Stores directory structure.

Commit

Stores snapshot metadata.

Tag

Stores release information.

Every object is identified by SHA hash.

---

# Question 9

## What is a Commit?

### Answer

A commit is a snapshot of the repository at a specific time.

Every commit contains:

- Author
- Timestamp
- Parent commit
- Commit message
- Tree reference

Each commit has a unique SHA identifier.

---

# Question 10

## Explain SHA in Git.

### Answer

SHA stands for Secure Hash Algorithm.

Git identifies every object using SHA.

Example:

8c1d9f42a7...

Benefits:

- Integrity
- Unique identity
- Detects corruption

---

# Question 11

## What is the Working Directory?

### Answer

The Working Directory is where developers edit files.

Changes made here are not tracked until staged.

---

# Question 12

## What is the Staging Area?

### Answer

The Staging Area (Index) is an intermediate area between the Working Directory and Repository.

Purpose:

Select exactly what should be committed.

Command:

git add filename

---

# Question 13

## Explain git add.

### Answer

git add moves changes from the Working Directory into the Staging Area.

Example:

git add app.py

Stage everything:

git add .

---

# Question 14

## Explain git commit.

### Answer

Creates a permanent snapshot.

Example:

git commit -m "Added Jenkins Pipeline"

---

# Question 15

## Explain git status.

### Answer

Displays repository status.

Shows:

- Modified files
- Untracked files
- Staged files
- Current branch

One of the most frequently used Git commands.

---

# Question 16

## Explain git log.

### Answer

Shows commit history.

Useful options:

git log

git log --oneline

git log --graph

git log --decorate

---

# Question 17

## What is HEAD?

### Answer

HEAD is a pointer to the current branch.

Usually:

HEAD

↓

main

↓

latest commit

---

# Question 18

## Explain Detached HEAD.

### Answer

Occurs when HEAD points directly to a commit instead of a branch.

Example:

git checkout abc123

Now HEAD is detached.

---

# Question 19

## What is a Branch?

### Answer

A branch is an independent line of development.

Benefits:

- Feature development
- Bug fixes
- Experiments
- Parallel work

---

# Question 20

## Explain main vs master.

### Answer

Historically Git used:

master

Modern repositories use:

main

GitHub now defaults to:

main

---

# Question 21

## How do you create a branch?

### Answer

git branch feature-login

Switch:

git checkout feature-login

Or:

git switch feature-login

---

# Question 22

## Explain git checkout.

### Answer

Used to:

- Switch branches
- Restore files
- Checkout commits

Modern Git recommends:

git switch

and

git restore

---

# Question 23

## Explain git switch.

### Answer

Simplified branch switching.

Example:

git switch main

git switch feature

---

# Question 24

## Explain git restore.

### Answer

Restores modified files.

Example:

git restore app.py

---

# Question 25

## Explain git clone.

### Answer

Downloads an existing repository.

Example:

git clone https://github.com/user/project.git

Creates:

- Repository
- Working Directory
- Remote origin

---

# Question 26

## Explain git remote.

### Answer

Shows remote repositories.

Example:

git remote -v

Output:

origin

upstream

---

# Question 27

## Explain origin.

### Answer

origin is simply the default remote name.

Example:

origin

↓

https://github.com/user/project.git

---

# Question 28

## Explain upstream.

### Answer

Upstream usually refers to the original repository from which a fork was created.

Common in open-source projects.

---

# Question 29

## Explain git fetch.

### Answer

Downloads changes without merging.

Safe operation.

Example:

git fetch origin

---

# Question 30

## Explain git pull.

### Answer

git pull performs:

git fetch

+

git merge

It downloads changes and immediately merges them into the current branch.

Example:

git pull origin main
