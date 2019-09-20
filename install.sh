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

cyclecloudExec="/usr/local/bin/cyclecloud"
htCondorDownloadFolder="/root/htcondor-flocking"
cycleProjectsFolder="/opt/cycle_server/work/staging/projects/"
blobsDownloadLink="https://github.com/Azure/cyclecloud-htcondor/releases/download/1.0.1"
htcondorFetchLocation="https://github.com/beameio/cyclecloud-htcondor"

echo "Installing CycleCloud"
python cyclecloud_install.py --cyclecloudVersion "$cyclecloudVersion" --downloadURL "$cycleDownloadURL" --azureSovereignCloud "$azureSovereignCloud" --tenantId "$tenantId" --applicationId "$applicationId" --applicationSecret "$applicationSecret" --username "$username" --hostname "$cycleFqdn" --acceptTerms --password "${password}" --storageAccount "$storageAccountLocation"

# wait for the machine type db to be filled
sleep 60

echo "Fetching htcondor template"
$cyclecloudExec project fetch $htcondorFetchLocation $htCondorDownloadFolder

echo "Downloading blobs"
mkdir -p $htCondorDownloadFolder/blobs
(cd $htCondorDownloadFolder/blobs && \
 wget $blobsDownloadLink/condor-8.6.13-Windows-x64.msi $blobsDownloadLink/condor-8.6.13-x86_64_RedHat6-stripped.tar.gz \
  $blobsDownloadLink/condor-8.6.13-x86_64_RedHat7-stripped.tar.gz $blobsDownloadLink/condor-8.6.13-x86_64_Ubuntu14-stripped.tar.gz \
  $blobsDownloadLink/condor-8.6.13-x86_64_Ubuntu16-stripped.tar.gz $blobsDownloadLink/condor-8.6.13-x86_64_Ubuntu18-stripped.tar.gz \
  $blobsDownloadLink/condor-agent-1.27.tgz $blobsDownloadLink/condor-agent-1.27.zip )
(cd $htCondorDownloadFolder && $cyclecloudExec project build && $cyclecloudExec project upload azure-storage)
cp -rv $htCondorDownloadFolder/build/* $cycleProjectsFolder

htcondorTemplateName=$(cat $htCondorDownloadFolder/project.ini | grep "name =" | cut -d "=" -f 2 | xargs) 
echo "Importing htcondor template '$htcondorTemplateName'"
$cyclecloudExec import_template -f "$htCondorDownloadFolder/templates/htcondor.txt"

echo "Creating cluster '$clusterName' from template '$htcondorTemplateName'"
echo "{
    \"configuration_htcondor_flock_from\": \"$flockFrom\",
    \"configuration_htcondor_pool_password\": \"$poolPassword\",
    \"Owner\": \"$username\",
    \"Password\": \"$password\",
    \"Region\": \"$region\",
    \"SubnetId\": \"$subnetId\",
    \"Credentials\": \"azure\",
    \"MasterMachineType\": \"$masterMachineType\",
    \"ExecuteMachineType\": \"$executeMachineType\"
}" >> params.json
$cyclecloudExec create_cluster $htcondorTemplateName $clusterName -p params.json

echo "Starting cluster '$clusterName'"
$cyclecloudExec start_cluster $clusterName