#!/usr/bin/env bash
set -e
set -o pipefail

echo "Starting Deployment..."

## todo restore the gke bit
## todo make sure to replace all $CONFIG_DIR/* with $ROOT_DIR/module_name/*

export ROOT_DIR=$( cd  ${GITHUB_WORKSPACE:-$(dirname $0)} && pwd )

export BP_RABBITMQ_MANAGEMENT_USERNAME=rmq
export BP_RABBITMQ_MANAGEMENT_PASSWORD=rmq
export BP_POSTGRES_DB=bp
export BP_POSTGRES_USERNAME=admin
export BP_POSTGRES_PASSWORD=admin
export GCLOUD_ZONE=us-central1-c
$ROOT_DIR/deploy.sh