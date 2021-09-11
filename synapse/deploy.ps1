param([String] $location = "Central US")

$ErrorActionPreference = "Stop"
$paramFilePath = "$PSScriptRoot\azuredeploy.param.json"
Write-Debug "Reading parameter file to identify Prefix parameter value which is used to name Resoruce Group and resources"

$paramObj = Get-Content -Path $paramFilePath | ConvertFrom-Json
$prefix = $paramObj.parameters.prefix.value
Write-Information "Identified Prefix from parameter file: $prefix"

#create resource group
$resourceGroup = "$prefix-rg"
New-AzResourceGroup -Name $resourceGroup -Location $location

#run the deployment
$deploymentName = "synapasedeployment-" + (Get-Date -Format "yyyyMMdd-HHmmss")
$deploymentOutput = New-AzResourceGroupDeployment -Name $deploymentName -ResourceGroupName $resourceGroup -TemplateFile "./azuredeploy.json" -TemplateParameterFile "./azuredeploy.param.json" -Verbose

write-output "Reading output values from Deployment Output object"

#Capture Deployment Output values needed for subsequent steps
$workspaceResourceID = $deploymentOutput.Outputs["workspaceResourceId"].value
write-output "WorkspaceResourceID: $workspaceResourceID"

$workspaceName = $deploymentOutput.Outputs["workspaceName"].value
write-output "WorkspaceName: $workspaceName"

$primaryStorageName = $deploymentOutput.Outputs["primaryStorageName"].value
write-output "PrimaryStorageAccountName: $primaryStorageName"

$secondaryStorageName = $deploymentOutput.Outputs["secondaryStorageName"].value
write-output "SecondaryStorageAccountName: $secondaryStorageName"

Write-output "Retrieving current Azure Context to get TenantID"
$context = Get-AzContext
$tenantId = $context.Tenant.TenantId
write-output "TenantId: $tenantId"

Write-Output "Adding Resource Access Rule to $primaryStorageName to allow connections from Synapse Workspace"
Add-AzStorageAccountNetworkRule -ResourceGroupName $resourceGroup -Name $primaryStorageName -TenantId $tenantId -ResourceId $workspaceResourceID


Write-Output "Adding Resource Access Rule to $secondaryStorageName to allow connections from Synapse Workspace"
Add-AzStorageAccountNetworkRule -ResourceGroupName $resourceGroup -Name $secondaryStorageName -TenantId $tenantId -ResourceId $workspaceResourceID

Write-Output "Creating Managed Private Endpoint for $primaryStorageName"
& "$PSScriptRoot\nestedscripts\createprivateendpoint.ps1" -storageAccountName $primaryStorageName -workspacename $workspaceName

write-Output "Creating Managed Private Endpoint for $secondaryStorageName"
& "$PSScriptRoot\nestedscripts\createprivateendpoint.ps1" -storageAccountName $secondaryStorageName -workspacename $workspaceName

write-Output "Creating Linked Service for  $secondaryStorageName"
& "$PSScriptRoot\nestedscripts\createlinkedservice.ps1" -storageAccountName $secondaryStorageName -workspacename $workspaceName