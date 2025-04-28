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
