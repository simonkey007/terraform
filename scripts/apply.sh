#!/bin/sh

set -e

export TF_IN_AUTOMATION="true"

HOME_DIR=$(pwd)
tar -xzf  ${TERRAFORM_S3_DIRECTORY}/terraform.tgz
cd ${OUTPUT_DIRECTORY}
terraform apply -input=false "tfplan"

cd ${HOME_DIR}
tar -czf terraform.tgz ${OUTPUT_DIRECTORY}
mv terraform.tgz ${OUTPUT_DIRECTORY}
