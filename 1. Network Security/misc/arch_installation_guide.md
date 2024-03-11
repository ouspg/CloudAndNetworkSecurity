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

1) kali-linux-2023.4-qemu-amd64.qcow2
2) router_pfsense.qcow2
3) linux_server.qcow2
4) pfsense_x.qcow2 (this is for lab2)


DOWNLOAD LINKS [Click here and append filename at the end of link to download that specific image file](https://a3s.fi/swift/v1/AUTH_d797295bcbc24cec98686c41a8e16ef5/CloudAndNetworkSecurity/)

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

### Configure user permisions for libvirt to storage pool
```
sudo chown -R $(whoami):libvirt $PWD/volumes
sudo systemctl restart libvirtd
```


### Provision the platform with Terraform
```
export TERRAFORM_LIBVIRT_TEST_DOMAIN_TYPE="qemu"
terraform init
terraform apply

Note: the ubuntu-domain takes a minute to start due to the nature of the cloud images and their preconfigurations.
```


# Troubleshooting:
```
General problems with first deployment:
solution:
run the cleanup.sh script

NOTE: After first successful deployment, do not use the cleanup.sh anymore, instead use terraform destroy!!

```


```
problem:
Error: Error defining libvirt domain: virError(Code=67, Domain=10, Message='unsupported configuration: Emulator '/usr/bin/qemu-system-x86_64' does not support virt type 'kvm'')

solution 1:
try export TERRAFORM_LIBVIRT_TEST_DOMAIN_TYPE="qemu"

solution2:
enable virtualization in the host system
```

```
problem:
pool default_pool not found

solution:
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

```
problem:
Error: error creating libvirt domain: Cannot access storage file '/network_sec_platform/volumes/kali-qcow2' (as uid:962, gid:962): Permission denied

solution 1: 
uncomment and change /etc/libvirt/qemu.conf user and group: https://ostechnix.com/solved-cannot-access-storage-file-permission-denied-error-in-kvm-libvirt/ https://github.com/dmacvicar/terraform-provider-libvirt/issues/546

solution 2:
change the security driver in /etc/libvirt/qemu.conf to "none": https://github.com/dmacvicar/terraform-provider-libvirt/issues/546

solution 3:
make sure that your user belongs to the libvirt group and the libvirt group has permissions to this directory, also make sure that "sudo virsh pool-dumpxml default_pool" gives the something like the following:

<pool type='dir'>
  <name>default_pool</name>
  <uuid>3aeb4e71-811c-40f6-bc78-0dbf8f7f2b8c</uuid>
  <capacity unit='bytes'>1005388820480</capacity>
  <allocation unit='bytes'>623110905856</allocation>
  <available unit='bytes'>382277914624</available>
  <source>
  </source>
  <target>
    <path>home/user/network_sec_platform/volumes</path>
    <permissions>
      <mode>0755</mode>
      <owner>58320</owner>
      <group>100</group>
    </permissions>
  </target>
</pool>

```

```
problem: 
Error: error defining libvirt domain: unsupported configuration: spice graphics are not supported with this QEMU

solution:
Try installing "qemu-full" package
```

```
problem: VM is stuck at "booting from hard disk..."
solution: Verify that you have installed the OVMF package to allow for UEFI virtualization
```


