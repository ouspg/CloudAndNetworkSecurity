# CloudAndNetworkSecurity



Adding useful links for Task 1 & 2 related to DNS.

List of DNS record types: https://en.wikipedia.org/wiki/List_of_DNS_record_types
Iodine: https://gist.github.com/nukeador/7483958



Links for dnscat2 tutorial guides: 

https://github.com/iagox86/dnscat2

https://www.hackingarticles.in/dnscat2-application-layer-cc/

https://www.whitelist1.com/2017/10/dns-tunneling-with-dnscat2.html

## Task 3 (W.I.P):
This task will focus on the contents of the previous lecture, particularly the one provided in [moodle](https://moodle.oulu.fi/pluginfile.php/2289617/mod_resource/content/1/Luento%207B%20internet.pdf).
You aren't expected to create any code in this task, instead this will focus on the theoretical side of things in an academic perspective concerning the internet, Autonomous System(s), BGPs and more with the focus on creating a visualization of the information you gather. 

You are allowed to use AI in this task, but you do need to back up the information you provide with relevant sources. Create a list of links to the sources you used to complete this task and **cite them properly** as if this was a small scientific article.

You are free to use any resources found online,
but the previously mentioned lecture slides provide a good starting point and links to good resources.

Ensure that the answers you provide are under 200 words per section.

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




## Task 4 (W.I.P)

# Performing Border Gateway Protocol (BGP) simulation

The Internet is an interconnection of autonomous systems (AS) which use Border Gateway Protocol (BGP) to exchange routing or reachability information. BGP relies on trust among network operators to secure their systems well and to send correct data since there is no built-in validation in this protocol.

The Border Gateway Protocol (BGP), utilized for exchanging routing information among autonomous systems (AS) within the Internet, lacks inherent mechanisms to ensure the integrity, authenticity, and authority of transmitted data. Specifically:

    1. BGP lacks internal safeguards to protect the integrity and authenticity of its messages.
    2. It lacks a specified mechanism to validate the authority of an AS to announce Network Layer Reachability Information (NLRI).
    3. BGP does not provide a means to verify the authenticity of attributes within update messages.

To address these vulnerabilities, Resource Public Key Infrastructure (RPKI) and Route Origin Validation (ROV) have been introduced as supplementary measures to enhance BGP security.

In this task students explore more about BGP and AS by implementing and performing a simulation.

Useful article on prefix hijacking: click [here](https://www.catchpoint.com/blog/bgp-vulnerabilities)

Before you proceed, this task has two options. First option is guided and based on [bgpy](https://github.com/jfuruness/bgpy_pkg) which is an extendable BGP simulator that can be used for security simulations for attack and defense. Second option is free-form where students get to select a BGP simulator/visualizer of their choice and implement it. 

## Option 1: Guided BGP simulation with BGPY simulator

This simulator has been tested to work with kali linux. Follow the install instructions below and proceed to lab tasks

## BGPY Installation

1) Install pypy on kali linux from [official website](https://www.pypy.org/download.html)

2) Extract the package and rename the folder from pypy3.10-v7.x.xx-linux64 to pypy. Move to folder /opt/pypy
```
mv pypy-<version>-<architecture> /opt/pypy
```
3) Ensure symbolic reference to work by executing
```
sudo ln -s /opt/pypy/bin/pypy3 /usr/local/bin/pypy
```

Now pypy refers to pypy3 because of this symbolic representation!

4) Next execute
```
/usr/local/bin/pypy -m ensurepip
/usr/local/bin/pypy -m pip install pip --upgrade
```

So far, we have setup pypy in kali linux. Next steps are to install dependencies and the simulator itself

5) Install dependencies and bgpy_pkg
```
sudo apt-get install -y graphviz libjpeg-dev zlib1g-dev
pypy -m pip install pip --upgrade
pypy -m pip install wheel --upgrade

# Command below take some minutes, so be patient!
pypy -m pip install numpy --config-settings=setup-args="-Dallow-noblas=true"
pypy -m pip install bgpy_pkg
```
6) Clone BGP simulator repo
```
git clone https://github.com/jfuruness/bgpy_pkg
cd bgpy_pkg/
```
7) Add /opt/pypy/bin to the PATH (optional):
You can add the directory containing the bgpy script to your PATH environment variable. This allows you to execute the bgpy command from any directory without specifying its full path.

You can add /opt/pypy/bin to your PATH by running the following command:
```
export PATH=$PATH:/opt/pypy/bin
```
---

After following the installation steps above you can run the default simulation by running the main python file in bgpy_pkg/. This generates simulation graphs for as well. Parameters can be changed in main file to implement different use cases and scenarios. Your next task is to study the bgpy_pkg [tutorial](https://github.com/jfuruness/bgpy_pkg/wiki/Tutorial) in full and perform a custom simulation of your choosing while also answering the questions below.

### Questions

Gao Rexford algorithm. Tell about it

What are annoucements. How is the simulator propagating announcements in BGPy. Describe in your own words.

#### Info

From a high level, when we traceback from an AS, we start at a specific AS. For the most specific prefix at that AS, we then look at the next hop along the AS path. We then look up that AS in ASGraph, and recursively repeat this process.

We do this from each AS. When we traceback, there are three final possible outcomes, defined in the enum Outcomes

    ATTACKER_SUCCESS: The traffic on the data plane reached the attacker
    VICTIM_SUCCESS: The traffic on the data plane reaches the victim aka the legitimate origin of the announcement
    DISCONNECTED: The traffic does not reach either the attacker or the victim

#### Running the simulation

In current simulation, following scenarios are used: ROV, peerROV and subprefixhijack

Question: Tell more about ROV, peerROV and subprefixhijack. Would you like to implement a scenario different that subprefixhijack? 


### About the dataset

The 'serial-1' directory contains AS relationships inferred from BGP
data using a method similar to the method described in "AS
Relationships, Customer Cones, and Validation" published in IMC 2013
(http://www.caida.org/publications/papers/2013/asrank/).  The serial-1
directory also contains provider-peer customer cones inferred for each
AS, as well as the raw BGP routes that we extracted paths from for
inferring relationships.  The README file in the serial-1 directory
further describes this data set.

The 'serial-2' directory combines the 'serial-1' data with relationships
inferred from Ark traceroute data, and multi-lateral peering
(http://www.caida.org/publications/papers/2013/inferring_multilateral_peering/).
The README file in the serial-2 directory further describes this data
set.

We disabled public access to 2020-02 and 2020-03 data since some of
the links were not calculated correctly, therefore producing errors in
customer cone and ranks.

------------------------
Acceptable Use Agreement
------------------------

Access to these data is subject to the terms of the following CAIDA Acceptable Use Agreement (AUA) for Publicy Accessible Datasets.
https://www.caida.org/about/legal/aua/public_aua/

When referencing this data (as required by the AUA), please use:

    The CAIDA AS Relationships Dataset, <date range used>
    https://www.caida.org/catalog/datasets/as-relationships/
You are required to notify CAIDA when you make a publication using these data. Please report your publication by completing the form at
https://www.caida.org/catalog/datasets/publications/report-publication/  or by emailing us at data-info@caida.org
