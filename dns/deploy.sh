#!/usr/bin/env bash

set -e
set -o pipefail

echo "Applying DNS configuration in $ROOT_DIR "
RESERVED_IP_NAME=bootiful-podcast-${BP_MODE_LOWERCASE}-ip
gcloud compute addresses list --format json | jq '.[].name' -r | grep $RESERVED_IP_NAME || \
  gcloud compute addresses create $RESERVED_IP_NAME --global

KC=${ROOT_DIR}/dns/overlays/${BP_MODE_LOWERCASE}/

kubectl apply -f $KC
