Cloud and Network Security Lab 3: Networking Protocols
====

Responsible person/main contact: Niklas Saari, Asad Hasan & Lauri Suutari

## Preliminary tasks & prerequisites

This is the third lab in the series with the theme of Networking Protocols. 

A basic understanding of networking protocols is required. GitHub is required to complete this exercise

Make yourself familiar with following:


* **Port Forwards** - [Port forwards with NAT on pfSense](https://docs.netgate.com/pfsense/en/latest/nat/port-forwards.html)
* **NAT** - NAT guide on zenarmor about pfsense [here](https://www.zenarmor.com/docs/network-security-tutorials/pfsense-network-address-translation-nat-guide)
* **Sharing files between KVM and host machine** - [Guide to creating a mounting point for file share](https://www.debugpoint.com/share-folder-virt-manager/)


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
Task 1 | 1 | HTTP Smuggling | TBD
Task 2 | 2 | Fuzz testing the TCP/IP stack | TDB
Task 3 | 3 | TBD| ...
Task 4 | 5 | ASN for advanced tasks. FuzzTest rasn | TBD



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

**1) Fetch the new_network setup branch**

Fetch the lab2 branch and checkout to it.
```
git fetch origin lab2
git checkout lab2
```

**2) Download and place relevant images into _network_sec_platform/images_ folder**

There are images that you need to download and place into the following directory _**network_sec_platform/images**_

If you completed lab 1, you can use the same kali and ubuntu images and download only the latest pfsense image named _**pfsense_x.qcow2**_

Image name|Image size|Download Link
:-:|:-:|:-:
Kali linux | 14.6 gb | [kali download](https://a3s.fi/swift/v1/AUTH_d797295bcbc24cec98686c41a8e16ef5/CloudAndNetworkSecurity/kali-linux-2023.4-qemu-amd64.zip)
Ubuntu server | 1.8 gb | [server download](https://a3s.fi/swift/v1/AUTH_d797295bcbc24cec98686c41a8e16ef5/CloudAndNetworkSecurity/ubuntu_server.qcow2)
pfSense (lab 2) | 1 gb | [pfsense download](https://a3s.fi/swift/v1/AUTH_d797295bcbc24cec98686c41a8e16ef5/CloudAndNetworkSecurity/pfsense_x.qcow2)

**3) Spawn your network**

Go-to network_sec_platform directory and use following commands to spawn the network

```
terraform init
terraform validate
terraform apply
```
If done correctly, there should be 12 resources spawned.

```
#Access virtual resources by typing
virt-manager
```
See machine's login info below 

Machine|username|password
-----|:---:|-----------
Kali| kali| kali
Ubuntu | ubuntu | linux
pfsense web-GUI | admin | pfsense

---
