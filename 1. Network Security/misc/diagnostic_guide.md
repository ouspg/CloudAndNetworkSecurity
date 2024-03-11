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
sudo virsh destroy pfsense-domain
sudo virsh undefine pfsense-domain --remove-all-storage

sudo virsh destroy ubuntu-domain
sudo virsh undefine ubuntu-domain --remove-all-storage

sudo virsh destroy kali-domain
sudo virsh undefine kali-domain --remove-all-storage

#To delete the volumes
sudo virsh vol-delete  $PWD/volumes/pfsense-commoninit.iso
sudo virsh vol-delete $PWD/volumes/pfsense-volume
sudo virsh vol-delete $PWD/volumes/ubuntu-commoninit.iso
sudo virsh vol-delete $PWD/volumes/ubuntu-volume
sudo virsh vol-delete $PWD/volumes/kali-commoninit.iso
sudo virsh vol-delete  $PWD/volumes/kali-volume

#To delete networks you also have to undefine them as well
sudo virsh net-destroy external_network
sudo virsh net-undefine external_network
sudo virsh net-destroy internal_network
sudo virsh net-undefine internal_network
sudo virsh net-destroy demilitarized_zone
sudo virsh net-undefine demilitarized_zone
```
