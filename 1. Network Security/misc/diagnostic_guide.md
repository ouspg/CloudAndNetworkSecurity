Virsh command is important to play with Virtual manager resources. Always use it with root privilages.

When deleting volumes, use correct path relevant to your volumes.

### LISTING RESOURCES ####

```
#To list the default resource pool
sudo virsh pool-list

#To list all domains
sudo virsh list --all

#To list the volumes
sudo virsh vol-list --pool <pool-name>

#To list the networks
sudo virsh net-list
```
### DELETING RESOURCE INSTANCES

```
#To remove domains you need to undefine them
sudo virsh undefine kvm-opnsense
sudo virsh undefine ubuntu-domain

#To delete the volumes
sudo virsh vol-delete /var/lib/libvirt/images/commoninit.iso
sudo virsh vol-delete /var/lib/libvirt/images/opnsense-qcow2
sudo virsh vol-delete /var/lib/libvirt/images/ubuntu-commoninit.iso
sudo virsh vol-delete /var/lib/libvirt/images/ubuntu-qcow2

#To delete networks you also have to undefine them as well
sudo virsh net-destroy cyber-range-LAN
sudo virsh net-undefine cyber-range-LAN

sudo virsh net-destroy default_network
sudo virsh net-undefine default_network
```
