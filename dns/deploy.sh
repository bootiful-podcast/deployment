#!/usr/bin/env bash

set -e
set -o pipefail

echo "Applying DNS configuration in $ROOT_DIR "

RESERVED_IP_NAME=bootiful-podcast-ip
gcloud compute addresses list --format json | jq '.[].name' -r | grep $RESERVED_IP_NAME || \
  gcloud compute addresses create $RESERVED_IP_NAME --global

kubectl apply -f ${ROOT_DIR}/dns

