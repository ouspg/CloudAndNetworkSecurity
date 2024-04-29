# CloudAndNetworkSecurity



Adding useful links for Task 1 & 2 related to DNS.

List of DNS record types: https://en.wikipedia.org/wiki/List_of_DNS_record_types
Iodine: https://gist.github.com/nukeador/7483958



Links for dnscat2 tutorial guides: 

https://github.com/iagox86/dnscat2

https://www.hackingarticles.in/dnscat2-application-layer-cc/

https://www.whitelist1.com/2017/10/dns-tunneling-with-dnscat2.html



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

```

