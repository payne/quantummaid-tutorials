#!/usr/bin/env bash

set -euo pipefail
my_dir="$(dirname "$(readlink -e "$0")")"
test_dir="$(dirname "$(dirname "${my_dir}")")/test/scripts"
source "${my_dir}/shared.envrc"

function progress() {
  echo -e "\n==>" "$@"
}

if ${skip_run_integration_tests:-false}; then
  progress "skip_run_integration_tests is true, skipping..."
fi

cd "${test_dir}"
for test_script in *-tests.sh; do
    progress "running ${test_script}..."
    bash "${test_script}"
done
