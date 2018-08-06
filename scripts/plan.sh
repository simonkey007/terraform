#!/bin/bash
HOME_DIR=$(pwd)

cd ${TERRAFORM_DIRECTORY}
terraform init

terraform plan --var "env_name=${ENV}" -out ${HOME_DIR}/${OUTPUT_DIRECTORY}/plan
