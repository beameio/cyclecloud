# cyclecloud

Deploying Azure CycleCloud into a subscription using an Azure Resource Manager template

Based on https://docs.microsoft.com/en-us/azure/cyclecloud/quickstart-install-cyclecloud and  https://github.com/CycleCloudCommunity/cyclecloud_arm/


Currently the main differences are:
- allows to use an already existing vnet
- installs https://github.com/beameio/cyclecloud-htcondor project in the cyclecloud machine

## Structure and Flow
* `development_install.ngs`  -> automated script, will create the azure required resources and call the azure deploy using the `azuredeploy.json` (see `Automated deploy` section)
* `azuredeploy.json` -> cyclecloud azure deploy definition file. Defines the cyclecloud infrastructure setup and contains reference to run the `install.sh` in the cyclecloud vm (with the parameters) once available.
* `install.sh` -> script that runs on the cyclecloud machine, calls the `cyclecloud_install.py` and imports the htcondor template into the machine

## Flow
`development_install.ngs` -> `azuredeploy.json` -> `install.sh` -> `cyclecloud_install.py`
																-> https://github.com/beameio/cyclecloud-htcondor fetch & import
## Manual deploy

<p><a target="_blank" title="Deploy to Azure" href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fbeameio%2Fcyclecloud%2Fmaster%2Fazuredeploy.json" data-linktype="external">
<img src="https://azuredeploy.net/deploybutton.svg" alt="" data-linktype="external">
</a></p>


## Automated deploy

A script `development_install.ngs` if provided and it creates the pre-requirements and calls the deploy with the defined parameters.

Some of the parameters are defaulted in the script itself and can be changed via command line parameters:

    * region (default is "West Europe")
	* resource_group_name (default is "htcondor-%Y%m%d%H%M")
	* virtual_nerwork_name (default is "htcondor-vnet")
	* virtual_nerwork_subnet_name (default is "default")
	* virtual_network_subnet_address_prefix (default is "10.0.0.0/24")

Call as `./development_install.ngs --resource_group_name test123 --region "West Europe" ...`


Others have to be defined in a `azuredeploy.parameters.json` file with the content:
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