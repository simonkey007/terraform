#!/bin/sh

set -e

export TF_IN_AUTOMATION="true"

HOME_DIR=$(pwd)

tar -xzf ${TERRAFORM_S3_DIRECTORY}/terraform.tgz

cp -R ${TERRAFORM_GIT_DIRECTORY}/. ${OUTPUT_DIRECTORY}



cd ${OUTPUT_DIRECTORY}
terraform init
terraform plan --var "env_name=${ENV}" --var "key=${KEY}" -out tfplan

cd ${HOME_DIR}
tar -czf terraform.tgz ${OUTPUT_DIRECTORY}
mv terraform.tgz ${OUTPUT_DIRECTORY}
