#!/bin/bash

applicationSecret=$1
applicationId=$2
tenantId=$3
azureSovereignCloud=$4
cycleDownloadURL=$5
cyclecloudVersion=$6
username=$7
cycleFqdn=$8
storageAccountLocation=$9
password=${10}
sshKey=${11}
clusterName=${12}
flockFrom=${13}
poolPassword=${14}
region=${15}
subnetId=${16}
masterMachineType=${17}
executeMachineType=${18}

echo "Installing CycleCloud"
python cyclecloud_install.py --cyclecloudVersion "$cyclecloudVersion" --downloadURL "$cycleDownloadURL" --azureSovereignCloud "$azureSovereignCloud" --tenantId "$tenantId" --applicationId "$applicationId" --applicationSecret "$applicationSecret" --username "$username" --hostname "$cycleFqdn" --acceptTerms --password "${password}" --storageAccount "$storageAccountLocation"

echo "Fetching htcondor template"
/usr/local/bin/cyclecloud project fetch https://github.com/beameio/cyclecloud-htcondor /root/cyclecloud-htcondor 

htcondorTemplateName=$(cat /root/cyclecloud-htcondor/project.ini | grep "name =" | cut -d "=" -f 2 | xargs) 
echo "Importing htcondor template '$htcondorTemplateName'"
/usr/local/bin/cyclecloud import_template -f /root/cyclecloud-htcondor/templates/htcondor.txt

echo "Starting cluster '$clusterName' from template '$htcondorTemplateName'"

echo "{
    \"configuration_htcondor_flock_from\": \"$flockFrom\",
    \"configuration_htcondor_pool_password\": \"$poolPassword\",
    \"Password\": \"$password\",
    \"Region\": \"$region\",
    \"SubnetId\": \"$subnetId\",
    \"Credentials\": \"azure\",
    \"MasterMachineType\": \"$masterMachineType\",
    \"ExecuteMachineType\": \"$executeMachineType\"
}" >> params.json

/usr/local/bin/cyclecloud create_cluster $htcondorTemplateName $clusterName -p params.json
/usr/local/bin/cyclecloud start_cluster $clusterName
