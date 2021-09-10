param([String] $location = "Central US")

$ErrorActionPreference = "Stop"
$paramFilePath = "./azuredeploy.param.json"
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

write-output "Writing the Deployment Output object"

#Capture Deployment Output values needed for subsequent steps
$workspaceResourceID = $deploymentOutput.Outputs["workspaceResourceId"].value
write-output "WorkspaceResourceID: $workspaceResourceID"

$primaryStorageName = $deploymentOutput.Outputs["primaryStorageName"].value
write-output "PrimaryStorageAccountName: $primaryStorageName"

$secondaryStorageName = $deploymentOutput.Outputs["secondaryStorageName"].value
write-output "SecondaryStorageAccountName: $secondaryStorageName"
