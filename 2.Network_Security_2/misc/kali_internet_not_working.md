### If you used nested virtualization and the internet on the kali linux is not working follow this guide!

## 1.

Destroy everything and remove terraform tf state files 
```
terraform destroy
rm terraform.tfstate
rm terraform.tfstate.backup
```


## 2. 

Power off your virtual arch and go-to network settings and choose Bridged Adapter. Refresh and assign it a new MAC address. Promisciuos mode tick allow all. 
Virtual cable tick connected.

<img width="752" height="334" alt="image" src="https://github.com/user-attachments/assets/65f49359-9077-408d-bfe2-c946e2112ac3" />

Start your arch VM and ensure internet connectivity. This is very important!

## 3.

Next spawn your network using:
```
export TERRAFORM_LIBVIRT_TEST_DOMAIN_TYPE="qemu"
terraform init
terraform apply
```
Ensure correct IP assignment and access
1. Make sure you have access to webGUI and you can access the webserver from your virtual arch at https://198.168.122.216
   <img width="427" height="212" alt="image" src="https://github.com/user-attachments/assets/f933af56-da14-4e3d-800f-9e0f05415e88" />
   <img width="495" height="316" alt="image" src="https://github.com/user-attachments/assets/68d67521-0366-4f0a-999a-073f36dfcc82" />

2. Ensure correct IP assignment to the kali linux and that it can ping the WAN IP + pfsense.
3. Problem mouse not working inside kali linux?
```
solution: add a tablet input option in virt-manager to the machine by clicking the blue info button under the "File" option and choose "Add Hardware" -> "Input" -> "Type: EvTouch USB Graphics Tablet" -> "Finish"
```
<img width="425" height="401" alt="image" src="https://github.com/user-attachments/assets/de31ac45-bb44-44d3-89ea-8abae4e27e99" />


## 4.
Go to your arch linux
1. List all the routes to find networks on your arch:
`ip route`

<img width="768" height="108" alt="image" src="https://github.com/user-attachments/assets/77d154e8-cf13-495b-b828-d93ede67438b" />


The issue in kali internet connectivity is not in the WAN and LAN network setup via pfsense. The traffic is correctly routed between the WAN and LAN
which is virbr3 adapter on arch showing the network of 198.168.122.0/24. However, the arch linux is accesing the internet on the adapter enp0s3 shown as the default route. We have to establish the connectivity between enp0s3 and virbr3 to restore the internet access on kali linux.

Goal: To make pfSense WAN use Arch VM as the gateway for external traffic. To do this we can perform IP forwarding on the arch linux.

Check if ip forwarding is enabled (output=1 means enabled)
`cat /proc/sys/net/ipv4/ip_forward`

If output=0 use
`sudo sysctl -w net.ipv4.ip_forward=1`

Enable NAT (MASQUERADE) from virbr3 → enp0s3 (change adapter names accoridng to your VM)
```
sudo iptables -t nat -A POSTROUTING -s 198.168.122.0/24 -o enp0s3 -j MASQUERADE
sudo iptables -A FORWARD -i enp0s3 -o virbr3 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i virbr3 -o enp0s3 -j ACCEPT
```
<img width="1400" height="115" alt="image" src="https://github.com/user-attachments/assets/519ab27f-ca64-46c5-a744-e103e4148382" />

## 5.
Confirm internet access to the pfsense.

Use pfsense Diagnostic menu's ping option to test internet availability. Ping 8.8.8.8 and  google.com. If it succeeds follow the next step:
<img width="570" height="614" alt="image" src="https://github.com/user-attachments/assets/7fa0bb92-dd87-4c23-9565-bd18c36992b8" />

## 6.
Go to kali:
`sudo nano /etc/resolv.conf`

Add following at the end and save the file
`nameserver 8.8.8.8`
<img width="663" height="519" alt="image" src="https://github.com/user-attachments/assets/3f9377b1-52ed-4b78-8ac0-cb122202176d" />

Now ping 8.8.8.8 from kali and your internet access should be restored.
