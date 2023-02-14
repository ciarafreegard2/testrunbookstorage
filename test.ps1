
Write-Output "Connecting to azure via  Connect-AzAccount -Identity" 
Connect-AzAccount -Identity 
Write-Output "Successfully connected with Automation account's Managed Identity" 


Write-Output "Starting on $(Get-Date)"
$currenttime = Get-Date -Format HH

$allStopVM=Get-AzVM -Name * | where {(($_.Tags.AutoStartStop -eq $true) -and ($DevStopTime -eq $currenttime))}

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


