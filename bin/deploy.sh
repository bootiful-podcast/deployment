#!/bin/bash
set -e

## This build assumes the use of Kustomize 
## https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/
## 
## 

export BP_MODE_LOWERCASE=${BP_MODE_LOWERCASE:-development}
export ROOT_DIR=${PWD}
export GCLOUD_ZONE=us-west1-b
export OD=${ROOT_DIR}/overlays/${BP_MODE_LOWERCASE}
export GKE_CLUSTER_NAME=bootiful-podcast-${BP_MODE_LOWERCASE}
export GCLOUD_PROJECT=${GCLOUD_PROJECT:-bootiful}

## 
## Some sensible defaults 
export BP_RABBITMQ_MANAGEMENT_USERNAME=${BP_RABBITMQ_MANAGEMENT_USERNAME:-rmquser}
export BP_RABBITMQ_MANAGEMENT_PASSWORD=${BP_RABBITMQ_MANAGEMENT_PASSWORD:-rmqpw}
export POSTGRES_DB=${POSTGRES_DB:-bp}
export POSTGRES_USER=${POSTGRES_USER:-bp}
export POSTGRES_PASSWORD=${POSTGRES_PASSWORD:-pw}

echo "Deploying to $BP_MODE_LOWERCASE "




function deploy_new_gke_cluster() {
  gcloud --quiet beta container --project $GCLOUD_PROJECT clusters create "${GKE_CLUSTER_NAME}" \
    --zone "$GCLOUD_ZONE" --no-enable-basic-auth --cluster-version "1.17.13-gke.600" \
    --machine-type "c2-standard-4" --image-type "COS" \
    --metadata disable-legacy-endpoints=true --scopes "compute-rw,gke-default" \
    --num-nodes "2" --enable-stackdriver-kubernetes --enable-ip-alias \
    --no-enable-master-authorized-networks \
    --addons HorizontalPodAutoscaling,HttpLoadBalancing --enable-autoupgrade --enable-autorepair --max-surge-upgrade 1 --max-unavailable-upgrade 0

  echo "running after the cluster has been initiated..."
}

gcloud container clusters list | grep $GKE_CLUSTER_NAME || deploy_new_gke_cluster



echo "Backup PVC..."
FS_NAME="bp-${BP_MODE_LOWERCASE}-backup-disk"
gcloud --quiet beta compute disks describe $FS_NAME --zone $GCLOUD_ZONE || gcloud --quiet beta compute disks create $FS_NAME --type=pd-balanced --size=200GB --zone $GCLOUD_ZONE


## Setup a literal values file for the secrets 

RMQ_SECRETS_FN=${OD}/../development/rabbitmq-secrets.env
PSQL_SECRETS_FN=${OD}/../development/postgresql-secrets.env
echo "Writing secrets to ${RMQ_SECRETS_FN}"

cat <<EOF >${RMQ_SECRETS_FN}
RABBITMQ_DEFAULT_USER=${BP_RABBITMQ_MANAGEMENT_USERNAME}
RABBITMQ_DEFAULT_PASS=${BP_RABBITMQ_MANAGEMENT_PASSWORD}
EOF

cat <<EOF >${PSQL_SECRETS_FN}
POSTGRES_DB=${POSTGRES_DB}
POSTGRES_USER=${POSTGRES_USER}
POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
EOF

echo "Applying..."
kubectl apply -k ${OD} --prune --all

rm $RMQ_SECRETS_FN
rm $PSQL_SECRETS_FN