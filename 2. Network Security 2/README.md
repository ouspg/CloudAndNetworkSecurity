Cloud and Network Security Lab 2: Network Security 2
====

Responsible person/main contact: Asad Hasan & Lauri Suutari

## Preliminary tasks & prerequisites

This lab is continuation of week 1 network security theme. 

A basic understanding of networking is required. GitHub is required to complete this exercise

Make yourself familiar with following:


* **Port Forwards** - [Port forwards with NAT on pfSense](https://docs.netgate.com/pfsense/en/latest/nat/port-forwards.html)
* **NAT** - NAT guide on zenarmor about pfsense [here](https://www.zenarmor.com/docs/network-security-tutorials/pfsense-network-address-translation-nat-guide)


Useful resources from previous lab:

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
Task 0 | - | Setting up new network | Terraform, virtual manager
Task 1 | 1 | Launch DDoS Attack on server and study traffic | Snort, wireshark, pfSense, DDoS-Attacker
Task 2 | 3 | Fix security misconfigurations | pfSense,
Task 3 | 4 | VPN setup and configuration for remote access | pfsense, OpenVPN, wireguard
Task 4 | 5 | Your own experiment | Open-ended


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

For enhanced security purposes, the network setup for second lab has been upgraded and web-server has been exposed outside to the WAN. Network admins have moved the HTTP server to a new sub-network behind the pfsense firewall. This new sub-network is called [DMZ](https://en.wikipedia.org/wiki/Demilitarized_zone) and it only hosts the HTTP server. Original LAN network remains the same with kali linux. Here are the features of new network as described by network admins:

```
WAN Network Specifications (vtnet0):
The network operates on sub-net mask 255.255.255.0 (/24) with network address: 198.168.122.0
Provides internet access to LAN Network through pfsense


LAN Network Specifications (vtnet1):
Internal LAN Network. Internet enabled via WAN
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
Web-server hosted at 10.3.1.10 and accessible via LAN. Also accessible via WAN interface through port-forwarding

IMPORTANT NOTE: WebGUI can be accessed from LAN network with following URL: https://10.0.0.1:444

```

The new virtual test network is based on three networks:
1. WAN
2. LAN
3. DMZ

The WAN is your standard computer network. The LAN is the internal network which contains probe machine (kali) protected by pfSense firewall which also
acts as the default router for this. DMZ is the network which contains HTTP server (Ubuntu) and web-service is accessible via WAN through [port-forwarding](https://www.wundertech.net/pfsense-port-forwarding-setup-guide). 

In this lab, students will dive into this virtual setup and play-around to find things out and perform security tasks.


**See the official network diagram as provided by network admins**

![image](https://github.com/ouspg/CloudAndNetworkSecurity/assets/113350302/c83ef5d6-3768-44cf-895c-fc3fe463d0f9)






---

## Task 0

### Setting up new network structure

Before, you can start doing the lab tasks for points, you need to spawn your virtual network infrastructure. For this, you require latest terraform configurations and pfsense image
containing new network. This is done for you already. All you have to do is clone the right terraform configurations and place the right VM images. Afterwards, you can initialize terraform as was in the first lab

For simplicity, follow the three steps guide below:

**1) Clone the new_network setup branch**

The repository for latest terraform deploymnet can be cloned using provided link
```
git clone -b new_network https://github.com/lsuutari19/master_thesis_stuff **~~TO BE UPDATED~~**
```

**2) Download and place relevant images into _master_thesis_stuff/terraform-testing/images_ folder**

There are there images that you need to download and place into directory _**masters_thesis_stuff/terraform-testing/images**_

If you completed lab 1, you can use same kali and ubuntu images and download only the latest pfsense image named _**pfsense_x.qcow2**_

The required images for this lab have following names:

    kali-linux-2023.4-qemu-amd64.qcow2
    pfsense_x.qcow2
    linux_server.qcow2

DOWNLOAD LINKS [Click here and append filename at the end of link to download that specific image file](https://a3s.fi/swift/v1/AUTH_d797295bcbc24cec98686c41a8e16ef5/CloudAndNetworkSecurity/)

**3) Spawn your network**

Go-to masters_thesis_stuff/terraform-testing and use following commands to spawn the network

```
terraform init
terraform validate
terraform apply
```
If done correctly, there should be 13 resources spawned.

```
#Access virtual resources by typing
virt-manager
```


## Task 1

### Launch DDoS Attack on server and study traffic

In today's interconnected digital landscape, Distributed Denial of Service (DDoS) attacks have emerged as a prevalent threat, capable of disrupting online services, causing financial losses, and tarnishing reputations. This section of the lab manual aims to provide insights to DDoS attacks, exploring their mechanisms, impacts, and mitigation. 

In this task, students will launch a DDoS attack on the server hosted in DMZ from outside (WAN). with the knowledge and skills necessary to defend against these disruptive assaults in real-world scenarios.

### **A) Access web-GUI and install snort**

Using terraform, spawn your virtual network, access virtual machines and open the web-GUI through LAN network (kali linux). Using package manager provided by pfsense, install snort

### B) Launch DDoS attack and monitor traffic

```
# Useful commands


Using pfSense web-GUI package manager, install [snort](https://www.snort.org/) 

At this point, you are encouraged to explore your network and VM's

https://github.com/CruelDev69/DDoS-Attacker

https://github.com/Whomrx666/Xdos-server

https://minhcung.me/simulate-a-denial-of-service-attack-bd8d4c834002




---
## Task 2

### Run the virtual network



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

