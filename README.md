# cyclecloud

Deploying Azure CycleCloud into a subscription using an Azure Resource Manager template

Based on https://docs.microsoft.com/en-us/azure/cyclecloud/quickstart-install-cyclecloud and  https://github.com/CycleCloudCommunity/cyclecloud_arm/


Currently the main differences are:
- allows to use an already existing vnet
- installs https://github.com/beameio/cyclecloud-htcondor project in the cyclecloud machine


<p><a target="_blank" title="Deploy to Azure" href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fbeameio%2Fcyclecloud%2Fmaster%2Fazuredeploy.json" data-linktype="external">
<img src="https://azuredeploy.net/deploybutton.svg" alt="" data-linktype="external">
</a></p>


Development:

A script (test_install.ngs) if provided that creates the pre-requirements and calls the deploy with the defined parameters.
Some of the parameters are defaulted in the script itself and can be changed via command line parameters.

Others shall be defined in a 'azuredeploy.parameters.json' file with the content:

azuredeploy.parameters.json
```
{
  "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
		"tenantId": {
			"value": ""
		},
		"applicationId": {
			"value": ""
		},
		"applicationSecret": {
			"value": ""
		},
		"SSH Public Key": {
			"value": ""
		},
		"username": {
			"value": ""
		},
		"password": {
			"value": ""
		}
  }
}
```