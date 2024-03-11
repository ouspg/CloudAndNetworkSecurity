Cloud and Network Security Lab 1: Network Security
====

Responsible person/main contact: Asad Hasan & Lauri Suutari

## Preliminary tasks & prerequisites

* Create a GitHub account if you don't already have one
* Create your answer repository from the provided link in **TODO**[Moodle space](https://moodle.oulu.fi/course/view.php?id=18470), **as instructed [here](../README.md#instructions)**
* Exercise is designed to be completed on a linux system
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
Task 4 | 4 | ICMP Tunneling Attack | Hping3, wireshark, tshark
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

**See network diagram below**

![image](https://github.com/ouspg/CloudAndNetworkSecurity/assets/113350302/58f7f99a-a9ac-4f80-9e67-653a677156fb)




Now that we know the basics of virtual network setup, let’s get into the lab task. Task 1 is about setting up the network by installing required pre-requisite softwares

---

## Task 1

### Setup Installation 

The network structure in this lab is built upon terraform. Terraform is a tool for deploying infrastructure as a code. Here, it is used to spawn the network infrastructure resources virtually using code configurations in terraform files (which is already done for you). A set of certain software dependencies are required to achieve this such as Libvirt, QEMU and KVM. Therefore, to make the network structure work, you'll have to follow the guidelines below. The instruction set has been tested on ubuntu/debian-linux as well as arch linux. Install guide for arch linux can be accessed [here](misc/arch_installation_guide.md)

**NOTE:** If you plan to setup network within a virtual machine, be mindful of the hard-disk space requirement because image sizes are big:

Kali linux (14.6 gb), Ubuntu server (14.6 gb) and pfSense (1 gb) 

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
**Download the relevant images & place them in the directory network_sec_platform/images**

The repository for terraform deploymnet can be cloned using provided link

```shell
git clone https://github.com/lsuutari19/network_sec_platform
```
There are there images that you need to download and place them into directory _network_sec_platform/images_ 

They have following names:

1) kali-linux-2023.4-qemu-amd64.qcow2
2) router_pfsense.qcow2
3) linux_server.qcow2


