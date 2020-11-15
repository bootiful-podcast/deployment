#!/usr/bin/env bash

set -e
set -o pipefail


echo "Deploying Backup PVC..."

FS_NAME="bp-${BP_MODE_LOWERCASE}-backup-disk"

gcloud --quiet beta compute disks describe $FS_NAME --zone $GCLOUD_ZONE ||
  gcloud --quiet beta compute disks create $FS_NAME --type=pd-balanced --size=200GB --zone $GCLOUD_ZONE

KC=${ROOT_DIR}/backup_pvc/overlays/${BP_MODE_LOWERCASE}/
kubectl apply -k $KC
