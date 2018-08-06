#!/bin/bash
HOME_DIR=$(pwd)
if [ -f ${TERRAFORM_STATE_DIRECTORY}/terraform.tfstate ]; then
  cp ${TERRAFORM_STATE_DIRECTORY}/terraform.tfstate ${TERRAFORM_TEMPLATE_DIRECTORY}
fi
cd ${TERRAFORM_TEMPLATE_DIRECTORY}
terraform init
terraform plan --var "env_name=${ENV}" -out ${HOME_DIR}/${OUTPUT_DIRECTORY}/plan
