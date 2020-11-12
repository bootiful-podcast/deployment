#!/usr/bin/env bash

set -e
set -o pipefail

echo "Deploying Backup PVC..."

FS_NAME="bp-backup-disk"

gcloud --quiet beta compute disks describe $FS_NAME --zone $GCLOUD_ZONE ||
  gcloud --quiet beta compute disks create $FS_NAME --type=pd-balanced --size=200GB --zone $GCLOUD_ZONE

kubectl apply -f $ROOT_DIR/backup_pvc/backup_pvc.yaml

#PV_VOLUME_NAME=$(  kubectl get pvc/bootiful-podcast-backup-pvc -o json |  jq '.spec.volumeName' -r )
#echo $PV_VOLUME_NAME
#kubectl patch pv $PV_VOLUME_NAME  -p '{"spec":{"persistentVolumeReclaimPolicy":"Retain"}}'
#
#
