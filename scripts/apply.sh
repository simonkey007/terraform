#!/bin/sh

set -e

export TF_IN_AUTOMATION="true"

HOME_DIR=$(pwd)
tar -xzf  ${TERRAFORM_PLAN_DIRECTORY}/terraform-plan.tgz
cd ${OUTPUT_DIRECTORY}
terraform apply -input=false "tfplan"
