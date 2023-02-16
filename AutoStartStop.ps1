[CmdletBinding()]param (
[Parameter(Mandatory=$true)]
[string]$enviroment,
[Parameter(Mandatory=$true)]
[string]$operation
)

Write-Output "Connecting to azure via  Connect-AzAccount -Identity" 
Connect-AzAccount -Identity 
Write-Output "Successfully connected with Automation account's Managed Identity" 

$allStartVM = @()
$allStopVM = @()
Write-Output "Starting on $(Get-Date)"
$currenttime = Get-Date -Format HH
# $DevStartTime = 13
# $DevStopTime = 13
# $ProdStartTime = 13
# $ProdStopTime = 13

#Dev
if(($enviroment -eq "dev") -and ($operation -eq"start")){ 
    Write-Output "1"
    $allStartVM+=Get-AzVM -Name * | where {(($_.Tags.AutoStartStop -eq $true) -and ($_.Tags['Enviroment'] -eq 'Dev'))}
}
if(($enviroment -eq "dev") -and ($operation -eq"stop")){
    Write-Output "2"
    $allStopVM+=Get-AzVM -Name * | where {(($_.Tags.AutoStartStop -eq $true) -and ($_.Tags['Enviroment'] -eq 'Dev'))}
}

#Prod
if(($enviroment -eq "prod") -and ($operation -eq"start")){
    Write-Output "3"
    $allStartVM+=Get-AzVM -Name * | where {(($_.Tags.AutoStartStop -eq $true) -and ($_.Tags['Enviroment'] -eq 'Prod'))}
}
if(($enviroment -eq "prod") -and ($operation -eq"stop")){
    Write-Output "4"
    $allStopVM+=Get-AzVM -Name * | where {(($_.Tags.AutoStartStop -eq $true) -and ($_.Tags['Enviroment'] -eq 'Prod'))}
}


# Start
foreach($vm in $allStartVM){
    Write-Output "Starting all VMs that start at $currenttime"
    try{
        $vmname =$vm.Name
        Write-Output "Starting this vm $vmname"
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
        Write-Output "Stopping this vm $vmname"
        Stop-AzVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name -Force
    }
    catch{
        Write-Output "Error while executing "
    }
}
