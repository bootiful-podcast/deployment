#!/usr/bin/env bash

echo "Starting Deployment..."
source $GITHUB_WORKSPACE/.github/workflows/repository_utils.sh

## todo restore the gke bit
## todo make sure to replace all $CONFIG_DIR/* with $ROOT_DIR/module_name/*

export ROOT_DIR=$(cd ${GITHUB_WORKSPACE:-$(dirname $0)} && pwd )

echo "Assuming \$ROOT_DIR is $ROOT_DIR "

$ROOT_DIR/backup_pvc/deploy.sh
$ROOT_DIR/postgresql/deploy.sh
$ROOT_DIR/rabbitmq/deploy.sh
$ROOT_DIR/backup_cronjob/deploy.sh


## trigger the studio
#https://github.com/bootiful-podcast/api-v2/blob/master/.github/workflows/deploy.yml

deploy_system_app studio-v2
deploy_system_app api-v2
deploy_system_app site-generator-v2
deploy_system_app processor-v2

$ROOT_DIR/dns/deploy.sh

