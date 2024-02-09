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

* **hping3** - Intro to [hping3](https://www.kali.org/tools/hping3/)
* **nmap** - Host discovery with [nmap](https://nmap.org/book/man-host-discovery.html) nmap on [Wikipedia](https://en.wikipedia.org/wiki/Nmap)
* **terraform** - Basic tutorial about what is terraform [here](https://k21academy.com/terraform-iac/terraform-beginners-guide/)
* **ICMP** - [ICMP](https://en.wikipedia.org/wiki/Internet_Control_Message_Protocol)
* **pfSense** - Official documentation of pfSense [here](https://docs.netgate.com/pfsense/en/latest/install/assign-interfaces.html)
* **wireshark** - Covered in pre-requisite courses. Official documentation [here](https://www.wireshark.org/docs/wsug_html/)
* **icmpdoor** - Github repository [here](https://github.com/krabelize/icmpdoor)

If you feel like your networking knowledge needs a revision, go through these tutorials:
[Basic tutorial 1](https://www.hackers-arise.com/post/networking-basics-for-hackers-part-1)
[Basic tutorial 2](https://www.hackers-arise.com/post/networking-basics-for-hackers-part-2)

Further reading about [networking concepts](https://docs.netgate.com/pfsense/en/latest/network/index.html)

## Grading

<!-- <details><summary>Details</summary> -->

Task #|Points|Description|
-----|:---:|-----------|
Task 1 | 1 | Install and setup the network
Task 2 | 2 | Run the virtual network
Task 3 | 3 | Host discovery in LAN
Task 4 | 4 | ICMP Tunneling Attack
Task 5 | 5 | Accessing HTTP Server from outside LAN


Total points accumulated by doing the exercises reflect the overall grade. You can acquire up to 5 points per whole exercise.
<!-- </details> -->

---


## About the lab

* This document contains task descriptions and theory for the network security lab. If there are any differences between the return template and this file, consider this to be the up-to-date document.
* **You to use your own computer/virtual machine if you want.** Check the chapter "**Setup Installation**" for information on what you need to install. This lab has been made to be completed in a Linux environment and tested to work in debian, ubuntu and the provided Arch Linux virtual machine.
* __Upper scores for this assignment require that all previous tasks in this assignment have been done as well__, so e.g. in order to get the third point you will have to complete tasks 1, 2 & 3.
* Check the deadline from Moodle and __remember that you have to return your name (and possibly people you worked together with) and GitHub repository information to Moodle before the deadline.__


## Background

This week’s theme is network security.
Tasks are designed to be done with the provided network setup using [terraform](https://en.wikipedia.org/wiki/Terraform_(software)), see the [terraform commands tutorial](https://tecadmin.net/terraform-basic-commands/) for instructions on how to run the network using terraform. The firewall (+router) used in this network is [pfSense](https://docs.netgate.com/pfsense/en/latest/general/index.html).
The provided VM's within terraform has all the required tools preinstalled.  Contact course assistants if you require any extra tools, they'll install them in a custom image for you and provide instructions how to use it within the setup. 



## INTRODUCTION TO THE NETWORK SETUP

The virtual test network is based on two networks:
1. WAN
2. LAN

The WAN is your standard computer network. The LAN is the internal network which contains HTTP server (Ubuntu) and probe machine (kali) protected by pfSense firewall which also
acts as the default router for this. By default, WAN is not allowed to communicate or discover the LAN network.

In this lab, we will first explore some techniques to discover hosts within the internal LAN network using [nmap](https://en.wikipedia.org/wiki/Nmap) and [ICMP](https://en.wikipedia.org/wiki/Internet_Control_Message_Protocol) requests. Students will observe traffic packets using pfSense traffic capture tool. Towards the end of lab, students will perform an actual ICMP tunneling attack and transfer a .txt file using modified packets.

The internal LAN network consists of following machines

 * Kali linux (attack machine)

 * Ubuntu linux (server)

 * Router & Firewall (pfSense) - to protect the internal LAN network and shield it from outside

**TODO**

##INSERT NETWORK IMAGE HERE



Now that we know the basics of virtual network setup, let’s get into the lab task. Task 1 is about setting up the network by installing required pre-requisite softwares

---

## Task 1

### Setup Installation 

The network structure in this lab is built upon terraform. Terraform is a tool for deploying infrastructure as a code. Here, it is used to spawn the network infrastructure resources virtually using code configurations in terraform files (which is already done for you). A set of certain software dependencies are required to achieve this such as Libvirt, QEMU and KVM. Therefore, to make the network structure work, you'll have to follow the guidelines below. The instruction set has been tested on ubuntu/debian-linux as well as arch linux. Install guide for arch linux can be accessed here **TO_DO_ARCH_GUIDE_LINK**

### Install and setup libvirtd and necessary packages for UEFI virtualization
```
sudo apt update
sudo apt-get install qemu-kvm libvirt-daemon-system virt-top libguestfs-tools ovmf
sudo adduser $USER libvirt
sudo usermod -aG libvirt $(whoami)
```

Start and enable libvirtd
```
sudo systemctl start libvirtd
sudo systemctl enable libvirtd
```

### Install terraform

Follow specific instructions for your system

https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

**Verify terraform is accessible and the CLI works**
```
which terraform
terraform --version
```


### Install virt-manager for VM accessibility
```
sudo apt-get install virt-install virt-viewer
sudo apt-get install virt-manager
```

### Install qemu and verify the installation
https://www.qemu.org/download/#linux
```
qemu-system-x86_64 --version
```
### Download the relevant images & place them in the directory containing main.tf

**TO DO**
GENERATE NEW LINKS

{Insert the custom pfSense image path here}

https://cdimage.kali.org/kali-2023.4/kali-linux-2023.4-qemu-amd64.7z

Move the image to terraform-testing directory and rename it opnsense.qcow2

### Install mkisofs
```
sudo apt-get install -y mkisofs
```

### Install xsltproc 
```
sudo apt-get install xsltproc
```

### Initialize default storage pool if it hasn't been created by libvirt

```
sudo virsh pool-define /dev/stdin <<EOF
<pool type='dir'>
  <name>default</name>
  <target>
    <path>$PWD/images</path>
  </target>
</pool>
EOF

sudo virsh pool-start default
sudo virsh pool-autostart default
```

### Configure user permisions for libvirt to storage pool
```
sudo chown -R $(whoami):libvirt ~/images
sudo systemctl restart libvirtd
```


### Using Terraform to deploy the network
```
export TERRAFORM_LIBVIRT_TEST_DOMAIN_TYPE="qemu"
terraform init
terraform apply
```

---
## Task 2

### Run the virtual network

If you've successfully installed all the required softwares, you're now set to download and clone the network setup from Github and initialize it using terraform.
Following this, you'll use virtual manager to access the virtual resources spawned by terraform. 

**A) Clone the master branch which contains network configuration for this lab. Go into terraform-testing folder and initialize terraform and deploy the configuration**

```shell
git clone https://github.com/lsuutari19/master_thesis_stuff
```

Useful commands:
```
terraform init
terraform validate
terraform apply
terraform destroy
terraform plan
```
Note: It can take few minutes to deploy the network structure, so be paitent

**Provide commands used**

**How many resources does terraform prompt in the Plan to create/add?**

**Provide screenshot if Apply completed successfully**

**B) Access virtual manager and open virtual machine**s

```shell
# Command to access virtual manager
virt-manager
```

**How many virtual machines do you see? Where do you see the pfSense firewall deployed**

**Provide screenshot**

**C) Configure LAN Network using pfSense CLI and access webGUI from kali linux**

PfSense boots with default configuration for LAN network. Your task it to configure it correctly and build a LAN network valid for the configuration provided below.
If done correctly, you should be able to access the pfSense WebGUI from machines on your virtual LAN network (such as kali and ubuntu server).

IMPORTANT: After configuring LAN network using pfSense CLI, you'll have to reboot your kali and ubuntu linux for new network configurations to take effect.
Simply go to terminal and use
```shell
sudo reboot
```

```
LAN Network Specifications:

Internal LAN Network which contains kali linux, ubuntu server and pfSense acting as a router.
The network operates on sub-net mask 255.255.255.0 (/24)
PfSense is assigned following IP: 10.0.0.1

The IP address range for network is as follows:
Start address: 10.0.0.11 (/24)
End address: 10.0.0.100 (/24)

DHCP Server enabled: Yes
IPv6: No

Protocol for webGUI: HTTPS

```
![image](https://github.com/ouspg/CloudAndNetworkSecurity/assets/113350302/e32f328b-c8c3-4232-aef5-b95085a61d7f)

To help you get started: select option 1) and assign interfaces as follows:

WAN ---> vtnet0
LAN ---> vtnet1
OPT1 ---> vtnet2

Proceed to option 2) and use LAN Network Specification guide provided above to build a LAN network.
This process is easy enough and should allow you to correctly setup the LAN network. Useful [guide](https://docs.netgate.com/pfsense/en/latest/install/assign-interfaces.html)

**Reboot kali linux**

**What is the IP address of your kali linux? Is it on correct LAN network? How can you test and confirm?**

**Access the webGUI from your kali linux. Provide screenshot**

Congratulations if you've successfully accessed the webGUI of pfSense. With this portal, you can configure firewall rules, utilized diagnostic tools, observed network traffic and much more.
Use following default credentials to login as root

_Username:_ admin

_Password:_ pfsense


---



## Task 3

### Host discovery

### Discovering hosts inside the LAN network

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

---

## Task 3

### File transfer through ICMP Tunneling

In the realm of network adversary tactics, one commonly employed technique is Protocol Tunneling, denoted by MITRE as T1572. This method involves encapsulating data packets within a different protocol, offering a means to obscure malicious traffic and provide encryption for enhanced security and identity protection.


When discovering hosts, ICMP is the easiest and fastest way to do it. ICMP stands for Internet Control Message Protocol and is the protocol used by the typical PING command to send packets to hosts and see if they respond back or not.
You could try to send some ICMP packets and expect responses. The easiest way is just sending an echo request and expect from the response. You can do that using a simple ping or using fping for ranges.
Moreover, you could also use nmap to send other types of ICMP packets (this will avoid filters to common ICMP echo request-response).

In this task, you will perform and ICMP tunneling attack from your kali (attack machine) to server (ubuntu linux).

[hping3 tutorial](https://www.hackers-arise.com/post/port-scanning-and-reconnaissance-with-hping3)

---

## Task 4

### ICMP Tunneling Attack

### Establish a reverse shell connecton between server and your kali linux

In the previous task you discovered how ICMP packets can be used to transfer data despite having a firewall in place. In this task, you'll take this concept one step further and establish a reverse shell session
between the server (ubuntu) and kali machine. Using reverse shell, you'll extract the server info.

This is a free form task where you can use tool of your choice

https://github.com/krabelize/icmpdoor?tab=readme-ov-file


---

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

hping3
sudo apt install hping3

**A) Run tunnel on server (victim) on port 1234. Then modify the client.sh file on kali linux (attacker)**

```shell
#Run tunnel on server with:
sudo ./icmptunnel -s -p 1234

#Active listening using netcat (not relevant. It listens on port 4444)
nc -lvnp 4444

#Run and remove tun0 interface if needed to start again
ifconfig -a
sudo ip link del dev tun0
```

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

===================================
DOING ATTACK STEP BY STEP
===================================

 o **Attack machine:** Send message to linux kernal to disable loop-back ping: echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_all
 Tunnel should not respond to packets to itself (8min)
 
 ```shell
 echo 1 | sudo tee /proc/sys/net/ipv4/icmp_echo_ignore_all
```
![image](https://github.com/ouspg/CloudAndNetworkSecurity/assets/113350302/9d7434c6-3fce-4f99-b606-0800734b2ced)


 o **Server machine:** Run the tunnel server
 ```
#  sudo ./icmptunnel -s
# Create tun0
ubuntu@ubuntu1804:~/cyberII/icmptunnel$ sudo ip tuntap add mode tun tun0
ubuntu@ubuntu1804:~/cyberII/icmptunnel$ sudo ip link set tun0 up

# Assign interface tun0 IP address
sudo ip addr add 10.0.1.1/255.255.255.0 dev tun0

 ```

 o **Attack machine:** Run the tunnel server
 ```
  sudo ./icmptunnel -s
# Create tun0
ubuntu@ubuntu1804:~/cyberII/icmptunnel$ sudo ip tuntap add mode tun tun0
ubuntu@ubuntu1804:~/cyberII/icmptunnel$ sudo ip link set tun0 up

# Assign interface tun0 IP address
sudo ip addr add 10.0.1.2/255.255.255.0 dev tun0

 ```
```
 tcpdump -vv -XXX -i tun0 icmp
```
 

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

