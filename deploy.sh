#!/usr/bin/env bash

source $GITHUB_WORKSPACE/.github/workflows/repository_utils.sh
source $GITHUB_WORKSPACE/.github/workflows/config_client.sh

export ROOT_DIR=$(cd ${GITHUB_WORKSPACE:-$(dirname $0)} && pwd )

echo "Starting Deployment..."
echo "Assuming \$ROOT_DIR is $ROOT_DIR "




$ROOT_DIR/backup_pvc/deploy.sh
$ROOT_DIR/postgresql/deploy.sh
$ROOT_DIR/rabbitmq/deploy.sh
$ROOT_DIR/backup_cronjob/deploy.sh

deploy_system_app studio-v2
deploy_system_app api-v2
deploy_system_app site-generator-v2
deploy_system_app processor-v2

$ROOT_DIR/dns/deploy.sh