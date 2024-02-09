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

Make yourself familiar with following.

* **hping3** - Intro to [hping3](https://www.kali.org/tools/hping3/)
* **nmap** - Host discovery with [nmap](https://nmap.org/book/man-host-discovery.html) nmap on [Wikipedia](https://en.wikipedia.org/wiki/Nmap)
* **terraform** - Basic tutorial about what is terraform [here](https://k21academy.com/terraform-iac/terraform-beginners-guide/)
* **ICMP** - [ICMP](https://en.wikipedia.org/wiki/Internet_Control_Message_Protocol)
* **pfSense** - Official documentation of pfSense [here](https://docs.netgate.com/pfsense/en/latest/install/assign-interfaces.html)
* **wireshark** - Covered in pre-requisite courses. Official documentation [here](https://www.wireshark.org/docs/wsug_html/)
* 
* **icmpdoor** - Github repository [here](https://github.com/krabelize/icmpdoor) ????

If you feel like your networking knowledge needs a revision, go through these tutorials:
[Basic tutorial 1](https://www.hackers-arise.com/post/networking-basics-for-hackers-part-1)
[Basic tutorial 2](https://www.hackers-arise.com/post/networking-basics-for-hackers-part-2)

Further reading about [networking concepts](https://docs.netgate.com/pfsense/en/latest/network/index.html)

## Grading

<!-- <details><summary>Details</summary> -->

Task #|Points|Description|Tools
-----|:---:|-----------|-----
Task 1 | 1 | Install and setup the network | Terraform, libvirt, Qemu, KVM
Task 2 | 2 | Run the virtual network | pfSense, terraform, virtual manager
Task 3 | 3 | Host discovery in LAN | Nmap
Task 4 | 4 | ICMP Tunneling Attack | Hping3, Wireshark, tshark
Task 5 | 5 | Accessing HTTP Server from outside LAN | Open-ended


Total points accumulated by doing the exercises reflect the overall grade. You can acquire up to 5 points per whole exercise.
<!-- </details> -->

---


## About the lab

* This document contains task descriptions and theory for the network security lab. If there are any differences between the return template and this file, consider this to be the up-to-date document.
* **You are encouraged to use your own computer or virtual machine if you want.** Check the Task 1 "**Setup Installation**" for information on what you need to install. This lab has been made to be completed in a Linux environment and tested to work in debian, ubuntu and the provided Arch Linux virtual machine.
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

**Install and setup libvirtd and necessary packages for UEFI virtualization**
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

**Install terraform**

Follow specific instructions for your system

https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

**Verify terraform is accessible and the CLI works**
```
which terraform
terraform --version
```


**Install virt-manager for VM accessibility**
```
sudo apt-get install virt-install virt-viewer
sudo apt-get install virt-manager
```

**Install qemu and verify the installation**
https://www.qemu.org/download/#linux
```
qemu-system-x86_64 --version
```
**Download the relevant images & place them in the directory containing main.tf**

**TO DO**
GENERATE NEW LINKS

{Insert the custom pfSense image path here}

https://cdimage.kali.org/kali-2023.4/kali-linux-2023.4-qemu-amd64.7z

Move the image to terraform-testing directory and rename it opnsense.qcow2

**Install mkisofs**
```
sudo apt-get install -y mkisofs
```

**Install xsltproc **
```
sudo apt-get install xsltproc
```

**Initialize default storage pool if it hasn't been created by libvirt**

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

**Configure user permisions for libvirt to storage pool**
```
sudo chown -R $(whoami):libvirt ~/images
sudo systemctl restart libvirtd
```


**Using Terraform to deploy the network**
```
export TERRAFORM_LIBVIRT_TEST_DOMAIN_TYPE="qemu"

```

---
## Task 2

### Run the virtual network

If you've successfully installed all the required softwares, you're now set to download and clone the network setup from Github and initialize it using terraform.
Following this, you'll use virtual manager to access the virtual resources spawned by terraform. 

### **A) Clone the master branch which contains network configuration for this lab. Go into terraform-testing folder and initialize terraform and deploy the configuration**

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

---

### **B) Access virtual manager and open virtual machine**s

```shell
# Command to access virtual manager
virt-manager
```

**How many virtual machines do you see? Where do you see the pfSense firewall deployed**

**Provide screenshot**

---

### **C) Configure LAN Network using pfSense CLI and access webGUI from kali linux**

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

Next, reboot kali linux for new network configurations to take affect. Alternativel you can also restart your network adapter using:
```shell
sudo ip link set eth0 down #replace eth0 with your interface name
sudo ip link set eth0 up
```

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

### **A) How many hosts are present in the internal LAN network? What are their IP addresses?**

**Provide commands**

**Screenshot**

---

### **B) Now try running the same command from outside the LAN network? Are you able to discover devices inside the internal LAN network? Explain your answer**

---

### **C) Extracting more host info using NMAP**

Use the -PE, -PP, -PM flags of nmap to perform host discovery sending respectively ICMPv4 echo, timestamp, and subnet mask requests. 

**Provide command used to do this**


**What extra information did you gather using this? Paste screenshot**


---

## Task 4

### File transfer through ICMP Tunneling

In the realm of network adversary tactics, one commonly employed technique is Protocol Tunneling, denoted by MITRE as T1572. This method involves encapsulating data packets within a different protocol, offering a means to obscure malicious traffic and provide encryption for enhanced security and identity protection.


When discovering hosts, ICMP is the easiest and fastest way to do it. ICMP stands for Internet Control Message Protocol and is the protocol used by the typical PING command to send packets to hosts and see if they respond back or not.
You could try to send some ICMP packets and expect responses. The easiest way is just sending an echo request and expect from the response. You can do that using a simple ping or using fping for ranges.
Moreover, you could also use nmap to send other types of ICMP packets (this will avoid filters to common ICMP echo request-response).

ICMP packets can be modified to include information in their payloads. The data portion of ICMP (Internet Control Message Protocol) packets, known as the payload, can be altered to include additional information beyond what is typically included in standard ICMP packets.In this task, you will perform ICMP tunneling to transfer a .txt file from server (ubuntu linux) to kali linux using hping3.

[hping3 tutorial](https://www.hackers-arise.com/post/port-scanning-and-reconnaissance-with-hping3)

---

### **A) Send hackers_data.txt file as ICMP packets to kali linux**

ICMP packets can be used for tunneling other protocols or data across networks. By encapsulating data within the payload of ICMP packets, it's possible to transmit information between endpoints without directly using the protocols typically associated with those endpoints. This technique is sometimes used for evasion or bypassing network filtering. In this task, you'll explicitly use hping3 to send the 
text file with ICMP packets and observed the received packets through wireshark.

For converting the file into ICMP packets, you'll be using the hping3 (packet crafting tool). How does it work? See diagram below:

![image](https://github.com/ouspg/CloudAndNetworkSecurity/assets/113350302/bab100c8-da80-4954-9696-d82fbe94738b)

Here's what you need to do:
- Login to server and locate hackers_data.txt
- Craft hping3 command with correct flags and destination address (kali linux) to transfer file as ICMP packets
- Login to kali and open wireshark (or craft tcpdump commands to dump packets once received)
- Send ICMP packets through server and simultaneously monitor the packets from kali linux

_Hint: _Depending on your interface's Maximum Transmission Unit (MTU), each packet has a certain limit of data that it can hold without getting fragmented. For ethernet, you can find out this using 
ifconfig/ip addr commands. Generally it has a value of 1500 for ethernet. However, the actual usable data is:

Maximum ICMP Data=MTU−Ethernet Frame Header−IP Header−ICMP Header

Maximum ICMP Data=1500 bytes−14 bytes−20 bytes−8 bytes

Maximum ICMP Data=1458 bytesMaximum ICMP Data=1458 bytes

The Maximum Transmission Unit (MTU) is the maximum size of a single data unit that can be transmitted over a network.

You should stop the hping3 command when EOF (end of file) prompt is reached
![image](https://github.com/ouspg/CloudAndNetworkSecurity/assets/113350302/6ecbb36c-7364-4d34-9cc1-041f9a6c04ab)


**Provide commands**

**Screenshot**

**Inspect received packets from wireshark. Does the packets contain text from the file? Attach screenshots as a proof**


Make sure you are inspecting the correct packets in wireshark. And save your file as **hacker_data.pcap** for use in next task

**Inspect the Internet Control Message Protocol packet's Data field (which should be 1458 bytes) to observed the filed in which attached data is stored.**

![image](https://github.com/ouspg/CloudAndNetworkSecurity/assets/113350302/d2910021-7adb-4468-9a6b-b6573436eb00)


_Extra Information: _TCPdump is a command-line packet analyzer tool for monitoring and analyzing network traffic on a Unix or Linux system. It captures packets flowing through a network interface and allows users to inspect them in real-time or save them to a file for later analysis. To use TCPdump, you typically specify the network interface to listen on (e.g., eth0), optionally apply filters to capture specific types of traffic, and specify any desired options or output formats. For example, to capture all traffic on interface eth0 and display it on the terminal, you can use the command sudo tcpdump -i eth0.

---

### **B) Pull out (data.data) field from the .pcap file using tshark**

Use **hacker_data.pcap** acquired in previous task to pull out (data.data) field from the .pcap file and dump it into a hexdump.txt file

Use flags -n -q -r with -T fields data.data. Your task is to craft a command which uses tshark to read packets from the file **hacker_data.pcap**, extracts the payload data of each packet in hexadecimal format (data.data), and saves it to the file **hexdump.txt**. The -n flag disables name resolution, -q suppresses unnecessary output, and -T fields specifies the output format.

tshark document for help [here](https://www.wireshark.org/docs/man-pages/tshark.html)

**Provide command**

**Screenshot of output hexdump.txt file**

Next, copy the contents of the hexdump file and use an online hex to ASCII converter [tool](https://www.rapidtables.com/convert/number/hex-to-ascii.html) to restore contents of the original file.

**Were you able to re-construct the original hackers_data.txt file sent using ICMP packets? What are the contents of file? Briefly explain and attach a screenshot**

---

## Task 4 OPTIONAL????

### Establish a reverse shell connecton between server and your kali linux

In the previous task you discovered how ICMP packets can be used to transfer data despite having a firewall in place. In this task, you'll take this concept one step further and establish a reverse shell session
between the server (ubuntu) and kali machine. Using reverse shell, you'll extract the server info.

This is a free form task where you can use tool of your choice

https://github.com/krabelize/icmpdoor?tab=readme-ov-file


---

## Task 5

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

