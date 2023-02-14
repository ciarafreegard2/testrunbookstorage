
Write-Output "Connecting to azure via  Connect-AzAccount -Identity" 
Connect-AzAccount -Identity 
Write-Output "Successfully connected with Automation account's Managed Identity" 


Write-Output "Starting on $(Get-Date)"
$currenttime = Get-Date -Format HH
$DevStartTime = 16
$DevStopTime = 10
$ProdStartTime = 9
$ProdStopTime = 16

$var = Get-AzVM -Name * | Where-Object { ($_.Tags['Enviroment'] -eq 'Dev')}
Write-Output $var
#Dev
if((Get-AzVM -Name * | Where-Object { ($_.Tags['Enviroment'] -eq 'Dev')}){  
    Write-Output "dev"
    if($DevStartTime -eq $currenttime){ 
        Write-Output "1"
        $allStartVM=Get-AzVM -Name * | where {(($_.Tags.AutoStartStop -eq $true) -and ($DevStartTime -eq $currenttime))}
    }
    if($DevStopTime -eq $currenttime){
        Write-Output "2"
        $allStopVM=Get-AzVM -Name * | where {(($_.Tags.AutoStartStop -eq $true) -and ($DevStopTime -eq $currenttime))}
       
    }
}

#Prod
if((Get-AzVM -Name.Tags.Enviroment)-eq "Prod"){
    if($ProdStartTime -eq $currenttime){
        Write-Output "3"
        $allStartVM=Get-AzVM -Name * | where {(($_.Tags.AutoStartStop -eq $true) -and ($ProdStartTime -eq $currenttime))}
    }
    if($ProdStopTime -eq $currenttime){
        Write-Output "4"
        $allStopVM=Get-AzVM -Name * | where {(($_.Tags.AutoStartStop -eq $true) -and ($ProdStopTime -eq $currenttime))}
    
    }
}

# Start
foreach($vm in $allStartVM){
    Write-Output "Starting all VMs that start at $currenttime"
    try{
        $vmname =$vm.Name
        Write-Output "Starting these vms $vmname"
        Start-AzVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name
    }
    catch{
        Write-Output "Error while executing "
    }
}

#stop
foreach($vm in $allStopVM){
    Write-Output "Stopping all vms at $currenttime"
    try{
        $vmname =$vm.Name
        Write-Output "Stopping these vms $vmname"
        Stop-AzVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name -Force
    }
    catch{
        Write-Output "Error while executing "
    }
}

