#!/bin/sh

set -e

export TF_IN_AUTOMATION="true"

HOME_DIR=$(pwd)
if [ -f ${TERRAFORM_STATE_DIRECTORY}/terraform.tfstate ]; then
  cp ${TERRAFORM_STATE_DIRECTORY}/terraform.tfstate ${TERRAFORM_TEMPLATE_DIRECTORY}
fi
cd ${TERRAFORM_TEMPLATE_DIRECTORY}
terraform init
terraform plan --var "env_name=${ENV}" -out tfplan
cp -R . ${HOME_DIR}/${OUTPUT_DIRECTORY}
cd ${HOME_DIR}
tar -czf terraform-plan.tgz ${OUTPUT_DIRECTORY}
mv terraform-plan.tgz ${OUTPUT_DIRECTORY}
