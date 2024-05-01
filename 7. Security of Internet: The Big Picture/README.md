Cloud and Network Security Lab 7: Security of Internet: The Big Picture
====

Responsible person/main contact: Asad Hasan & Lauri Suutari


## Preliminary tasks & prerequisites

This is the seventh and the final lab in the series with the theme of Security of Internet. 
You should return the tasks to GitHub.

Make yourself familiar with the following topics:

* DNS on [wikipedia](https://en.wikipedia.org/wiki/Domain_Name_System)
* List of [DNS record types](https://en.wikipedia.org/wiki/List_of_DNS_record_types)
* DNScat2 official reposiotry on [Github](https://github.com/iagox86/dnscat2)
* DNScat2 [comprehensive guide](https://www.hackingarticles.in/dnscat2-application-layer-cc/)
* DNS tunneling with DNScat2 [tutorial](https://www.whitelist1.com/2017/10/dns-tunneling-with-dnscat2.html)
* BGP in a nutshell [guide](https://blog.j2sw.com/networking/border-gateway-protocol-bgp-in-a-nutshell/)
* BGP simulator bgpy_pkg on [Github](https://github.com/jfuruness/bgpy_pkg)

### Important Notice

Lab structure from week 1 is used in task 1 and 2. If you face difficulties in setting up lab 1 network structure, refer to [lab 1 manual](https://github.com/ouspg/CloudAndNetworkSecurity/tree/main/1.%20Network%20Security). Alternatively,
you can perform task 2 using two virtual machines (one acting as a victim and other as server) in virtual box. However, instructions for this are not provided and you'll have to implement on your own. This is a good option if you do not have a decent machine running a Linux and it avoids nested virtualization and the issues related to it.


## Grading

<!-- <details><summary>Details</summary> -->

The order of the tasks is mandatory. For example, to gain points from Task 3, Task 1 and 2 should be completed.

Task #|Points|Description|Tools
-------|:---:|-----------|-----
Task 1 | 1 | Study traffic logs for DNS records and study pfsense's DNS resolver cache | wireshark or command-line, pfSense, Terraform
Task 2 | 1 | DNS tunneling | DNScat2, Terraform
Task 3 | 1 | Internet, Autonomous System(s) and BGPs: The Big Picture | No specific tools. Based on lecture 6
Task 4 | 2 | Performing Border Gateway Protocl (BGP) simulation | Free-form. However, bgpy_pkg (BGP simulator) is recommended


Total points accumulated by doing the exercises reflect the overall grade. You can acquire up to 5 points from the whole exercise.
<!-- </details> -->

---

## Task 1

### DNS records and DNS cache

DNS is a widely used term nowdays. In this task, you'll study network traffic logs for DNS records and answer some questions. In the second part of this task, you'll use lab 1's structure to study DNS resolver status via pfsense's webGUI

### A) Analyze traffic log files for DNS entries

Two traffic log files are provided in different format. Both files contain the same network traffic but one of them is a _.pcap_ and the other is _.txt_. The only difference between these two files is that _.pcap_ requires a software that supports _.pcap_ for analysis where _.txt_ file can be analyzed used command-line or any text editor. 

Log files can be download from [misc folder](https://github.com/ouspg/CloudAndNetworkSecurity/tree/main/7.%20Security%20of%20Internet%3A%20The%20Big%20Picture/misc)

First answer the following questions:

**How many different record types are in DNS. List common record types. Which record types can be considered malicious provided you are examining logs for malicious DNS traffic activity as a security analyst?**

Now, analyze the traffic_logs file and asnwer following questions:

**How many different record types can you find in it?**

**What is the IP address of host machine querying all these DNS requests?**

**Pick any single entry which includes multiple resource records (RRs) for DNS. Explain the entry in detail, what's happening. Add screenshot**

### B) Study DNS cache records using pfsense's webGUI

Pfsense's webGUI can be utilized to study the status of DNS resolver cache. In this task, you'll spawn network structure from lab 1 and perform tasks below.

First answer the following question:

**What is DNS cache. How does DNS store cache to speed look-up**

Now, spawn your lab 1 network structure using terraform and access pfsense webGUI from kali linux. DNS cache records can be studied from Status tab by selecting DNS Resolver

![image](https://github.com/ouspg/CloudAndNetworkSecurity/assets/113350302/5d1455ca-c946-4b8b-9900-4e7f90de8100)

At first, take a glance at initial state of DNS resolver's cache and make some notes. Then, start browsing different websites including youtube.com and answer following questions:

**In context of "DNS Resolver Infrastructure Cache Speed" what does an entry with Zone = youtube.com represent? Explain the record by taking real values as example**

**In context of "DNS Resolver Infrastructure Cache Stats" what does an entry with Zone = youtube.com represent? Explain the record by taking real values as example**

**Attach screenshot of DNS Resolver cache**

---

## Task 2

### DNS Tunneling

" DNS was originally made for name resolution and not for data transfer, so it’s often not seen as a malicious communications and data exfiltration threat. Because DNS is a well-established and trusted protocol, hackers know that organizations rarely analyze DNS packets for malicious activity. DNS has less attention and most organizations focus resources on analyzing web or email traffic where they believe attacks often take place. In reality, diligent endpoint monitoring is required to find and prevent DNS tunneling.

Furthermore, tunneling toolkits have become an industry and are wildly available on the Internet, so hackers don’t really need technical sophistication to implement DNS tunneling attacks. "

Source: Read more [here](https://www.cynet.com/attack-techniques-hands-on/how-hackers-use-dns-tunneling-to-own-your-network/)

For tunneling to work, a client-server model is used. Client is typically behind the organization’s security controls and the server is located somewhere on the Internet. Since this is a client-server model, any type of traffic can be sent over the tunnel. Dnscat2 is also a client-server application. Dnscat2 functions more like command and control software and also encrypts the transmitted data.

>[!Note]
> In this task students will perform DNS tunneling attack with DNScat2 using lab 1's network structure. Task can also be performed using two virtual machines on virtual box (but no instructions for this)

### A) Setup Dnscat2 and establish a tunnel

Spawn lab 1's network structure using terraform and setup DNScat2 inside terraform.

>[!Tip]
> Ubuntu acts as server and kali acts as client.
> You are not required to use any real domain name for this task

Installation steps are present in github's [official repo](https://github.com/iagox86/dnscat2). It is recommended to install the tool on server (ubuntu) first followed by client (kali).
```
# If you encounter conflicting port error on server, it can be fixed by changing default dns port. For example, port 53531 can be used instead of 53
sudo ruby ./dnscat2.rb --dns port=53531
```
**Demonstrate DNS tunnel establishment without using any domain name. Add screeshot and provide commands used to do this**

Refer to following guides for help with the tool itself:
* DNScat2 [comprehensive guide](https://www.hackingarticles.in/dnscat2-application-layer-cc/)
* DNS tunneling with DNScat2 [tutorial](https://www.whitelist1.com/2017/10/dns-tunneling-with-dnscat2.html)

### B) Establish a reverse shell session with kali linux. Carry out reconnaissance mission

In the previous task if you successfully managed to establish a dns tunnel despite having pfsense as a firewall in play, you can exploit this in numerous ways. Commands can be executed from server
(ubuntu) on kali linux. In this specific task, you are required to establish a reverse shell session with kali linux and control it from ubuntu server via DNS tunnel. 

Carry out a reconnaissance mission and gather as much information about victim (kali linux) as you can including files stored on the system. Quickly exit your session as well

**Provide step-by-step commands and screenshots with description explaining your steps**

For example, you could provide:
```
Commands to setup tunnel
Commands and screenshot to access shell of kali linux
Screenshots of using kali from spawned shell in ubuntu server
Screenshots of commands used to gather victim info
Screenshot and command to exit the shell session from ubuntu server
```

### C) After thoughts

Use wireshark to study the data that is being transferred over the DNS tunnel. 

**Which protocols are used to carry the data? How is data transmitted using this protocol in the context of DNS tunneling?**

**Add screenshots from wireshark analysis**


---


## Task 3

### Internet, Autonomous System(s), BGPs: The big picture

This task will focus on the contents of the previous lecture, particularly the one provided in [moodle](https://moodle.oulu.fi/pluginfile.php/2289617/mod_resource/content/1/Luento%207B%20internet.pdf).
You aren't expected to create any code in this task, instead this will focus on the theoretical side of things in an academic perspective concerning the internet, Autonomous System(s), BGPs and more with the focus on creating a visualization of the information you gather. 

You are allowed to use AI in this task, but you do need to back up the information you provide with relevant sources. Create a list of links to the sources you used to complete this task and **cite them properly** as if this was a small scientific article.

You are free to use any resources found online,
but the previously mentioned lecture slides provide a good starting point and links to good resources.

**Ensure that the answers you provide are under 200 words per section.**

### A) Structure of the internet in general (0.15p)
Briefly summarize how the network is divided - AS, service providers, national network isolation efforts and the dark web.

What are ASs and what are is their core function in the bigger picture. Explain whether an ISP's network is equivalent to an AS and describe the structures behind ISP and AS. Summarize what routing protocols are used to exchange routing information between ASs and how these protocols work.

Utilize a tool such as bgp.tools or similar to find out the ASs and upstreams about **your current IP address**, did you find any other information from the tool?

```
Return a quick summary of the questions asked
```

### B) Structure of the internet from Finland's perspective (0.20p)
Determine the number of ASs in Finland using bgp.tools or similar resources. What are the major ISPs and ASs in the region? Where are the major IXPs located and how do they facilitate traffic exchange? What is the overall structure of the internet infrastructure in Finland/Nordics? (Centralized, distributed, mesh-like)
Look for reliable sources of information on Finnish AS numbers, such as national telecom authorities, internet registries or academic research papers.

```
Return a quick summary of the questions asked
```

### C) Create a visualization of the information you have gathered in the previous part (0.50p)
Use the bgp.tools website and its API (and/or other tools) to gather data on Finnish AS numbers, routing tables, and internet structure. Ensure that the visualization addresses key questions posed in Teemu's lecture, providing insights into AS relationships, routing efficiency, and network structure.

```
Return a quick summary of the questions asked
and provide the visualization you created.
```

### D) Potential threats (0.15p)
Explain whether IP addresses alone are sufficient for making routing decisions and explore the role of routing algorithms/protocols in optimizing network performance and reliability. Explain potential threats if an attacker gains access to a DNS server and how DNS can be exploited for malicious activities.

```
Return a quick summary of the questions asked
```




## Task 4

### Performing Border Gateway Protocol (BGP) simulation

The Internet is an interconnection of autonomous systems (AS) which use Border Gateway Protocol (BGP) to exchange routing or reachability information. BGP relies on trust among network operators to secure their systems well and to send correct data since there is no built-in validation in this protocol.

The Border Gateway Protocol (BGP), utilized for exchanging routing information among autonomous systems (AS) within the Internet, lacks inherent mechanisms to ensure the integrity, authenticity, and authority of transmitted data. Specifically:

    1. BGP lacks internal safeguards to protect the integrity and authenticity of its messages.
    2. It lacks a specified mechanism to validate the authority of an AS to announce Network Layer Reachability Information (NLRI).
    3. BGP does not provide a means to verify the authenticity of attributes within update messages.

To address these vulnerabilities, Resource Public Key Infrastructure (RPKI) and Route Origin Validation (ROV) have been introduced as supplementary measures to enhance BGP security.

In this task students explore more about BGP and AS by implementing and performing a simulation.

Useful article on prefix hijacking: click [here](https://www.catchpoint.com/blog/bgp-vulnerabilities)

Before you proceed, this task has two options. First option is guided and based on [bgpy](https://github.com/jfuruness/bgpy_pkg) which is an extendable BGP simulator that can be used for security simulations for attack and defense. Second option is free-form where students get to select a BGP simulator/visualizer of their choice and implement it. 

## Option 1: BGP simulation with BGPY simulator

This simulator has been tested to work with kali linux. An Installation guide for kali linux can be found [here](https://github.com/ouspg/CloudAndNetworkSecurity/blob/week7/7.%20Security%20of%20Internet:%20The%20Big%20Picture/bgpy_pkg_install_guide.md) but it's optional and tool's official repository contains all necessary information.

After installing the tool, you can run simulations using pypy. This generates simulation graphs. Parameters for simulations can be changed and different custom_scenarios can be implemented as well. Your task is to study the bgpy_pkg [tutorial](https://github.com/jfuruness/bgpy_pkg/wiki/Tutorial) in full and perform custom simulations of your choosing while also answering the questions below.

In your return make sure to explain all necessary steps, commands and code adjustment with screenshots as proof

### Questions

**Simulator manual talks about Gao Rexford algorithm. What is it?**

**What are annoucements. How is the simulator propagating announcements in BGPy. Describe in your own words.**

**What is ROV. How can ROV graphs in a particular BGP simulation be interpreted? Use one of your simulation results as an example**

**Explain ATTACKER_SUCCESS, VICTIM_SUCCESS and DISCONNECTED from AS prefix's perspective**

**Carry-out at-least two custom simulation scenarios and mention important observations and graphs about them.**

![image](https://github.com/ouspg/CloudAndNetworkSecurity/assets/113350302/107e1e55-e626-4499-a1eb-9d61912fdb57)

![!Tip]
> Going through the complete github tutorial and repository itself will help answer the questions above

## Option 2: BGP Simulator or Visualizer of your own choice

If you go for this option, you are free to choose a BGP simulator or Visualizer of your own choice and carry out it's installation and perform some sort of simulation and/or visualization. 
Note, that you have to provide a detailed report about each step taken including the installation steps. You should also include information about certain key aspects utilized in that simulator or visualizer.

Some options but they are not tested:
* https://github.com/ssbgp/simulator
* https://github.com/massimocandela/BGPlay

Carry out your own research if you go with this option.

