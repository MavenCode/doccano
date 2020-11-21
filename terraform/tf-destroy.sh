#!/bin/bash
set -euo pipefail

# shellcheck disable=SC2006
KEY=`find . -name '*.key.json'`
echo "$KEY"

# shellcheck disable=SC2155
# shellcheck disable=SC2006
export GOOGLE_CREDENTIALS="../doccano-ai.key.json"
export ENVIRONMENT="dev"
export PROJECT_ID="mlops-kubeflow-00"

TERRAFORM_DIR=.

terraform init ${TERRAFORM_DIR}

terraform destroy -auto-approve \
        -var credentials=${GOOGLE_CREDENTIALS} \
        -var environment=${ENVIRONMENT} \
        -var-file=${TERRAFORM_DIR}/conf.tfvars ${TERRAFORM_DIR}