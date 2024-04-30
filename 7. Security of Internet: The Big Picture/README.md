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
You aren't expected to create any code in this task, instead this will focus on the theoretical side of things in an academic perspective concerning Autonomous System(s) with the focus on creating a visualization of the information you gather. You are allowed to use AI in this task, but you do need to back up the information you provide with relevant sources. Create a list of links to the sources you used to complete this task and **cite them properly** as if this was a small scientific article.

You are free to use any resources found online,
but the previously mentioned lecture slides provide a good starting point and links to good resources.

Ensure that the answers you provide are under 200 words per section.

### A) Autonomous Systems in general (0.15p)
Briefly summarize what ASs are and their core features. Explain whether an ISP's network is equivalent to an AS and describe the structures behind ISP and AS and what routing protocols are used to exchange routing information between ASs.
Utilize a tool such as bgp.tools or similar to find out the ASs and upstreams about **your current IP address**, did you find any other information from the tool?

```
Return a quick summary of the questions asked
```

### B) Autonomous Systems from Finland's perspective (0.20p)
Determine the number of ASs in Finland using bgp.tools or similar resources. What are the major ISPs and ASs in the region? Where are the major IXPs located and how do they facilitate traffic exchange? What is the overall structure of the internet infrastructure in Finland/Nordics? (Centralized, distributed, mesh-like)
Look for reliable sources of information on Finnish AS numbers, such as national telecom authorities, internet registries or academic research papers.

```
Return a quick summary of the questions asked and cite your sources
```

### C) Create a visualization of the information you have gathered in the previous part (0.50p)
Use the bgp.tools website and its API (and/or other tools) to gather data on Finnish AS numbers, routing tables, and internet structure. Ensure that the visualization addresses key questions posed in Teemu's lecture, providing insights into AS relationships, routing efficiency, and network structure.

```
Return a quick summary of the questions asked and cite your sources,
and provide the visualization you created.
```

### D) Potential threats (0.15p)
Explain whether IP addresses alone are sufficient for making routing decisions and explore the role of routing algorithms/protocols in optimizing network performance and reliability. Explain potential threats if an attacker gains access to a DNS server and how DNS can be exploited for malicious activities.

```
Return a quick summary of the questions asked
```




# Task 4

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
