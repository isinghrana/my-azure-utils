param( 
    [Parameter(Mandatory = $true)]    
    [string] $storageAccountName,
    [Parameter(Mandatory = $true)]    
    [string] $workspaceName)

$ErrorActionPreference = "Stop"

#json string template for creating the LinkedService Definition file
$createLinkedServiceJsonString = "
{    
    `"type`": `"Microsoft.Synapse/workspaces/linkedservices`",
    `"properties`": {        
        `"type`": `"AzureBlobFS`",
        `"typeProperties`": {
            `"url`": `"https://{storageaccountname}.dfs.core.windows.net`"
        },
        `"connectVia`": {
            `"referenceName`": `"AutoResolveIntegrationRuntime`",
            `"type`": `"IntegrationRuntimeReference`"
        }
    }
}"

#$storageAccountName = "isrsyns2sdstg"
#$workspaceName = "isrsyns2ws"

$createLinkedServiceFinalString = $createLinkedServiceJsonString -replace "{storageaccountname}", $storageAccountName
write-output "LinkedService creation JSON - "
write-output $createLinkedServiceFinalString

$tempFolderPath = ".\temp"

if (!(Test-path -path $tempFolderPath))
{
    New-Item -ItemType directory -path $tempFolderPath
}

write-output "creating the LinkedService Definition Json file...."
$createLinkedServiceFilePath = ".\$tempFolderPath\createlinkedservice.json"
Set-Content -Path $createLinkedServiceFilePath -value $createLinkedServiceFinalString

write-Output "Creating Linked Service for storage account $storageAccountName ...."
$linkedServiceName = $storageAccountName + "LinkedService"
Set-AzSynapseLinkedService -WorkspaceName $workspaceName -Name $linkedServiceName -DefinitionFile $createLinkedServiceFilePath


