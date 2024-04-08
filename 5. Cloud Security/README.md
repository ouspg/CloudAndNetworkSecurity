Cloud and Network Security Lab 5: Cloud Security
====

Responsible person/main contact: Niklas Saari, Lauri Suutari & Asad Hasan

## Preliminary tasks & prerequisites

This is the fifth lab in the series with the theme of Cloud Security. 
You should return the tasks to GitHub.

Make yourself familiar with the following topics:


* **Kubernetes** - Read about kubernates on [Wikipedia](https://en.wikipedia.org/wiki/Kubernetes)
* TODO
* TODO


## Grading

<!-- <details><summary>Details</summary> -->

You are expected to do the assignments in order. Upper scores for this assignment require that all previous tasks in this assignment have been done as well, so e.g. in order to get the third point you will have to complete tasks 1, 2 & 3.



Task #|Points|Description|Tools
-----|:---:|-----------|-----
Task 1 | 1 | Explain cloud security concepts. Provide theoretical scenario and ask how would they improve security of the cloud | TBD
Task 2 | 1 | Setup environment. Spawn required resources. Misconfiguration task | TBD
Task 3 | 1 | Another misconfiguration task | TBD
Task 4 | 1-2 | Misconfigured SAML/Oauth2 | TBD


Total points accumulated by doing the exercises reflect the overall grade. You can acquire up to 5 points from the whole exercise.
<!-- </details> -->

---


## About the lab

* **You are encouraged to use your own computer or virtual machine if you want.** However, the use of a Linux machine is necessary. 
* Check the deadline from Moodle and __remember that you have to return your name (and possibly people you worked together with) and GitHub repository information to Moodle before the deadline.__


## Background

This week’s theme focuses on cloud security.

Cloud security refers to the set of practices, technologies, and policies designed to protect data, applications, and infrastructure hosted in cloud environments. With the widespread adoption of cloud computing, ensuring the security of cloud-based resources has become paramount for organizations of all sizes.

Key aspects of cloud security include:

1) Authentication and Access Control: Cloud security protocols implement mechanisms to verify the identity of users and devices accessing cloud services. This involves employing strong authentication methods such as multi-factor authentication (MFA) and enforcing granular access controls to restrict privileges based on user roles and responsibilities.

2) Data Encryption: Encrypting data both in transit and at rest is essential for safeguarding sensitive information stored in the cloud. Encryption algorithms are utilized to encode data, ensuring that even if intercepted, it remains unintelligible to unauthorized parties.

3) Compliance and Regulatory Requirements: Cloud security measures must align with industry-specific regulations and compliance standards such as GDPR, HIPAA, and PCI DSS. Adhering to these standards helps ensure the confidentiality, integrity, and availability of data stored in the cloud while mitigating legal and financial risks.

4) Threat Detection and Incident Response: Cloud security protocols employ advanced monitoring and threat detection tools to identify suspicious activities and potential security breaches in real-time. Prompt incident response strategies are implemented to mitigate the impact of security incidents and restore normal operations swiftly.

5) Infrastructure Protection: Securing the underlying infrastructure of cloud platforms is crucial for preventing unauthorized access and data breaches. This involves implementing firewalls, intrusion detection and prevention systems (IDPS), and security patches to fortify cloud-based servers, networks, and storage resources.

Common cloud security technologies and protocols include Identity and Access Management (IAM), Transport Layer Security (TLS), Virtual Private Networks (VPNs), and Security Information and Event Management (SIEM) systems.


---

## Task 1

### Explain cloud security concepts




### A) TODO 

### B) Surf the internet to find major cloud provisioning platforms. Highlight key security aspects of two of these cloud service providers

### C) Pick two points from part B) and explain what could go wrong if those security measures were not in place. Describe with imaginery scenarios.


## Task 2
This task involves intentionally vulnerable Kubernetes deployments and services that you are to exploit using multitude of tools such as Gobuster, Dirbuster, git-dumper and a tool to access the database from outside the Kubernetes cluster. The idea is to get deeper and deeper into the system as you progress through the stages and use the information found during the task to find different flags. This task can be completed on both Linux and Windows machines, but it is easier to use the tools with an UNIX operating system. You can use any tool of your choise for managing the Kubernetes cluster, but the course staff recommends using Kind for this as it is what the task is developed with. Follow this [link](https://kind.sigs.k8s.io/) for instructions in installing Kind to your machine

You can read more about the tools used during this task at:
* **Kind** - [Kind documentation](https://kind.sigs.k8s.io/docs/)
* **Gobuster**
* **Dirbuster**
* **git-dumper**

### Setting up the environment

### Finding hidden endpoints

### Acquiring environment credentials

### Getting access to the database

### Acquiring additional information with git-dumper

### Accessing the database with superuser credentials from outside the Kubernetes Cluster




