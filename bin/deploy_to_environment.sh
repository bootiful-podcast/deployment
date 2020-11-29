#!/bin/bash
set -e
set -o pipefail

source .github/workflows/repository_utils.sh
export BP_MODE_LOWERCASE=${1:-development}
export GH_PERSONAL_ACCESS_TOKEN=${GH_PERSONAL_ACCESS_TOKEN:-$GITHUB_PERSONAL_ACCESS_TOKEN}
deploy_system_app deployment
