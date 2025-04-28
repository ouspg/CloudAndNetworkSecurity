# Installation instructions

This installation instruction is designed for arch linux operating system.

VM Passwords

## Install and setup libvirtd and necessary packages for UEFI virtualization
```
# Update package databases
sudo pacman -Syu

# Install necessary packages
sudo pacman -S qemu-full libvirt ebtables dnsmasq bridge-utils openbsd-netcat


# Add the current user to the libvirt group
sudo gpasswd -a $(whoami) libvirt

# Restart the system to apply group changes
sudo reboot
```

Start and enable libvirtd
```
sudo systemctl start libvirtd
sudo systemctl enable libvirtd
```

## Install terraform
Follow specific instructions for your system

https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

### verify terraform is accessible and the CLI works
```
#For arch linux
sudo pacman -S terraform

which terraform
terraform --version
```


### install virt-manager for VM accessibility
```
# Install virt-manager and virt-viewer
sudo pacman -S virt-manager virt-viewer
```

### install qemu and verify the installation
https://www.qemu.org/download/#linux
```
#For arch linux
sudo pacman -S qemu
qemu-system-x86_64 --version
```
### Download the relevant images & place them in the directory network_sec_platform/images_

The repository for terraform deployment can be cloned using provided link

```shell
git clone https://github.com/lsuutari19/network_sec_platform.git
```
There are four images that you need to download and place them into directory network_sec_platform/images_ 

They have following names:
Image name|Image size|Download Link
:-:|:-:|:-:
Kali linux | 14.6 gb | [kali download](https://a3s.fi/swift/v1/AUTH_d797295bcbc24cec98686c41a8e16ef5/CloudAndNetworkSecurity/kali-linux-2023.4-qemu-amd64.zip)
Ubuntu server | 1.8 gb | [server download](https://a3s.fi/swift/v1/AUTH_d797295bcbc24cec98686c41a8e16ef5/CloudAndNetworkSecurity/ubuntu_server.qcow2)
pfSense | 1 gb | [pfsense download](https://a3s.fi/swift/v1/AUTH_d797295bcbc24cec98686c41a8e16ef5/CloudAndNetworkSecurity/router_pfsense.qcow2)

### Install mkisofs
```
# Install mkisofs
sudo pacman -S cdrtools
```

### Install xsltproc 
```
# Install xsltproc
sudo pacman -S libxslt
```

### Initialize default storage pool if it hasn't been created by libvirt
Defining this pool to point to ./volumes makes it easier for us to control the resources, also it avoids having to deal with any permission issues. Also keeping all of the resources under "master" directory lets us easily delete all the resources once we are done with the laboratories.

```
sudo virsh pool-define /dev/stdin <<EOF
<pool type='dir'>
  <name>default_pool</name>
  <target>
    <path>$PWD/volumes</path>
  </target>
</pool>
EOF

sudo virsh pool-start default_pool
sudo virsh pool-autostart default_pool
```

### Configure user permisions for libvirt + qemu to storage pool

```
sudo chown -R $(whoami):libvirt $PWD/volumes
```
Edit /etc/libvirt/qemu.conf file & uncomment user, group and security_driver, and make the following changes:
```
# Some examples of valid values are:
#
#       user = "qemu"   # A user named "qemu"
#       user = "+0"     # Super user (uid=0)
#       user = "100"    # A user named "100" or a user with uid=100
#
user = "<username>"
# The group for QEMU processes run by the system instance. It can be
# specified in a similar way to user.
group = "libvirt"
...
security_driver = "none"
```
```
sudo systemctl restart libvirtd
```


### Provision the platform with Terraform
```
export TERRAFORM_LIBVIRT_TEST_DOMAIN_TYPE="qemu"
terraform init
terraform apply

Note: the ubuntu-domain takes a minute to start due to the nature of the cloud images and their preconfigurations.
```


**Notes:**
- The ubuntu-domain takes a minute to start due to the nature of the cloud images and their preconfigurations.
- On a lot of OS's SELinux/apparmor messes up with the permissions for libvirt, uncomment and change /etc/libvirt/qemu.conf user and group: https://ostechnix.com/solved-cannot-access-storage-file-permission-denied-error-in-kvm-libvirt/
- To make sure networks autostart after a shutdown of hostmachine you can run
```
  virsh net-autostart internal_network && virsh net-autostart external_network && virsh net-autostart demilitarized_zone
```

- Running into errors? Read the troubleshoot section [here](https://github.com/lsuutari19/network_sec_platform?tab=readme-ov-file#troubleshooting)

- Virsh [commands](https://download.libvirt.org/virshcmdref/html-single/) are useful for troubleshooting as well, particularly the net-, pool- & volume (list, destroy, undefine)

