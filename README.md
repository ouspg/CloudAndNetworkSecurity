Cloud and Network Security Lab 5: Cloud Security
====

Responsible person/main contact: Niklas Saari, Asad Hasan & Lauri Suutari

## Preliminary tasks & prerequisites

This is the fifth lab in the series with the theme of Cloud Security. 
You should return the tasks to GitHub.

Make yourself familiar with the following topics:


* **Cloud Standard Protocols** -
* **Kubernetes** -
* **Endpoint search** - 


## Grading

<!-- <details><summary>Details</summary> -->


Task #|Points|Description|Tools
-----|:---:|-----------|-----
Task 1 | 1 | 
Task 2 | 1 | Insecure endpoints, git and environment variables | fluff, psql
Task 3 | 1 | 
Task 4 | 2 | 


Total points accumulated by doing the exercises reflect the overall grade. You can acquire up to 10 points from the whole exercise (Combination of Task 1 and Task 2).
<!-- </details> -->

---


## About the lab

* **You are encouraged to use your own computer or virtual machine if you want.** However, the use of a Linux machine is necessary. 
* Check the deadline from Moodle and __remember that you have to return your name (and possibly people you worked together with) and GitHub repository information to Moodle before the deadline.__


## Background

This week’s theme is networking protocols.

Networking protocols are a set of rules and conventions that govern the communication between devices in a computer network. These protocols define how data is formatted, transmitted, received, and interpreted across the network. They facilitate the exchange of information between devices, ensuring compatibility and interoperability.

Key aspects of networking protocols include:

1) Addressing: Protocols define how devices are identified and addressed on the network. This includes assigning unique addresses, such as IP addresses, to devices to enable communication.

2) Routing: Protocols determine how data packets are routed from a source to a destination across the network. This involves selecting the best path for data transmission and managing network congestion.

3) Error Handling: Protocols include mechanisms for detecting and correcting errors that may occur during data transmission. This ensures reliable communication between devices.

4) Security: Many protocols incorporate security features to protect data from unauthorized access, interception, or tampering. This includes encryption, authentication, and access control mechanisms.

Some common examples of networking protocols include; Internet Protocol (IP), Transmission Control Protocol (TCP) and Hypertext Transfer Protocol (HTTP).


---

## Task 1

---
## Task 2
This task involves intentionally vulnerable Kubernetes deployments and services that you are to exploit using Fluff and a tool to access the database from outside the Kubernetes cluster. The idea is to get deeper and deeper into the system as you progress through the stages and use the information found during the task to find different flags. This task can be completed on both Linux and Windows machines, but it is easier to use the tools with an UNIX operating system. And there is a direct script for deployment on Linux machines.

You can read more about the tools used during this task at:
**kind**
**helm**
**fluff**

### Deploying the laboratory environment
First make sure that you have installed Docker, Helm and Go on your machine.
Then you can run the following command to install Kind:
```bash
go install sigs.k8s.io/kind@v0.22.0
```
After you have successfully installed the forementioned software, you can then run the 
``
./deploy.sh
``
script from the repository root to deploy all the Kubernetes resources.
Wait for the Kubernetes pods to be in Running and READY states, this should take a couple minutes maximum, you can monitor this with:
```bash
kubectl get pods
```
When you have all the pods in a Running and READY state, you can then use the following script to portforward the necessary resources for access on the 127.0.0.1:
```bash
./access.sh
```

### Finding hidden endpoints

### Acquiring environment credentials

### Getting access to the database

### Acquiring additional information with git-dumper

### Accessing the database with superuser credentials from remote


### 


---
## Task 3

---
## Task 4




