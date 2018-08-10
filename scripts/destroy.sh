#!/bin/sh

set -e

export TF_IN_AUTOMATION="true"

mkdir ~/.ssh/
echo -e "${PRIVATE_KEY}" > ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa

export ANSIBLE_HOST_KEY_CHECKING=False

HOME_DIR=$(pwd)
tar -xzf  ${TERRAFORM_S3_DIRECTORY}/terraform.tgz
cd ${OUTPUT_DIRECTORY}
terraform destroy --var "env_name=${ENV}" --var "key=${KEY}"

cd ${HOME_DIR}
tar -czf terraform.tgz ${OUTPUT_DIRECTORY}
mv terraform.tgz ${OUTPUT_DIRECTORY}
