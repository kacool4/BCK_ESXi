<#

 Author: Dimitrios Kakoulidis
 Date Create : 15-02-2023
 Last Update : 17-02-2023
 Version: 1.19

 .Description 
   Insert all vCenters on server_list.txt and it will create folder structure according to the clusters in the environment and backup all the hosts in their specific folder. 
   
 #> 


### Start of script ####


###  Bypass  policy
 Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
        

### Read the vcenter list in order to take backups
$vCenterList = Get-Content server_list.txt

### Create Folder from current day
$Date = (Get-Date -Format "dd\.MM\.yyyy")
New-Item -Path ".\$Date" -ItemType Directory -ErrorAction SilentlyCOntinue | Out-Null

#### Specify the folder in order it will store the files

$source = '.\'+$Date

$destination = '.\'+$Date+'.zip'

foreach($vcenter in $vCenterList){



   ### Connect to vCenters. Use domain account that has access to vCenters so you can avoid to put username and password.

      Write-Output " Connecting to vCenter "+$vcenter
      Connect-VIServer $vcenter

   ### Variable to store names of all the clusters
      $currentCluster = Get-Cluster | select -Expand Name



   ### Start backup loop for each host per cluster
     foreach ($cluster in $currentCluster) {

       ### Create folder for each Cluster
       New-Item -Path ".\$Date\$vcenter\$cluster" -ItemType Directory -ErrorAction SilentlyCOntinue | Out-Null
     
       ### Have a variable with the folder location per cluster.
       $CLFolder = ".\$Date\$vcenter\$cluster\"
    
       ### Get all the hosts from current cluster
       $vmHosts = Get-Cluster -Name $cluster | Get-VMHost | Select -ExpandProperty Name 
    
       ### Backup configuration for all hosts on current Cluster and store it to specific folder
       foreach ($vmHost in $vmHosts) {
            Get-VMHostFirmware -VMHost $vmHost -BackupConfiguration -DestinationPath $CLFolder
       }

    }

    ### Disconnect from vCenter
    Disconnect-VIServer -Confirm:$False
    Start-Sleep -s 5
    Write-Output " Disconnected from vCenter "+$vcenter

}

  ## Compress the folder and place it to Archive folder. Delete the original folder
      Start-Sleep -s 5
      Write-Output " Compressing folder to zip file."
      Compress-Archive -Path $source -DestinationPath $destination
      Start-Sleep -s 5
      Write-Output " Removing folder."
      Remove-Item -path $source -recurse


  ### End of script ####