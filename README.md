# Backup ESXi configuration of your Infra.

## Scope:
 You can use the script in order to backup ESXi configuration of your environment. Insert all the vCenters on the file "server_list.txt" and run it. The script will create folder structure same as your infra cluster. It will go to each cluster and take backup configuration of the hosts and store it to the correct folder/cluster. In the end it will zip the main folder (it would be the folder with naming of the current date).

## Requirements:
* Windows Server 2012 and above // Windows 10
* Powershell 5.1 and above
* PowerCLI either standalone or import the module in Powershell (Preferred)
* ESXi version 6.X
* ESXi must be part of a vCenter

## Running the script
Open Powershell or Powercli and run the script directly
```powershell
  PS> ESXi-BCK.ps1
```
If you run it under domain account that has access to vCenter it will not ask you for Username or password. Otherwise it will promt to enter credentials. 

## Frequetly Asked Questions:
* Will be there downtime during this activity?
   > No there is no downtime. The script does not interfere with the VMs inside. 

* Are there any steps to perform before running the script to the ESXi?
   > No. You dont have to set the host to maintenance mode or migrate all the vms to some other host before running the script.
   
* Can I put multiple vCenters?
   > Yes. You can put all the vCenters in the server_list.txt  in the format of one under another NOT in one line separated via commas.
 
  
