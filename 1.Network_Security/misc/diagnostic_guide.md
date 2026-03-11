Libvirt acts as the control center that handles all the virtual machines and networks spawned. It is operated by the ```virsh``` command.

Thus, virsh command is important to play with Virtual manager resources. Always use it with root privilages.

When deleting volumes, use correct path relevant to your volumes.

### INSPECTING POOLS ###

```
#To list the default resource pool
sudo virsh pool-list

#To list all existing pools
sudo virsh pool-list --all    #this gives you the pool names

#To inspect existing pools and their path
sudo virsh pool-dumpxml default_pool    #notice default_pool is the pool name. It can be any other pool as well
```

### DESTROYING POOLS ###
```
#In-case you messed up your setup and want to do a fresh start, destroying pools can come in handy. It is a two-step process.

#Step 1: To remove a pool in lbvirt you need to destroy it first
sudo virsh pool-destroy default_pool

#Step 2: You need to undefine it as well
sudo virsh pool-undefine default_pool

#This removes the pool completely
```

### LISTING RESOURCES ####

```

#To list all domains
sudo virsh list --all

#To list the volumes
sudo virsh vol-list --pool <pool-name>

#To list the networks
sudo virsh net-list

#To list all the networks deployed by libvirt
sudo virsh net-list --all
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