DOWNLOAD LINKS [Click here and append filename at the end of link to download that specific image file](https://a3s.fi/swift/v1/AUTH_d797295bcbc24cec98686c41a8e16ef5/CloudAndNetworkSecurity/)

{Go-to _network_sec_platform/variables.tf_ file}

![image](https://github.com/ouspg/CloudAndNetworkSecurity/assets/113350302/c0c11c63-2b2a-414f-bf86-8b55ab9cf34f)

{And make following changes to variable "ubuntu_img_url"}

{default ='ubuntu-desktop.iso' to default ='images/linux_server.qcow2'}

Here's how corrected variable looks

![image](https://github.com/ouspg/CloudAndNetworkSecurity/assets/113350302/202df1fb-facd-49ea-b5dd-df97f8785eca)



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
  <name>default_pool</name>
  <target>
    <path>$PWD/volumes</path>
  </target>
</pool>
EOF

sudo virsh pool-start default_pool
sudo virsh pool-autostart default_pool
```

**Configure user permisions for libvirt to storage pool**
```
sudo chown -R $(whoami):libvirt ./images
sudo systemctl restart libvirtd
```


**Using Terraform to deploy the network**
```
export TERRAFORM_LIBVIRT_TEST_DOMAIN_TYPE="qemu"

```

---
## Task 2

### Run the virtual network

If you've successfully installed all the required softwares, you're now set to deploy the network setup from Github and initialize it using terraform.
Following this, you'll use virtual manager to access the virtual resources spawned by terraform. 

### **A) Go into repository folder and initialize terraform and deploy the configuration**

Clone the master branch if you haven't already and place virtual images in network_sec_platform/images folder. Skip this step if you've done already.

```shell
git clone https://github.com/lsuutari19/network_sec_platform
```

Useful commands:
```
# To initialize terraform. It's always the first step in brand new repository
terraform init

# To validate terraform configuration and look for errors
terraform validate

# To apply terraform and spawn virtual resources
terraform apply

# To destroy resources spawned by terraform. Usually done when you have finished playing around with network
terraform destroy

# Highlights the plane of resources to spawn
terraform plan
```

Note: It can take few minutes to deploy the network structure, so be paitent

**Provide commands used**

**How many resources does terraform prompt in the Plan to create/add?**

**Provide screenshot**

**Apply completed successfully? Provide screenshot**
If no then go back diagnose and fix your errors. A small guide about [managing virtual resources spawned by terraform](misc/diagnostic_guide.md)

Normally if terraform deployment fails using 'terraform destroy' is not enough. Some of the virtual resources remain and have to be destroyed/killed manually. Moreover,
terraform state files need to be deleted manually in such cases. They are:T

1) terraform.tfstate
2) terraform.tfstate.backupT
3) terraform.lock.hcl # File used to initialize terraform



---

### **B) Access virtual manager and open virtual machine**s

```shell
# Command to access virtual manager
virt-manager
```

**How many virtual machines do you see? Where do you see the pfSense firewall deployed**

**Provide screenshot**

Login credentials for VMs in following format: username:password

Kali linux: kali:kali

Ubuntu server: ubuntu:linux

---

### **C) Configure LAN Network using pfSense CLI and access webGUI from kali linux**

PfSense boots with default configuration for LAN network. Your task is to configure it correctly and build a LAN network valid for the configuration provided below.
If done correctly, you should be able to access the pfSense WebGUI from machines on your virtual LAN network (such as kali and ubuntu server).

IMPORTANT: After configuring LAN network using pfSense CLI, you'll have to reboot your network adapter or kali and ubuntu linux for new network configurations to take effect.

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

Next, reboot kali linux for new network configurations to take affect or you can also restart your network adapter with:
```shell
sudo ip link set eth0 down #replace eth0 with your interface name
sudo ip link set eth0 up
```

**What is the IP address of your kali linux? Is it on correct LAN network? How can you test and confirm?**

**Access the webGUI from your kali linux. Provide screenshot**

Congratulations if you've successfully accessed the webGUI of pfSense. With this portal, you can configure firewall rules, utilize diagnostic tools, observed network traffic and much more.
Use following default credentials to login as root

_Username:_ admin

_Password:_ pfsense

**At this point, WAN interface should be disabled. Do not configure or enable it from webGUI** 

**Do a small ping test and observe captured traffic by pfSense using one of it's diagnostic packet capture tools available in webGUI. Ping test can be between any of router, kali or server. Add screenshot**


---



## Task 3

### Host discovery

### Discovering hosts inside the LAN network and access the server's webservice from LAN

From your network setup, you know that you're on the network 10.0.0.1/24. Use nmap scan to discover hosts on the network.


### **A) How many hosts are present in the internal LAN network? What are their IP addresses?**

**Provide commands**

**Screenshot**

The linux server is automatically running an HTTP nginx service. It can be accessed using http://<server_ip_addr> on any web browser.

---

### **B) Now try running the same command from outside the LAN network? Are you able to discover devices inside the internal LAN network? Explain your answer**

You can do this step from your host-machine which has internet access. Can it access or discover the LAN network somehow?

What about the webservice running at http://<server_ip_addr>. Can you access it?

---

### **C) Extracting more host info using NMAP**

Use the -PE, -PP, -PM flags of nmap to perform host discovery sending respectively ICMPv4 echo, timestamp, and subnet mask requests. 

**Provide command used to do this**

**What extra information did you gather using this? Paste screenshot**

### **D) Demonstrate access to web service using your kali linux

As stated earlier, server is present at http://<server_ip_addr> 

**Access the server from kali linux and attach screenshot**

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
text file with ICMP packets and observe the received packets through wireshark.

For converting the file into ICMP packets, you'll be using the hping3 (packet crafting tool). How does it work? See diagram below:

![image](https://github.com/ouspg/CloudAndNetworkSecurity/assets/113350302/bab100c8-da80-4954-9696-d82fbe94738b)

Here's what you need to do:
- Login to server and locate hackers_data.txt
- Craft hping3 command with correct flags and destination address (kali linux) to transfer file as ICMP packets
- Login to kali and open wireshark (or craft tcpdump commands to dump packets once received)
- Send ICMP packets through server and simultaneously monitor and capture the packets from kali linux using wireshark

_Hint: _Depending on your interface's Maximum Transmission Unit (MTU), each packet has a certain limit of data that it can hold without getting fragmented. For ethernet, you can find out this using 
ifconfig/ip addr command. Generally it has a value of 1500 for ethernet. However, the actual usable data is:

Maximum ICMP Data=MTU−Ethernet Frame Header−IP Header−ICMP Header

Maximum ICMP Data=1500 bytes−14 bytes−20 bytes−8 bytes

Maximum ICMP Data=1458 bytes

The Maximum Transmission Unit (MTU) is the maximum size of a single data unit that can be transmitted over a network.

You should stop the hping3 command when EOF (end of file) prompt is reached

![image](https://github.com/ouspg/CloudAndNetworkSecurity/assets/113350302/6ecbb36c-7364-4d34-9cc1-041f9a6c04ab)


**Provide commands used to send modified packets**

**Add screenshot**

**Inspect received packets from wireshark. Does the packets contain text from the file? Attach screenshots as a proof**


Make sure you are inspecting the correct packets in wireshark. And save your file as **hacker_data.pcap** for use in next task

**Inspect the Internet Control Message Protocol packet's Data field (which should be 1458 bytes) to locate the sub-filed in which attached data is stored.**

![image](https://github.com/ouspg/CloudAndNetworkSecurity/assets/113350302/d2910021-7adb-4468-9a6b-b6573436eb00)


_Extra Information: _TCPdump is a command-line packet analyzer tool for monitoring and analyzing network traffic on a Unix or Linux system. It captures packets flowing through a network interface and allows users to inspect them in real-time or save them to a file for later analysis. To use TCPdump, you typically specify the network interface to listen on (e.g., eth0), optionally apply filters to capture specific types of traffic, and specify any desired options or output formats. For example, to capture all traffic on interface eth0 and display it on the terminal, you can use the command sudo tcpdump -i eth0.

---

### **B) Pull out (data.data) field from the .pcap file using tshark**

Use **hacker_data.pcap** acquired in previous task to pull out (data.data) field from the .pcap file and dump it into a hexdump.txt file

Your task is to craft a command which uses tshark to read data packets from the file **hacker_data.pcap**. It should extract the attached data of each packet in hexadecimal format (data.data), and save it to the file **hexdump.txt**. 

Hint: The -n flag disables name resolution, -q suppresses unnecessary output, and -T fields specifies the output format.

tshark document for [help](https://www.wireshark.org/docs/man-pages/tshark.html)

**Provide command used**

**Screenshot of hexdump.txt file**

Next, copy the contents of the hexdump file and use an online hex to ASCII converter [tool](https://www.rapidtables.com/convert/number/hex-to-ascii.html) to restore contents of the original file.

**Were you able to re-construct the original hackers_data.txt file sent using ICMP packets? What are the contents of file? Briefly explain your answer and attach a screenshot**


---

## Task 5

### Accessing HTTP Server from outside LAN

This is a free-form task where you will play around with pfSense firewall webGUI or come up with an alternative solution to access the HTTP server (ubuntu) running on internal virtual LAN from your host computer. 

Here's what you need to understand first:
* Your host machine is on a WAN network (if it's connected to Wifi) OR a different LAN network (if ethernet network)
* You've so far configured an internal LAN network using pfSense which cannot be accessed from outside
* HTTP server inside internal LAN behind pfSense is not discoverable to your host machine

Here's what you need to do:
* Establish a communication channel between your host machine (WAN or other LAN) and HTTP server (internal LAN)
* Access the web-service running on HTTP server from your host machine

![image](https://github.com/ouspg/CloudAndNetworkSecurity/assets/113350302/525722a4-e00f-40ac-b522-4713a4d98820)

Red lines in the diagram above indicate the required objective to be achieved

There is no restriction to the choice of software or platform that students use for this task. However, utilizing pfSense webGUI is recommend as it has multiple useful options to complete this task such as:
* Port forwarding
* Firewall rules
* VPN (OpenVPN)

![image](https://github.com/ouspg/CloudAndNetworkSecurity/assets/113350302/fb64c03a-fb78-4eee-806b-55848225f214)


The main idea behind this task is to configure firewall to allow host to communicate with ubuntu server. **If you decide to do this task, you'll have to research on your own how it could be achieve and then try to implement it**


**Document your work properly for this task and include necessary screenshots and commands used**

**You should state clearly your PLAN, which pathways you took to achieve the objective**

**Make sure to document proper testing results to showcase success or failure**

**In case of partial implementation, write a brief report on issues and roadblocks encountered. You can still earn some points with failed attempts**


---

