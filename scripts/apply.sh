#!/bin/bash
HOME_DIR=$(pwd)
cd ${TERRAFORM_PLAN_DIRECTORY}
terraform apply "plan"
mv terraform.tfstate ${HOME_DIR}/${OUTPUT_DIRECTORY}/terraform.tfstate
