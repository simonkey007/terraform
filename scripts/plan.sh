#!/bin/bash
pwd
cd ${TERRAFORM_DIRECTORY}
terraform init

terraform plan --var "env_name=${ENV}" -out ${OUTPUT_DIRECTORY}/plan
