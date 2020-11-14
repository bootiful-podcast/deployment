#!/bin/bash
set -e
set -o pipefail

source .github/workflows/repository_utils.sh
export BP_MODE_LOWERCASE=${1:-development}
deploy_system_app deployment