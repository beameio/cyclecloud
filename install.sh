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

echo "Installing CycleCloud"
python cyclecloud_install.py --applicationSecret "$applicationSecret" --applicationId "$applicationId" --tenantId "$tenantId" --azureSovereignCloud "$azureSovereignCloud" --downloadURL "$cycleDownloadURL" --cyclecloudVersion "$cyclecloudVersion" --username "$username" --hostname "$cycleFqdn" --storageAccount "$storageAccountLocation"

echo "Installing htcondor template"
/usr/local/bin/cyclecloud project fetch https://github.com/beameio/cyclecloud-htcondor /root/custom-htcondor
/usr/local/bin/cyclecloud import_template -f /root/custom-htcondor/templates/htcondor.txt

# cp /opt/cycle_server/work/staging/projects/htcondor/blobs /opt/cycle_server/work/staging/projects/custom-htcondor/ -rv
# (cd /opt/cycle_server/work/staging/projects/custom-htcondor && cyclecloud project build && cyclecloud import_template -f templates/htcondor.txt)