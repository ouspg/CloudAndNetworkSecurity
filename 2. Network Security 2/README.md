Cloud and Network Security Lab 2: Network Security 2
====

Responsible person/main contact: Asad Hasan & Lauri Suutari

## Preliminary tasks & prerequisites

This lab is continuation of week 1 network security theme. 

A basic understanding of networking is required. GitHub is required to complete this exercise

Make yourself familiar with following tools.


* **nmap** - Host discovery with [nmap](https://nmap.org/book/man-host-discovery.html) nmap on [Wikipedia](https://en.wikipedia.org/wiki/Nmap)
* **terraform** - Basic tutorial about what is terraform [here](https://k21academy.com/terraform-iac/terraform-beginners-guide/)
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
Task 1 | 1 | Launch DDoS Attack on server and study traffic | Terraform, libvirt, Qemu, KVM
Task 2 | 2 | Fix security misconfigurations | pfSense, terraform, virtual manager
Task 3 | 3 | TBD | TBD
Task 4 | 4 | TBD | wireshark, tshark
Task 5 | 5 | TBD | Open-ended


Total points accumulated by doing the exercises reflect the overall grade. You can acquire up to 5 points per whole exercise.
<!-- </details> -->

---


## About the lab

* This document contains task descriptions and theory for the second network security lab. If there are any differences between the return template and this file, consider this to be the up-to-date document.
* **You are encouraged to use your own computer or virtual machine if you want.** This lab uses software and dependencies installed in previous lab. Check the Task 1 "**Setup Installation**" for information on what you need to install from [Lab 1's manual](https://github.com/ouspg/CloudAndNetworkSecurity/tree/main/1.%20Network%20Security) if you haven't . This lab has been made to be completed in a Linux environment and tested to work in debian, ubuntu and the provided Arch Linux virtual machine.
* __Upper scores for this assignment require that all previous tasks in this assignment have been done as well__, so e.g. in order to get the third point you will have to complete tasks 1, 2 & 3.
* Check the deadline from Moodle and __remember that you have to return your name (and possibly people you worked together with) and GitHub repository information to Moodle before the deadline.__


## Background

This week’s theme is continuation of network security.
Tasks are designed to be done with the provided network setup using [terraform](https://en.wikipedia.org/wiki/Terraform_(software)), see the [terraform commands tutorial](https://tecadmin.net/terraform-basic-commands/) for instructions on how to run the network using terraform. The firewall (+router) used in this network is [pfSense](https://docs.netgate.com/pfsense/en/latest/general/index.html).
The provided VM's within terraform has all the required tools preinstalled.  Contact course assistants if you require any extra tools, they'll install them in a custom image for you and provide instructions how to use it within the setup. 



## NEW NETWORK SETUP FOR THE SECOND LAB

For enhanced security purposes, the network setup for second lab has been upgraded and web-server has been exposed to the internet. Network admins have moved the HTTP server to a new sub-network behind the pfsense firewall. This new sub-network is called (DMZ)[https://en.wikipedia.org/wiki/Demilitarized_zone] and it only hosts the HTTP server. Original LAN network remains the same with kali linux. Here are the features of new network as described by network admins:

```
WAN Network Specifications (vtnet0):
The network operates on sub-net mask 255.255.255.0 (/24) with network address: 198.168.122.0
Provides internet access to LAN Network through pfsense

LAN Network Specifications (vtnet1):

Internal LAN Network
The network operates on sub-net mask 255.255.255.0 (/24) with network address: 10.0.0.0

The IP address range for network is as follows:
Start address: 10.0.0.11 (/24)
End address: 10.0.0.100 (/24)

DHCP Server enabled: Yes
IPv6: No
Protocol for webGUI: HTTPS

DMZ (vtnet2):
The network operates on sub-net mask 255.255.255.0 (/24) with network address: 10.3.1.0
Restricted and isolated network.
Web-server hosted at 10.3.1.10 and accessible with internet through WAN interface 

```

The new virtual test network is based on three networks:
1. WAN
2. LAN
3. DMZ

The WAN is your standard computer network. The LAN is the internal network which contains probe machine (kali) protected by pfSense firewall which also
acts as the default router for this. DMZ is the network which contains HTTP server (Ubuntu) and web-service is accessible via internet through port-forwarding. B

In this lab, students will dive into this virtual setup and play-around to find things out such as discover weaknesses, enhance network security and e.t.c.


**See the official network diagram as provided by network admins**

![image](https://github.com/ouspg/CloudAndNetworkSecurity/assets/113350302/a55c5723-482f-4ea4-ad38-58e119389165)





---

## Task 1

### DDoS Attack

https://github.com/CruelDev69/DDoS-Attacker

https://github.com/Whomrx666/Xdos-server

https://minhcung.me/simulate-a-denial-of-service-attack-bd8d4c834002




---
## Task 2

### Run the virtual network

If you've successfully installed all the required softwares, you're now set to deploy the network setup from Github and initialize it using terraform.
Following this, you'll use virtual manager to access the virtual resources spawned by terraform. 

### **A) Go into terraform-testing folder and initialize terraform and deploy the configuration**

Clone the master branch if you haven't already and place virtual images in master_thesis_stuff/terraform-testing/images folder. Skip this step if you've done already.

```shell
git clone https://github.com/lsuutari19/master_thesis_stuff
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
terraform state files need to be deleted manually in such cases. They are:

1) terraform.tfstate
2) terraform.tfstate.backup
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

Ubuntu server: Ubuntu:ubuntu

---

### **C) Configure LAN Network using pfSense CLI and access webGUI from kali linux**

PfSense boots with default configuration for LAN network. Your task is to configure it correctly and build a LAN network valid for the configuration provided below.
If done correctly, you should be able to access the pfSense WebGUI from machines on your virtual LAN network (such as kali and ubuntu server).

IMPORTANT: After configuring LAN network using pfSense CLI, you'll have to reboot your network adapter or kali and ubuntu linux for new network configurations to take effect.


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

### VPN setup and configuration for remote access

Virtual Private Networks (VPNs) have become a core feature of establishing secure connections between devices/networks. Most IT companies of today use these kinds of approaches for remote connections to their internal networks. 


### **A) Research and describe three different VPN types and their differences.**

The most widely used VPN types include personal VPN services, remote access VPNs and site-to-site VPNs. Briefly describe these different VPN types and their differences.


---


### **B) Setup and Configure OpenVPN to allow remote access to the internal network**

Your task as a cyber security professional is to set up a OpenVPN server to authenticate access to your organization's internal network(s) for users connecting from external networks. The internal company network in this situation consists of the DMZ- and the LAN networks. 

The organization that you are setting up the VPN for is named after the first letters of your first name and surname i.e. if your name was Pekka Pouta, it would be PePo, the organization is based in Oulu, Finland, Pohjois-Pohjanmaa. Take this information into account when creating the certificates for OpenVPN.

If you configure and setup the OpenVPN client and server correctly, you should be able to login via the OpenVPN client and be able to access the machines hosted in the company network. 

Create and document your process of setting up and configuring a OpenVPN VPN solution to access the machines in the internal- and DMZ networks. Provide images of at least your OpenVPN Remote Access server creation certificates (with organizational information), OpenVPN servers-, clients tab & a successful connection from remote network (host macihne) to the internal networks (a ping to the Kali machine and a curl to the web server in the DMZ suffice).


---


### **C) What type of tunnel did you create for the VPN connection? What are the differences between split-tunnel & full-tunnel VPN connections?**

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

## Task 4 C) OPTIONAL???? NOT INCLUDED YET!!! IF THE WORKLOAD OF OVERALL LAB IS LOW, IT CAN BE INCLUDED

### Establish a reverse shell connecton between server and your kali linux

Tools used in this task: * **icmpdoor** - Github repository [here](https://github.com/krabelize/icmpdoor) ????

In the previous task you discovered how ICMP packets can be used to transfer data despite having a firewall in place. In this task, you'll take this concept one step further and establish a reverse shell session
between the server (ubuntu) and kali machine. Using reverse shell, you'll extract the server info.

This is a free form task where you can use tool of your choice

https://github.com/krabelize/icmpdoor?tab=readme-ov-file


---

## Task 5

### Accessing HTTP Server from outside LAN

https://www.contradodigital.com/2021/02/19/how-to-host-a-single-website-behind-a-pfsense-firewall/


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

