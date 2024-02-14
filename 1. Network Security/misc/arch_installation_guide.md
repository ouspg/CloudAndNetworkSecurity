# Installation instructions

This installation instruction is designed for arch linux operating system.

VM Passwords

## Install and setup libvirtd and necessary packages for UEFI virtualization
```
# Update package databases
sudo pacman -Syu

# Install necessary packages
sudo pacman -S qemu virt-manager libvirt ebtables dnsmasq bridge-utils openbsd-netcat


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
### download the required opnsense image
https://github.com/maurice-w/opnsense-vm-images/releases/tag/23.7.11

(I am currently using the OPNsense-23.7.11-ufs-efi-vm-amd64.qcow2.bz2)

Move the image to terraform-testing directory and rename it opnsense.qcow2. Place it next to main.tf file

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

```
sudo virsh pool-define /dev/stdin <<EOF
<pool type='dir'>
  <name>default</name>
  <target>
    <path>$PWD/images</path>
  </target>
</pool>
EOF

sudo virsh pool-start default
sudo virsh pool-autostart default
```

### Configure user permisions for libvirt to storage pool
```
sudo chown -R $(whoami):libvirt ~/images
sudo systemctl restart libvirtd
```


### Terraform magic
```
export TERRAFORM_LIBVIRT_TEST_DOMAIN_TYPE="qemu"
terraform init
terraform apply
```

### If you want to deploy the docker containers you need to have docker engine running
(Otherwise just change the extension of docker.tf from tf to txt)


## Issues & fixes:
```
problem:
│ Error: error creating libvirt domain: Cannot access storage file '/home/arch/images/opnsense-qcow2' (as uid:1000, gid:962): Lupa evätty
│
│   with libvirt_domain.domain-opnsense,
│   on main.tf line 54, in resource "libvirt_domain" "domain-opnsense":
│   54: resource "libvirt_domain" "domain-opnsense" {
│
╵
╷
│ Error: error creating libvirt domain: Cannot access storage file '/home/arch/images/ubuntu-qcow2' (as uid:1000, gid:962): Lupa evätty
│
│   with libvirt_domain.ubuntu-domain,
│   on probing-machine.tf line 22, in resource "libvirt_domain" "ubuntu-domain":
│   22: resource "libvirt_domain" "ubuntu-domain" {


solution:
what are your home folder's permissions. Kvm group needs to be able to access it (permission 755 should do it). Concerning the qcow2 file it should also be writable for the kvm group (666 or 664 with kvm group would be ok, but not 644) 

commands:
# Set the correct ownership and permissions for the directory
sudo chown -R root:kvm /home/arch/images
sudo chmod 755 /home/arch/images

# Set the correct ownership and permissions for the qcow2 files
sudo chmod 664 /home/arch/images/opnsense-qcow2 /home/arch/images/ubuntu-qcow2
sudo chown root:kvm /home/arch/images/opnsense-qcow2 /home/arch/images/ubuntu-qcow2


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
pool default not found

solution:
sudo virsh pool-define /dev/stdin <<EOF
<pool type='dir'>
  <name>default</name>
  <target>
    <path>/var/lib/libvirt/images</path>
  </target>
</pool>
EOF

sudo virsh pool-start default
sudo virsh pool-autostart default
```

```
problem: VM is stuck at "booting from hard disk..."
solution: Verify that you have installed the OVMF package to allow for UEFI virtualization
```

