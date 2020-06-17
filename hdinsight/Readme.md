
Sample scripts to create and HDInsight environment as shown in the following architecture diagram.

<img src="./ArchitectureDiagram.JPG" alt="Architecture Diagram" width="100%" height="100%">

**Environment Creation**
1. Download Terraform - https://www.terraform.io/
2. Download the folder/repo to local machine
3. Go over the *variable.tf* file and update the values as per your environment, the file itself has instructions in the comments
4. On a Terminal go to the *hdinsight* folder 
5. Run the command *terraform init*
6. Run the command *terraform apply* to create the environment

It takes about 30-40 minutes to provision this environment. A total to 2 Resource Groups are created, one for Azure HInsight cluster and the other for pre-requiste resources needed by Azure HDInsight.

Following resources are created as part of these scripts
- Azure VNET with Subnets and NSGs
- Azure Virtual Machine with Network Interface Card
- Azure Bastion with Public IP
- Azure HDInsight Cluster with Load Balancers, Public IP, Network Interface Cards, etc.
- Azure SQL Database with logical server
- Azure Data Lake Gen2 (storage account)
- User Managed Identity for Azure HDInsight

**Environment Deletion**

These resources will cost a few dollars per hour so do remember to delete the environment. To delete the environment run the command *terraform destroy*. There is a known issue where deletion could fail, just re-run the command and it should work the second time. I have it on my list to investigate fix for this issue.


**Azure ARM Template for HDInsight**

You will notice that the actual HDInsight is provisioned using Azure ARM Template rather than Terraform and this is because currently Terraform HDInsight Spark resource does not allow provisioning cluster with external metastore. This is also the reason for creating HDInsight clsuter in a separate resource group, as per the documentation [azurerm_template_deployment](https://www.terraform.io/docs/providers/azurerm/r/template_deployment.html) its better to create resources from ARM Template in a separate Resource Group.