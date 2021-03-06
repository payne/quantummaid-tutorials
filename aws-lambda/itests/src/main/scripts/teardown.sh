#!/usr/bin/env bash

set -euo pipefail
my_dir="$(dirname "$(readlink -e "$0")")"
source "${my_dir}/shared.envrc"

function progress() {
  echo -e "\n==>" "$@"
}

if ${skip_teardown:-false}; then
  progress "skip_teardown is true, skipping..."
  exit 0
fi

progress "removing lambda stack..."
aws cloudformation delete-stack --region "${region}" --stack-name "${lambda_stack_name}"

progress "emptying source bucket..."
python3 -c "
import boto3
s3 = boto3.resource('s3')
bucket = s3.Bucket('${bucket_name}')
bucket.object_versions.delete()
"

progress "removing source bucket stack..."
aws cloudformation delete-stack --region "${region}" --stack-name "${bucket_stack_name}"
