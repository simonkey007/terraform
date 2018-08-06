#!/bin/bash
HOME_DIR=$(pwd)
cd ${TERRAFORM_PLAN_DIRECTORY}
terraform init
terraform apply "plan"
mv terraform.tfstate ${HOME_DIR}/${OUTPUT_DIRECTORY}/terraform.tfstate
