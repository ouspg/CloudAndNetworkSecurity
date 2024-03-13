Cloud and Network Security Lab 3: Networking Protocols
====

Responsible person/main contact: Niklas Saari, Asad Hasan & Lauri Suutari

## Preliminary tasks & prerequisites

This is the third lab in the series with the theme of Networking Protocols. 

A basic understanding of networking protocols is required. GitHub is required to complete this exercise

Make yourself familiar with following topics:


* **List of networking protocols** - Read about list of networking protocols for OSI model on [Wikipedia](https://en.wikipedia.org/wiki/List_of_network_protocols_(OSI_model))
* **20 common networking protocols** - Article presenting 20 common networking protocols [here](https://medium.com/@rajeshmamuddu/20-different-network-protocols-commonly-used-in-networking-e98cab90d18d)
* **OSI Model** - What is OSI Model on [Wikipedia](https://en.wikipedia.org/wiki/OSI_model)


## Grading

<!-- <details><summary>Details</summary> -->

Task #|Points|Description|Tools
-----|:---:|-----------|-----
Task 1 | 1 | HTTP request smuggling | TBD
Task 2 | 3 | Write code to extract the payload from captured packet | TDB
Task 3 | 4 | Fuzz testing the TLS/TCP/IP stack| ...
Task 4 | 5 | Certificate validation | TBD



Total points accumulated by doing the exercises reflect the overall grade. You can acquire up to 5 points per whole exercise.
<!-- </details> -->

---


## About the lab

* This document contains task descriptions and theory for the third cloud and network security lab. If there are any differences between the return template and this file, consider this to be the up-to-date document.
* **You are encouraged to use your own computer or virtual machine if you want.** TODO ----------------------- TODO
* __Upper scores for this assignment require that all previous tasks in this assignment have been done as well__, so e.g. in order to get the third point you will have to complete tasks 1, 2 & 3.
* Check the deadline from Moodle and __remember that you have to return your name (and possibly people you worked together with) and GitHub repository information to Moodle before the deadline.__


## Background

This week’s theme is networking protocols.

Tasks are designed to be done using course's provided virtual machine.

Networking protocols are a set of rules and conventions that govern the communication between devices in a computer network. These protocols define how data is formatted, transmitted, received, and interpreted across the network. They facilitate the exchange of information between devices, ensuring compatibility and interoperability.

Key aspects of networking protocols include:

    Addressing: Protocols define how devices are identified and addressed on the network. This includes assigning unique addresses, such as IP addresses, to devices to enable communication.

    Routing: Protocols determine how data packets are routed from a source to a destination across the network. This involves selecting the best path for data transmission and managing network congestion.

    Error Handling: Protocols include mechanisms for detecting and correcting errors that may occur during data transmission. This ensures reliable communication between devices.

    Security: Many protocols incorporate security features to protect data from unauthorized access, interception, or tampering. This includes encryption, authentication, and access control mechanisms.




---

## Task 1

### HTTP request smuggling

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
