#!/bin/bash

####################################################
###      PLEASE DON'T CHANGE THESE VALUES!!      ###
####################################################
PROJECT_ID=""                                    ###
PROJECT_REGION="europe-west"                     ###
PROJECT_REGION_BIGTABLE="europe-west1-b"         ###
BILLING_DATASET_ID="demo"                     ###
BILLING_PROJECT_ID="demo"                 ###
####################################################

exit_script() {
  [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
}

yes_check() {
  read -p " (Y/n) " -n 1 -r
  if [[ ! $REPLY =~ ^[Yy]$ ]]
  then
    echo
    exit_script
  fi
  echo "\n"
}

if [[ ! $(gcloud beta billing accounts list | grep "Listed") == "" ]]; then
  echo "You have not enough permissions to setup new projects"
  exit_script
fi


clear
columns="$(tput cols)"
bold=$(tput bold)
normal=$(tput sgr0)
echo "\n\n"
printf "%0.s#" $(seq 1 $columns)
printf "%*s\n" $(( (7 + columns) / 2)) "WARNING"
printf "%*s\n" $(( (21 + columns) / 2)) "PLEASE READ CAREFULLY"
printf "%0.s#" $(seq 1 $columns)
echo "\n"
echo "This script will create a NEW project in the Google Cloud"
echo "Creating a new project will require certain admin rights"
echo "If you DON'T have those rights, please exit this script"
printf "Do you want to continue?"
yes_check

read -p "Please provide the new ID of the project: " PROJECT_ID

if [[ $PROJECT_ID == "" ]]; then
  echo "Please provide a project id!"
  exit_script
fi

printf "The new project will be $PROJECT_ID, is this correct?"
yes_check

REGION_SET=False
read -p "In which region do you want to set up project $PROJECT_ID? (EU/US) " REGION_CODE
if [ "$REGION_CODE" == "EU" ]; then
  REGION_SET=TRUE
  echo
elif [ "$REGION_CODE" == "US" ]; then
  REGION_SET=TRUE
  PROJECT_REGION="us-central"
  PROJECT_REGION_BIGTABLE="us-central1-b"
  PROJECT_REGION_REDIS="us-central1"
  PROJECT_REGION_VPC="us-central1"
  echo
fi

if [ $REGION_SET == False ]; then
  echo "\n\n\n"
  echo "Failed to set a region, please select EU or US."
  exit_script
fi

LOWERCASE_REGION=$(echo "$REGION_CODE" | tr '[:upper:]' '[:lower:]')

printf "After this step we will start setting up the new project with id ${bold}$PROJECT_ID${normal} in region ${bold}$PROJECT_REGION${normal}, are you sure?"
yes_check

printf "This action can not be reversed, are you very certain?"
yes_check

#SERVICES="appengine.googleapis.com  bigquerystorage.googleapis.com bigtable.googleapis.com bigtableadmin.googleapis.com cloudapis.googleapis.com cloudbuild.googleapis.com clouddebugger.googleapis.com cloudresourcemanager.googleapis.com cloudtasks.googleapis.com cloudtrace.googleapis.com compute.googleapis.com container.googleapis.com containerregistry.googleapis.com dataflow.googleapis.com datastore.googleapis.com deploymentmanager.googleapis.com endpoints.googleapis.com geolocation.googleapis.com iam.googleapis.com iamcredentials.googleapis.com logging.googleapis.com maps-backend.googleapis.com monitoring.googleapis.com oslogin.googleapis.com pubsub.googleapis.com redis.googleapis.com resourceviews.googleapis.com servicecontrol.googleapis.com servicemanagement.googleapis.com serviceusage.googleapis.com sql-component.googleapis.com stackdriver.googleapis.com storage-api.googleapis.com storage-component.googleapis.com vpcaccess.googleapis.com"
SERVICES="appengine.googleapis.com bigquery.googleapis.com bigquerystorage.googleapis.com bigtable.googleapis.com cloudbuild.googleapis.com clouddebugger.googleapis.com cloudresourcemanager.googleapis.com  datastore.googleapis.com deploymentmanager.googleapis.com iam.googleapis.com iamcredentials.googleapis.com logging.googleapis.com  monitoring.googleapis.com oslogin.googleapis.com pubsub.googleapis.com  servicecontrol.googleapis.com servicemanagement.googleapis.com serviceusage.googleapis.com stackdriver.googleapis.com storage-api.googleapis.com storage-component.googleapis.com"
COMPONENTS="beta bq"

ORGANISATION_ID="791769602271"
BILLING_ACCOUNT="016CEA-CC6D55-4E7870"
BILLING_ACCOUNT_FAMILY="01FDED-42E1F9-1C76EB"

echo "Creating project with id $PROJECT_ID"
gcloud projects create "$PROJECT_ID" --organization=$ORGANISATION_ID
echo "Creating project to the billing account"
gcloud beta billing projects link "$PROJECT_ID" --billing-account=$BILLING_ACCOUNT

for SERVICE in $SERVICES; do echo "Installing service $SERVICE..." && gcloud services enable "$SERVICE" --project="$PROJECT_ID"; done

echo "Setting up AppEngine"
gcloud app create --region=$PROJECT_REGION --project="$PROJECT_ID"
#echo "Setting up BigTable"
#gcloud bigtable instances create ewx-"${LOWERCASE_REGION}"-bigtable --cluster=ewx-"${LOWERCASE_REGION}"-bigtable --display-name=ewx-"${LOWERCASE_REGION}"-bigtable --cluster-zone=$PROJECT_REGION_BIGTABLE --cluster-storage-type=HDD --instance-type=DEVELOPMENT --project=$PROJECT_ID #--cluster-num-nodes=1
#echo "Setting up the application profiles in bigtable"
#gcloud bigtable app-profiles create write --instance=ewx-"${LOWERCASE_REGION}"-bigtable --route-to=ewx-"${LOWERCASE_REGION}"-bigtable --transactional-writes --project="$PROJECT_ID"
#gcloud bigtable app-profiles create read --instance=ewx-"${LOWERCASE_REGION}"-bigtable --route-to=ewx-"${LOWERCASE_REGION}"-bigtable --transactional-writes --project="$PROJECT_ID"
#echo "Setting up Redis"
#gcloud redis instances create ewx-"${LOWERCASE_REGION}"-memorystore --region=$PROJECT_REGION_REDIS --redis-version=redis_4_0 --reserved-ip-range="10.104.130.192/29" --size=4 --tier=standard --project=$PROJECT_ID
#echo "Enabling VPC private access for region ${PROJECT_REGION_VPC}"
#gcloud compute networks subnets update default --region=$PROJECT_REGION_VPC --enable-private-ip-google-access --project=$PROJECT_ID
#echo "Setting up VPC Network"
#gcloud compute networks vpc-access connectors create appengine-to-redis --region=$PROJECT_REGION_VPC --range="10.90.0.0/28" --project=$PROJECT_ID
#echo "Adding serviceaccount 678868332498-compute@developer.gserviceaccount.com"
#gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:678868332498-compute@developer.gserviceaccount.com" --role="roles/editor"
#echo "Adding all energyworx users as viewer"
#gcloud projects add-iam-policy-binding $PROJECT_ID --member="domain:energyworx.org" --role="roles/viewer"
echo "Creating new service account for project ${PROJECT_ID}"
gcloud iam service-accounts create "${PROJECT_ID}" --description "Default service account for deploying dataflows" --project="$PROJECT_ID"
echo "Downloading keyfile for newly created service account"
#gcloud iam service-accounts keys create ../../resources/security/"${PROJECT_ID}".json --iam-account "${PROJECT_ID}"@"${PROJECT_ID}".iam.gserviceaccount.com --project="$PROJECT_ID"
#cp ../../resources/security/"${PROJECT_ID}".json ../../packages/energyworx-dataflow-base/energyworx_dataflow_base/resources/"${PROJECT_ID}".py
echo "Granting service account ${PROJECT_ID}@${PROJECT_ID}.iam.gserviceaccount.com editor rights"
gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:${PROJECT_ID}@${PROJECT_ID}.iam.gserviceaccount.com" --role="roles/editor"
echo "Set default project to ${PROJECT_ID}"
gcloud config set project "${PROJECT_ID}"
echo "Initial steps for setup billing | Install components"
for COMPONENT in $COMPONENTS; do echo "Installing component $COMPONENT..." && y | gcloud components install "$COMPONENT"; done
echo "Creating a billing dataset for ${PROJECT_ID}"
 bq --location="$REGION_CODE" mk --description "A billing dataset for ${PROJECT_ID}" ${BILLING_DATASET_ID}
echo "Creating a monthly billing bigquery view for ${PROJECT_ID}"
bq mk --use_legacy_sql=false --description "A billing view to expose monthly costs for ${PROJECT_ID}" --label energyworx-monthly:"${PROJECT_ID}" \
--view \
"SELECT
  project_id,
  invoice_month,
  ROUND(cost, 2) AS cost,
  date,
  currency
FROM
  ${BILLING_PROJECT_ID}.billing.monthly_costs_per_project
WHERE
  project_id IN ('${PROJECT_ID}')" \
${BILLING_DATASET_ID}.project_monthly_billing

echo "Creating a daily billing bigquery view for ${PROJECT_ID}"
bq mk --use_legacy_sql=false --description "A billing view to expose daily costs for ${PROJECT_ID}" --label energyworx-daily:"${PROJECT_ID}" \
--view \
"SELECT
  project_id,
  invoice_month,
  ROUND(cost, 2) AS cost,
  currency
FROM
  ${BILLING_PROJECT_ID}.billing.daily_costs_per_project
WHERE
  project_id IN ('${PROJECT_ID}')" \
${BILLING_DATASET_ID}.project_daily_billing


FILE_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"/../environments.py

PARTIAL_PROJECT_ID=$(echo "${PROJECT_ID#*-}" | sed 's/-/_/g')
BUCKET_PREFIX_PROJECT_ID=$(echo "${PROJECT_ID#*-}" | sed 's/-//g')
VARIABLE_NAME_PROJECT_ID=$(echo $PARTIAL_PROJECT_ID | tr '[:lower:]' '[:upper:]')
SERVICE_ACCOUNT_EMAIL=$(gcloud iam service-accounts list --project=$PROJECT_ID --filter="Compute Engine default service account" | grep '@' | awk '{ print $6 }')
SERVICE_ACCOUNT_ID=$(gcloud iam service-accounts list --project=$PROJECT_ID --filter="Compute Engine default service account" --uri | sed 's/.*\///')
#REDIS_IP_ADDRESS=$(gcloud beta redis instances list --region=$PROJECT_REGION_REDIS --project=$PROJECT_ID | grep 'REDIS_4_0' | awk '{ print $6 }')

GENERATED_SERVICE_ACCOUNT_ID=$(gcloud iam service-accounts describe ${PROJECT_ID}@${PROJECT_ID}.iam.gserviceaccount.com --project=$PROJECT_ID | grep 'uniqueId' | awk '{print $2}')
GENERATED_SERVICE_ACCOUNT_EMAIL=$(echo "'${PROJECT_ID}@${PROJECT_ID}.iam.gserviceaccount.com'")


echo "" >> $FILE_PATH
echo "# PROJECT: ${PROJECT_ID}" >> $FILE_PATH
echo "${VARIABLE_NAME_PROJECT_ID}_PROJECT_ID = '${PROJECT_ID}'"  >> $FILE_PATH
echo "${VARIABLE_NAME_PROJECT_ID}_DATAFLOW_SERVICE_ACCOUNT = ServiceAccount('${SERVICE_ACCOUNT_ID}', '${SERVICE_ACCOUNT_EMAIL}')" >> $FILE_PATH
echo "${VARIABLE_NAME_PROJECT_ID}_GENERATED_SERVICE_ACCOUNT = ServiceAccount(${GENERATED_SERVICE_ACCOUNT_ID}, ${GENERATED_SERVICE_ACCOUNT_EMAIL})" >> $FILE_PATH
echo "${VARIABLE_NAME_PROJECT_ID}_NAMESPACE_PREFIX = '${BUCKET_PREFIX_PROJECT_ID}-namespace-'" >> $FILE_PATH
echo "${VARIABLE_NAME_PROJECT_ID}_REDIS_IP_ADDRESS = '${REDIS_IP_ADDRESS}'" >> $FILE_PATH
echo "" >> $FILE_PATH
echo "PROJECT_GAE_LOCATIONS[${VARIABLE_NAME_PROJECT_ID}_PROJECT_ID] = '${PROJECT_REGION_VPC}'" >> $FILE_PATH
echo "${REGION_CODE}_BASED_PROJECTS.append(${VARIABLE_NAME_PROJECT_ID}_PROJECT_ID)" >> $FILE_PATH
echo "PROJECTS.append(${VARIABLE_NAME_PROJECT_ID}_PROJECT_ID)" >> $FILE_PATH
echo "WEB_AUDIENCES.append(${VARIABLE_NAME_PROJECT_ID}_DATAFLOW_SERVICE_ACCOUNT.client_id)" >> $FILE_PATH
echo "WEB_AUDIENCES.append(${VARIABLE_NAME_PROJECT_ID}_GENERATED_SERVICE_ACCOUNT.client_id)" >> $FILE_PATH
#echo "DATAFLOW_SERVICE_ACCOUNT_EMAILS.append(${VARIABLE_NAME_PROJECT_ID}_DATAFLOW_SERVICE_ACCOUNT.email)" >> $FILE_PATH
