Cloud and Network Security Lab 1: Network Security
====

Responsible person/main contact: Asad Hasan & Lauri Suutari

## Preliminary tasks & prerequisites

* Create a GitHub account if you don't already have one
* Create your answer repository from the provided link in **TODO**[Moodle space](https://moodle.oulu.fi/course/view.php?id=18470), **as instructed [here](../README.md#instructions)**
* Check the instructions on how to download and use the course's Arch Linux virtual machine
    * Instructions are available [here](https://ouspg.org/resources/laboratories/). You will find the download link from the Moodle workspace.
    * If you want to use your own computer, download and install Virtualbox to run the virtual machine. VMWare Player should work also.


A basic understanding of networking is required. GitHub is required to complete this exercise

Make yourself familiar with following tools.

* **nmap** - [Host discovery with nmap](https://nmap.org/book/man-host-discovery.html)
* **terraform** - [Basic tutorial about what is terraform](https://k21academy.com/terraform-iac/terraform-beginners-guide/)
* 



## Grading

<!-- <details><summary>Details</summary> -->

Task #|Points|Description|
-----|:---:|-----------|
Task 1 | 2 | Set up and run the virtual network
Task 2 | 3 | Host discovery
Task 3 | 4 | ICMP Tunneling Attack
Task 4 | 5 | Firewall Testing?


Total points accumulated by doing the exercises reflect the overall grade. You can acquire up to 5 points per whole exercise.
<!-- </details> -->

---


## About the lab

* This document contains task descriptions and theory for the network security lab. If there are any differences between the return template and this file, consider this to be the up-to-date document.
* **You can use your own computer/virtual machine if you want.** Check the chapter "Prerequisites" for information on what you need to install. This lab has been made to be completed in a Linux environment and tested to work in the provided Arch Linux virtual machine.
* __Upper scores for this assignment require that all previous tasks in this assignment have been done as well__, so e.g. in order to get the third point you will have to complete tasks 1, 2 & 3.
* Check the deadline from Moodle and __remember that you have to return your name (and possibly people you worked together with) and GitHub repository information to Moodle before the deadline.__


## Background

This week’s theme is network security.
Tasks are designed to be done with the provided network setup using [terraform](https://en.wikipedia.org/wiki/Terraform_(software)), see the [terraform commands tutorial]((https://tecadmin.net/terraform-basic-commands/)) for instructions on how to run the network using terraform.
The provided VM's within terraform has all the required tools preinstalled.



## INTRODUCTION TO THE NETWORK SETUP
Fuzz automation is the buzzword for industry standard practice, where software production phases are monitored by fuzz testing jobs which run automatically whenever there are new code changes to look for bugs and vulnerabilities before the software is launched into production.

In this lab, we will first explore the concept of Continuous Integration and Continuous Delivery (CI/CD).
Students will learn how CI/CD pipeline works and how can they design fuzz-testing jobs that can be incorporated into these pipelines.


The concept of CI/CD pipeline

 * Continuous integration (CI) automatically builds, tests, and integrates code changes within a shared repository; then

 * Continuous delivery (CD) automatically delivers code changes to production-ready environments for approval; or

 * Continuous deployment (CD) automatically deploys code changes to customers directly.

The objective of deploying a CI/CD pipeline: A CI pipeline runs whenever there are code changes and is designed to make sure all of the changes work with the rest of the code when it’s integrated.
It should also compile your code, run tests, and check that it’s functional. The CD pipeline goes one step further and deploys the built code into production.

Now that we know the basics of CI/CD, let’s get into the lab task





## TASKS 1-3: CASE SCENARIO

You were recently hired as a Cybersecurity person in TechnoTech – a software company that releases small software products.
TechnoTech is an agile C/C++ software development company that utilizes modern tech stacks such as GitHub to deploy its code and track version changes.
Moreover, TechnoTech follows the latest practices of DevOps.

TechnoTech’s software team recently designed a calculator product for children, which allows them to perform basic mathematical operations i.e. addition, multiplication, subtraction and division.
TechnoTech intends to invoice a manufacturing order for 1000 physical calculators with their code at the back end and incorporate it into mathematics teaching e-books.

As a cybersecurity personnel, you are given the source code of the project.
Your first task is to set up a fuzzer in the project repository and look for bugs.
Your first task is to correctly configure your fuzzer with the project's source code and report back to the developer team with your findings!

You will use CIFUZZ as a fuzzing tool for tasks 1-3.
To build your C++ project correctly with `cifuzz`, you will be using CMake.
Documentation for CMake is widely available online for example:

[CMake Reference](https://cmake.org/cmake/help/latest/index.html)

CMake another [reference](https://cmake.org/cmake/help/latest/guide/tutorial/A%20Basic%20Starting%20Point.html#exercise-1-building-a-basic-project)

**Check *prerequisites* if you haven't at this point!**

---

### Setup Installation

Update your package manager based on your Linux distribution and install the following dependencies:

Cmake, LLVM clang, LCOV, bazel

Sample install instructions for arch-linux below:

#### Install dependencies

```cmd
sudo pacman -S clang llvm lcov python jdk-openjdk zip
```

#### Install bazelisk
```cmd
sudo curl -L https://github.com/bazelbuild/bazelisk/releases/latest/download/bazelisk-linux-amd64 -o /usr/local/bin/bazel

sudo chmod +x /usr/local/bin/bazel
```

#### Install the tool by running the following script:

```cmd
sh -c "$(curl -fsSL https://raw.githubusercontent.com/CodeIntelligenceTesting/cifuzz/main/install.sh)"

```

#### Install docker (preinstalled for Arch)
```
sudo pacman –S docker
```

---

## Task 1

### A) Installing software and dependencies and initializing terraform locally

The developer team has pushed the code of the calculator into the following GitHub repository:
https://github.com/ouspg/ProjectX.git

The source code is present under the ```source``` branch. Clone it locally into your machine with the command:

```cmd
git clone -b source https://github.com/ouspg/ProjectX.git
```

Explore all files within the project to have a better understanding of the project structure.
Take a look at the flowchart below.

![Flowchart Image](./Pictures/fuzzing_with_cifuzz.png)


Hints are left inside files as comments.

Cifuzz works on two important files:

**o _CMakelists.txt:_**
Configuration file for CMake build system.
It defines the build configuration, dependencies, and build instructions for the C++ project.
For the scope of this project, two CMake files are present, one in the root directory and the other in `/src` directory

**o _cifuzz.yaml:_**

Configuration file for CIFuzz.
It specifies the fuzzing target, corpus location, and other fuzzing parameters for CIFuzz to execute the C++ fuzzing process.
Go to your project's root folder and initialize it with command `cifuzz init`
It will create a .yaml file for you that defines the fuzzer's configuration.
You can make changes to this file according to your project needs.

**Provide the command line you used to do this.**

**What did you change in `cifuzz.yaml` and why? Provide explanations**

Once a project is initialized with `cifuzz`, it must be built with a build system like `bazel` or `CMake`.
Also, the project contains multiple C++ files such as a source function, a header file and a main.
Your next task is to correctly configure CMake files
to link and build your project.

**Configure CMake files**
Two CMakelists.txt files are present.
Correctly configure them to build your project with `cifuzz``.
Look for hints within CMake files

---

### **B) Correctly configure LAN network using pfSense 
Create an empty fuzz test template file in folder <ProjectX/test> called ```test1```. You will use this file to write your fuzz test cases in task 2 to generate mutated inputs to test your calculator function.

**Provide the command line you used to do this.**

---

### **C) Access the pfSense WebGUI server from attack machine (kali linux)
By now, your fuzzer should be correctly linked across the calculator project and initialized with an empty test case called ```test1```. Run your fuzzer with this test case!

**Provide the command used to run the fuzzer**

**Paste screenshot**


In-case you are struggling with this task, refer to this cifuzz [example](https://github.com/CodeIntelligenceTesting/cifuzz/tree/main/examples/cmake).

---

## Task 2

### Host discovery

### Discovering hosts inside the network

From your network setup, you know that you're on the network 10.0.0.1/24. Use nmap scan to discover hosts on the network.

**A) How many hosts are present in the internal LAN network? What are their IP addresses?**

```shell
nmap -sn 10.0.0.1/24
Starting Nmap 7.94SVN ( https://nmap.org ) at 2024-02-06 04:19 EST
Nmap scan report for kyber3.cyber.range (10.0.0.1)
Host is up (0.00080s latency).
Nmap scan report for 10.0.0.23
Host is up (0.00084s latency).
Nmap scan report for 10.0.0.24
Host is up (0.00011s latency).
Nmap done: 256 IP addresses (3 hosts up) scanned in 3.68 seconds
```

**B) Now try running the same command from outside the LAN network? Are you able to discover devices inside the internal LAN network? Explain your answer**

**C) Extracting more host info using NMAP**

Use the -PE, -PP, -PM flags of nmap to perform host discovery sending respectively ICMPv4 echo, timestamp, and subnet mask requests. 

**Provide command used to do this**

```shell
sudo nmap -PE -PM -PP -sn -vvv -n 10.0.0.1/24
```

**What extra information did you gather using this? Paste screenshot**
Mac addresses and NIC info

## Task 3

### ICMP Tunneling Attack

In the realm of network adversary tactics, one commonly employed technique is Protocol Tunneling, denoted by MITRE as T1572. This method involves encapsulating data packets within a different protocol, offering a means to obscure malicious traffic and provide encryption for enhanced security and identity protection.


When discovering hosts, ICMP is the easiest and fastest way to do it. ICMP stands for Internet Control Message Protocol and is the protocol used by the typical PING command to send packets to hosts and see if they respond back or not.
You could try to send some ICMP packets and expect responses. The easiest way is just sending an echo request and expect from the response. You can do that using a simple ping or using fping for ranges.
Moreover, you could also use nmap to send other types of ICMP packets (this will avoid filters to common ICMP echo request-response).

In this task, you will perform and ICMP tunneling attack from your kali (attack machine) to server (ubuntu linux).

## Tools & dependencies used in this task (most of it is pre-installed on kali but not ubuntu)
Install make
sudo apt-get install make

Install git
sudo apt install git

Install gcc
sudo apt install build-essential

ICMPtunnel
https://github.com/DhavalKapil/icmptunnel

NMAP
https://github.com/nmap/nmap
sudo apt-get install nmap


**A) Run tunnel on server (victim) on port 1234. Then modify the client.sh file on kali linux (attacker)**

Run tunnel on server with:
sudo ./icmptunnel -s -p 1234

Active listening using netcat (not relevant. It listens on port 4444)
nc -lvnp 4444

Run and remove tun0 interface
ifconfig -a
sudo ip link del dev tun0


Replace <gateway_of_attacker> and <interface_of_attacker> with the gateway and network interface values for the Kali Linux machine (attacker). You can find these values using the route -n command on the Kali Linux machine.

```shell
#!/bin/sh

# Assigining an IP address and mask to 'tun0' interface
ifconfig tun0 mtu 1472 up 10.0.1.2 netmask 255.255.255.0

# Modifying IP routing tables
route del default
# 'server' is the IP address of the proxy server (10.0.0.23 in this case)
# 'gateway' and 'interface' are obtained from the route -n output
route add -host 10.0.0.23 gw 0.0.0.0 dev eth0
route add default gw 10.0.1.1
```
### What does it do? It correctly configures the routing tables for ICMP tunnel

This script configures the tun0 interface, deletes the default route, adds a route to the proxy server (10.0.0.23) via the eth0 interface, and sets a new default route via the tun0 interface.

Run this script on your victim machine (server) after starting the icmptunnel server. Adjust the permissions if needed (chmod +x script_name.sh), and then execute it using ./script_name.sh. This should properly configure the routing tables for the ICMP tunnel.

### Can you ping server from attack machine? How about pfSense? What could be wrong?

When you run a tunneling tool like icmptunnel, it encapsulates the traffic within ICMP packets. If the tunnel is working correctly, standard ICMP tools like ping won't work as expected because the ICMP traffic is being used for the tunnel, not for traditional ping responses.

If your tunnel is running properly, the ICMP packets are carrying your payload between the client (attacker) and server, and they won't respond to regular ICMP requests. This behavior is expected when using ICMP tunneling.



Go to your empty fuzz test template file (test1.cpp) created in task 1 and update it with the correct code to generate input mutations. Afterwards, you will call your function under test in the main program and fuzzer will automatically feed mutated inputs to it using this fuzz test file!

Next two things you need to do with this file:

1. Write your code for the following function. Mutation schemes for integer, character etc goes here

```c++
FUZZ_TEST(const uint8_t *data, size_t size) {
/* Your code */
}
```
2. Include appropriate header files. Check notes below

Notes for fuzz test file:

 o Fuzz test must include the header for the target function _<../src/calculator.h>_ and cifuzz _<cifuzz/cifuzz.h>_

 o Fuzz test file uses the _<fuzzer/FuzzedDataProvider.h>_ header from LLVM. This should be included

 o Create input variables and define their mutation scheme. As an example, if one of the input variables is integer, its mutation scheme can be defined using LLVM’s _FuzzedDataProvide.h_ header as:
 ```int num1 = fuzzed_data.ConsumeIntegral<int8_t>();```

 LLVM [documentation](https://releases.llvm.org/5.0.0/docs/LibFuzzer.html#fuzz-target)

 o After creating input variables (example: num1, num2, and operator), the fuzz test should call the target function under test within this file. Sample call to a function named _‘calculator’_: ```calculator(num1, operator, num2)```

**Copy contents of fuzz test file here**

**Screenshot of the fuzz test file**

---

**B) Update main**

Write unit test cases within your main file (as a call to calculator function). Carefully choose inputs to ensure all functionalities of the calculator are covered alongside edge test cases.

**Provide a screenshot of your test cases**

**How many test cases did you write? Do you think they are enough for the scope of this project? Explain**

---

**C) Run the fuzzer**

By now, `cifuzz` should be correctly integrated with the project and ready to find bugs.
If you are still experiencing issues, go through [this](https://docs.code-intelligence.com/getting-started/ci-fuzz-cpp-first-bug) tutorial.


Run your fuzzer and report your findings.

**The command used to run fuzzer**

**Name of bugs, if found any. What do they represent?**

---

**D) Generate a code-coverage report and write a brief summary about what it represents**

Code coverage is an important concept in modern fuzzers and is utilized by `cifuzz`.
It measures how much of the target program's code is exercised by the generated test cases.
Cifuzz has an option to generate coverage reports of fuzzer runs.
Go ahead and generate a report and document what it represents and why is it important.

**The command used to generate code-coverage**

**Screenshot of your code-coverage report**

**Brief Summary**


---


## Task 3

### A) Apply patch fix and fuzz again

Based on your previous fuzzing efforts a bug identified was forwarded to the developer team for a fix.
The developer team has fixed the reported bug and has created a patch fix for it.

Your task is to do the following:
* **Download and extract the patch into your project's root directory** Download [Patch File](./files/0001-Updated-calculator-code.tar.xz).

* **Apply the patch using**:

```shell
git apply --check /path/to/your/patch-file.patch
git apply /path/to/your/patch-file.patch
```
* After successfully applying the patch, run fuzzer again

**What bugs did you discover now? Explain what they represent if found any? Is the bug found in task 2 fixed in this patch?**

**Add screenshot**

---

### B) Design a fuzzer job

Your next task is to automate the process of fuzzing for the project calculator.
The latest version of ProjectX has been packed into Docker by the DevOps team and they have left following note:

      **_Notes from DevOps_**
      ProjectX now comes packed into a Docker container with a fuzzer integrated. Moreover, we changed the build system from CMake to bazel.

      Newer version of ProjectX contains the following:
      * All ProjectX C++ files
      * Project built with bazel instead of CMake
      * Cifuzz integrated
      * Fuzzer set to timeout after 10 minutes to save resources
      * Docker container


Here's the GitHub [link](https://github.com/ouspg/ProjectX2) to the latest version.

**Implement [this](https://github.com/ouspg/ProjectX2) project on your return repository and using GitHub actions, design a fuzzing job that does the following:**
* Triggers for main branch on every pull/commit request
* Calls the script to build the Dockerfile into a container
* Runs the Docker container

Test your fuzz job in GitHub actions by making small changes to code such as adding an extra space line.
Commit changes and this should trigger your workflow to run.

**Investigate workflow run logs**

Inspect workflow run to locate fuzzing results. **Paste screenshots showing all results and fuzzing summary**

If workflow fails to run, try to debug it for errors. You might be doing something wrong. Latest project repository
provided by DevOps contains a README.md file with steps how to procced.


The idea behind fuzz automation is that the fuzzer runs automatically for a specified duration whenever there are code changes.
Since TechnoTech utilizes GitHub, your fuzzer should trigger on any latest commit.
Fuzzing results can be gathered from the workflow (actions) log files and can also be exported to an external file by including the appropriate code in your workflow file.



---

## Task 4

### Implement CI pipeline and fuzz an existing software or a project w.r.t. automation

This is a free-form task where you will integrate a fuzzer into an existing project and design a CI pipeline that triggers on each pull/commit request.

Here's what you need to do:
* Find a project or use one of your own
* Create a repository in Github and upload your project there
* Clone the repository and work to integrate a fuzzer of your choice
* Push the changes and design a Github actions workflow
* GitHub actions workflow file should trigger fuzzer on each code change and log results
* A better-implemented workflow would store bugs found as artifacts

There is no restriction to the choice of software or platform that students use for this task.
The main idea behind this task is to integrate fuzz automation into existing software. **If you want to design a CI pipeline outside
GitHub you are free to do so, but discuss it with TAs before-hand.**

This task can be completed with cifuzz or any other fuzzer that supports continuous integration (CI) such as:
- [OSS-fuzz](https://github.com/google/oss-fuzz)
   Sample guide: https://google.github.io/oss-fuzz/getting-started/continuous-integration/

- [ClusterFuzzLite](https://google.github.io/clusterfuzzlite/)

For CI, Gitlab can also be used:
- https://docs.gitlab.com/ee/user/application_security/coverage_fuzzing/



If you are unable to find any project for this task, you can utilize the source code of [ProjectX](https://github.com/ouspg/ProjectX) but this might not give you full 2 points. Therefore, it is recommended to pick up a project
from Github, fork it and try to fuzz automate it. 2 points will be awarded for a well-implemented CI pipeline with fuzz automation.

**Document your work properly for this task and include necessary screenshots and commands used**

**You should state clearly which project and fuzzer you are going to use and on which platform CI pipeline would be implemented**

**Include a link to your project repository/work. Make sure to test the pipeline and share fuzzing results and/or logs**

**In case of partial implementation, write a brief report on issues and roadblocks encountered**


---

