$ErrorActionPreference = "Stop"
$createPrivateEndpointJsonString = "
{    
    `"properties`": {
        `"privateLinkResourceId`": `"{privatelinkresourceid}`",
        `"groupId`": `"dfs`"
    }
}"

$storageAccountName = "isrsyns2prstg"
$workspaceName = "isrsyns2ws"

$storageAccountPrivateLinkResourceId = (Get-AzResource -Name $storageAccountName).ResourceId

$createPrivateendpointFinalString = $createPrivateEndpointJsonString -replace "{privateLinkResourceId}", $storageAccountPrivateLinkResourceId
write-output "PrivateLink creation JSON -"
write-output $createPrivateendpointFinalString

$tempFolderPath = ".\temp"

if (!(Test-path -path $tempFolderPath))
{
    New-Item -ItemType directory -path $tempFolderPath
}

write-output "createing the PrivateEndpoint Definition Json file...."
$createPrivateEndpointFilePath = ".\$tempFolderPath\createprivateendpoint.json"
Set-Content -Path $createPrivateEndpointFilePath -value $createPrivateendpointFinalString

$privateEndpointName = "$storageAccountName" + "PrivateEndpoint"
write-Output "Creating new private endpoint for storage account $storageAccountName - $privateEndpointName ...."
New-AzSynapseManagedPrivateEndpoint -WorkspaceName $workspaceName -Name $privateEndpointName -DefinitionFile $createPrivateEndpointFilePath

$counter = 0
do {
    write-Output "Waiting for Private Endpoint Provisioning State to be Succeeded....."
    Start-Sleep 15
    $counter++
    $privateEndpointConnectionObj = Get-AzPrivateEndpointConnection -PrivateLinkResourceId $storageAccountPrivateLinkResourceId
    write-output $privateEndpointConnectionObj
    if ($privateEndpointConnectionObj.ProvisioningState -eq "Succeeded" )
    {
        write-Output "Private Endpoint provisioning state is Succeeded"
        if ($privateEndpointConnectionObj.PrivateLinkServiceConnectionState.Status -eq "Approved")
        {
            Write-Output "Private Endpoint for $storageAccountName is already approved"
            break
        }
        write-output "Approving Private Endpoint Connection for $storageAccountName ...."
        Approve-AzPrivateEndpointConnection -ResourceId $privateEndpointConnectionObj.id
        write-output "Private Endpoint for $storageAccountName successfully approved"
        break
    }
    elseif($privateEndpointConnectionObj.ProvisioningState -eq "Failed" )
    {
        Write-Error "Error in provisioing Private Endpoint for $storageAccountName"        
        break
    }    
    elseif ($counter -ge 10) {
        Write-Error "PrivateEndpoint creation for $storageAccountName stuck so erroring out after 10 retries"
    }
    
} while($true)

