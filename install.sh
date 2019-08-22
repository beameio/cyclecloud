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

echo "Installing CycleCloud"
python cyclecloud_install.py --applicationSecret "$applicationSecret" --applicationId "$applicationId" --tenantId "$tenantId" --azureSovereignCloud "$azureSovereignCloud" --downloadURL "$cycleDownloadURL" --cyclecloudVersion "$cyclecloudVersion" --username "$username" --hostname "$cycleFqdn" --storageAccount "$storageAccountLocation"

##### -- misses initialization of the cluster with username, password, sshKey

echo "Installing htcondor template"
/usr/local/bin/cyclecloud project fetch https://github.com/beameio/cyclecloud-htcondor /root/cyclecloud-htcondor 
#### next can be uncommented after cluster initialization
# /usr/local/bin/cyclecloud import_template -f /root/cyclecloud-htcondor/templates/htcondor.txt