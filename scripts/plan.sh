#!/bin/bash

terraform init

terraform plan --var "env_name=${ENV}"
