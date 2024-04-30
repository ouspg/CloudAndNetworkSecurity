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




# Task 4

The Internet is an interconnection of autonomous systems (AS) which use Border Gateway Protocol (BGP) to exchange routing or reachability information. BGP relies on trust among network operators to secure their systems well and to send correct data since there is no built-in validation in this protocol.

Based on RFC, BGP has three fundamental vulnerabilities:
Vulnerabilities of BGP

1 No internal mechanism to protect the integrity and source authenticity of BGP
messages
2 No mechanism specified to validate the authority of an AS to announce NLRI
3 No mechanism to verify the authenticity of the attributes of a BGP update message

## BGP Installation

Steps for kali linux

pypy installation.

Download from link:

sudo mv pypy-<version>-<architecture> /opt/pypy

sudo ln -s /opt/pypy/bin/pypy3 /usr/local/bin/pypy

Now pypy refers to pypy3 because of this symbolic representation!

/usr/local/bin/pypy -m ensurepip

/usr/local/bin/pypy -m pip install pip --upgrade

So far, we setup pypy in kali linux. Next steps are to install dependencies and the simulator itself

```
sudo apt-get install -y graphviz libjpeg-dev zlib1g-dev
pypy -m pip install pip --upgrade
pypy -m pip install wheel --upgrade

# Commands below take some minutes, so be patient!
pypy -m pip install numpy --config-settings=setup-args="-Dallow-noblas=true"
pypy -m pip install bgpy_pkg

git clone https://github.com/jfuruness/bgpy_pkg
cd bgpy_pkg/
pypy3 -m pip install .

```

Add /opt/pypy/bin to the PATH:
You can add the directory containing the bgpy script to your PATH environment variable. This allows you to execute the bgpy command from any directory without specifying its full path.

You can add /opt/pypy/bin to your PATH by running the following command:
```
export PATH=$PATH:/opt/pypy/bin
```

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
