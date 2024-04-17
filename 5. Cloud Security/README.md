Cloud and Network Security Lab 5: Cloud Security
====

Responsible person/main contact: Niklas Saari, Lauri Suutari & Asad Hasan

## Preliminary tasks & prerequisites

This is the fifth lab in the series with the theme of Cloud Security. 
You should return the tasks to GitHub.

Make yourself familiar with the following topics:


* **Kubernetes** - Read about Kubernetes on [Wikipedia](https://en.wikipedia.org/wiki/Kubernetes)
* [OAuth 2.0](https://en.wikipedia.org/wiki/OAuth) and [OpenID](https://en.wikipedia.org/wiki/OpenID).


## Grading

<!-- <details><summary>Details</summary> -->

You are expected to do the assignments in order. Upper scores for this assignment require that all previous tasks in this assignment have been done as well, so e.g. in order to get the third point you will have to complete tasks 1, 2 & 3.



| Task # | Points | Description                                                                               |
| ------ | :----: | ----------------------------------------------------------------------------------------- |
| Task 1 |   1    | Explain cloud security concepts OR analyse the task 2 environment                         |
| Task 2 |   1    | Setup environment. Spawn required resources. Insecure endpoints and environment variables |
| Task 3 |   1    | Perform Kubernetes Goat tutorials                                                         |
| Task 4 |   2    | OAuth 2.0 and OpenID Connect                                                              |


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

1) Authentication and Access Control: Cloud security protocols implement mechanisms to verify the identity of users and devices accessing cloud services. This involves employing strong authentication methods such as multifactor authentication (MFA) and enforcing granular access controls to restrict privileges based on user roles and responsibilities.

2) Data Encryption: Encrypting data both in transit and at rest is essential for safeguarding sensitive information stored in the cloud. Encryption algorithms are utilized to encode data, ensuring that even if intercepted, it remains unintelligible to unauthorized parties.

3) Compliance and Regulatory Requirements: Cloud security measures must align with industry-specific regulations and compliance standards such as GDPR, HIPAA, and PCI DSS. Adhering to these standards helps ensure the confidentiality, integrity, and availability of data stored in the cloud while mitigating legal and financial risks.

4) Threat Detection and Incident Response: Cloud security protocols employ advanced monitoring and threat detection tools to identify suspicious activities and potential security breaches in real-time. Prompt incident response strategies are implemented to mitigate the impact of security incidents and restore normal operations swiftly.

5) Infrastructure Protection: Securing the underlying infrastructure of cloud platforms is crucial for preventing unauthorized access and data breaches. This involves implementing firewalls, intrusion detection and prevention systems (IDPS), and security patches to fortify cloud-based servers, networks, and storage resources.

Common cloud security technologies and protocols include Identity and Access Management (IAM), Transport Layer Security (TLS), Virtual Private Networks (VPNs), and Security Information and Event Management (SIEM) systems.


---

## Task 1, Option A: Basics of cloud security (1p)

> [!Important]
> You have an option to write short essay from cloud security, or make a short analysis about the Kubernetes environment in task 2 and further. 

### Explain cloud security concepts

### A) What is the basic concept of cloud security?

Answer should be no more than a sentence.

### B) What are the key components of cloud security?

Write a paragraph with max word limit of 200 words

### C) Surf the internet to find major cloud provisioning platforms. Highlight key security aspects of two of these cloud service providers are marketing. Do you think they are relevant?

Write a paragraph with max word limit of 200 words

### D) Pick two points from part B) and explain what could go wrong if those security measures were not in place. Describe with imaginary scenarios.

Write a paragraph with max word limit of 200 words

>[!Note]
> Short and to-the-point answers (within prescribed limits) in this task will get you full marks!

---

## Task 1, Option B: Analyse the Kubernetes environment (1p)

In the following task 2, we provide a Kubernetes cluster, which includes a lot of different services.
The cluster has only single node and this node contains multiple deployments and other controllers.
In Kubernetes, we talk a lot about pods; they **are essentially one or more OCI containers from the previous week.** 
A group of containers which are always co-located and co-scheduled, and run in a shared context. 

