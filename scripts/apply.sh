#!/bin/sh

set -e

export TF_IN_AUTOMATION="true"

echo ${PRIVATE_KEY} > ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa

HOME_DIR=$(pwd)
tar -xzf  ${TERRAFORM_S3_DIRECTORY}/terraform.tgz
cd ${OUTPUT_DIRECTORY}
terraform apply -input=false "tfplan"

cd ${HOME_DIR}
tar -czf terraform.tgz ${OUTPUT_DIRECTORY}
mv terraform.tgz ${OUTPUT_DIRECTORY}