Check the basic [overview description](https://kubernetes.io/docs/concepts/overview/) about Kubernetes, its [components](https://kubernetes.io/docs/concepts/overview/components/), and [cluster architecture](https://kubernetes.io/docs/concepts/architecture/).

It is useful to get a more knowledge about how Kubernetes and `kubectl` works, if you don't have any yet.
You can already start setting up the cluster on this task, and your job is to discover what components this cluster contains.

Instead of using the script to launch the services, you can check the script contents and run them one by one.

*Note that not all the services or deployments have relations with each other.*

Essentially, all you need is `kubectl` command to operate with cluster.  `kubectl` is a client which operates with Kubernetes API, which is in the master node, as part of *the control plane*.

Check for relevant [documentation](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands).
The most important commands are `kubectl get` and `kubectl describe` to make an understanding about the clusters.

For example, to get good overview of the single pod, you can run `kubectl describe pod <podname>`.

You need to **produce a graph about the provided cluster architecture**, and 

* Briefly explain what is an Ingress controller and describe what access points it is exposing to the public.
* Briefly explain what Services are and what are exposed to Ingress controller or otherwise made accessible from outside in this cluster.
* What pods are running in the cluster?
* Think about different attack surfaces on this cluster, based on all the previous.

If you want to integrate graphs directly into GitHub, check [Mermaid syntax](https://mermaid.js.org/), its [live tool](https://mermaid.live) and [how to use with GitHub](https://docs.github.com/en/get-started/writing-on-github/working-with-advanced-formatting/creating-diagrams).

## Task 2: Poor Web Application (1p)

In cloud development, environment variables play a crucial role in configuring and customizing applications and services deployed in cloud environments. Environment variables are dynamic values that can affect the behaviour of software applications without changing their codebase.
They provide a flexible and portable way to manage configuration settings across different deployment environments, such as development, testing, and production.

This task involves intentionally vulnerable Kubernetes deployments and services that you are to exploit using multitude of tools such as `ffuf` or `gobuster` and a tool to access the database from outside the Kubernetes cluster. The idea is to get deeper and deeper into the system as you progress through the stages and use the information found during the task to find different flags. This task can be completed on both Linux and Windows machines, but it is easier to use the tools with a UNIX operating system, and there are shell scripts for creating the environment in bash. You can use any tool of your choice for managing the Kubernetes cluster, but the course staff recommends using Kind for this as it is what the task is developed with. 

You can read more about the tools used during this task at:
* **Kind** - [Kind documentation](https://kind.sigs.k8s.io/)
* **Helm** - [Helm documentation](https://helm.sh/docs/)
* **`ffuf`** - [ffuf GitHub repo](https://github.com/ffuf/ffuf)

### Deploying the laboratory environment

First make sure that you have installed Docker, Helm and Go on your machine. Also make sure to have your Docker engine or Docker desktop running.

Then you can run the following command to install Kind:

```bash
go install sigs.k8s.io/kind@v0.22.0
```
After you have successfully installed the forementioned software, you can then run the:

```bash
./deploy.sh
```

script from the CloudAndNetworkSecurity/5. Cloud Security/ directory to deploy all the Kubernetes resources.
Wait for the Kubernetes pods to be in Running and READY states, this should take a couple of minutes at maximum.
You can monitor this with:

```bash
kubectl get pods
```

When you have all the pods in a **Running** and **READY X/X** states, you can then use the following script to port forward the necessary resources for access on the 127.0.0.1:

```bash
./access.sh
```
Confirm that you can access the URL: http://localhost:1230
If you managed to access the URL, then you have successfully deployed the laboratory environment! :boom:

**provide the screenshot of accessing the http://localhost:1230  URL**

>[!Note]
> You can delete all the resources later by running the command "kind delete cluster --name kind-cloudsec"

### Finding hidden endpoints

There are some hidden endpoints in the web application, your first task is to find these endpoints. You can use `ffuf` or `gobuster` for finding these endpoints. The course staff has provided you a wordlist for using these tools in this repository. 

Document how many endpoints you found and describe if there is anything interesting in those endpoints and if they could be potentially exploited.

> **Provide the commands used to find hidden endpoints.**

### Getting access to the database

You should have found an endpoint that points to a database and another that lists the internal filesystem of the pod running the web application.
However, it seems there are some files hidden when accessing the endpoint directly via the front end. Your next task is to find environment variables from the filesystem that could be used to access the database endpoint, one instance in the database contains a flag.

You should find two flags during this process. Document your process and include the flags.

### Accessing the database with superuser credentials from remote

It seems you have gained access to one table in the database that the frontend points to previously, now your task is to access the database with the admin credentials from outside the Kubernetes cluster. For this you need to find a suitable client to connect into the database, you can extract more information about the database with the `kubectl` commands to figure out which kind of client you need for this.

**Provide the command you used to access the database from outside the Kubernetes cluster and the flag that is found in another table in the database.**

---

## Task 3: Perform Kubernetes Goat tutorials (1p)

In this task, you'll complete two Kubernetes Goat tutorials and answer key questions. 

As stated on the official website: “Kubernetes Goat is an interactive Kubernetes security learning playground. It has intentionally vulnerable by design scenarios to showcase the common misconfigurations, real-world vulnerabilities, and security issues in Kubernetes clusters, containers, and cloud native environments.”

Useful resources:
1. Main website of Kubernetes Goat. Click [here](https://madhuakula.com/kubernetes-goat/docs/)
2. GitHub of Kubernetes Goat. Click [here](https://github.com/madhuakula/kubernetes-goat)

>[!Important]
> You'll use the deployment from task 2 to complete these tutorials.
> Provided tutorials are one way to complete the tasks. You can try different approaches and commands too.

### A) Perform tutorial: SSRF in the Kubernetes (K8S) world

The tutorial can be accessed [here.](https://madhuakula.com/kubernetes-goat/docs/scenarios/scenario-3/ssrf-in-the-kubernetes-world/welcome/)

To get started with the scenario, navigate to http://127.0.0.1:1232

To complete this scenario, you need to obtain the k8s-goat-FLAG flag value in the metadata secrets.

To obtain full marks, add required screenshots and answer questions in the end

Add following screenshots as your answer:
1. When you query the port 5000 in the same container http://127.0.0.1:5000 with method GET
2. When you query http://metadata-db with method GET
3. When you guery http://metadata-db/latest/secrets/kubernetes-goat with method GET

Copy and paste your flag and decode it. 

**Provide command used** 

**Copy and paste your decoded flag**

**What do you understand about Server-Side Request Forgery (SSRF) in Kubernetes world after completing this tutorial?**

### B) Perform tutorial: Docker CIS benchmarks analysis

Tutorial can be accessed [here](https://madhuakula.com/kubernetes-goat/docs/scenarios/scenario-5/docker-cis-benchmarks-in-kubernetes-containers/welcome/)

To get started with the scenario, you can deploy the Docker CIS benchmarks DaemonSet using the following command. Notice that this command is slightly different from the tutorial.

```
kubectl apply -f deployments/docker-bench/docker-bench-security.yaml
```

To exec into the pod, run the following command. Make sure to replace the pod name with correctone.e

```
kubectl exec -it docker-bench-security-xxxxx -- sh
```

The goal of this scenario is to perform the Docker CIS benchmark audit and obtain the results from the audit.

To obtain full marks, add required screenshots and answer questions in the end

Add following screenshots as your answer:
1. When you execute 'sh docker-bench-security.sh'
2. When you obtain final benchmark results

**Why Docker CIS benchmarks is useful? How could it help improve the overall security of the cloud infrastructure?**

## Task 4: OAuth 2.0 and OpenID Connect (2p)

The idea of [Single Sign-On (SSO)](https://en.wikipedia.org/wiki/Single_sign-on) is used a lot in modern web and cloud-based services. 
In short, you use a single account to log in to different platforms or services, at once.
For example, consider a scenario when you log in to a Google service such as Gmail, you are automatically authenticated to YouTube and other Google apps.

The above, and most of the other modern authentication in web, mobile devices, API endpoints and other cloud native environments are mainly based on [OAuth 2.0 protocol](https://oauth.net/2/) and its extension [OpenID Connect](https://openid.net/developers/how-connect-works/).

The older other common protocol, [SAML](https://en.wikipedia.org/wiki/Security_Assertion_Markup_Language), is still prevalent in many enterprise environments, while OAuth 2.0 -based protocols are starting to slowly replace them.

OAuth 2.0 provides the authorization framework, whereas the OpenID Connect adds authentication and identity verification part. Essentially, they federate authentication scenarios.

### Getting started

On this task, we try to make a simple implementation in the Kubernetes environment.
We will continue with the [Flask](https://flask.palletsprojects.com/en/3.0.x/)framework, which was used on task 2 to deploy the webservice.
