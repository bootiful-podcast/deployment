#!/bin/bash
set -e

## This build assumes the use of Kustomize 
## https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/
#export BP_MODE_LOWERCASE=${BP_MODE_LOWERCASE:-development}
#export GCLOUD_ZONE=us-west1-b
#export GKE_CLUSTER_NAME=bootiful-podcast-${BP_MODE_LOWERCASE}
#export GCLOUD_PROJECT=${GCLOUD_PROJECT:-bootiful}

echo "Deploying to $BP_MODE_LOWERCASE "
#
#gcloud container clusters create cluster-name \
#  --enable-ip-alias --cluster-ipv4-cidr=10.0.0.0/21 \
#  --create-subnetwork=name='cluster-name-subnet',range=10.4.32.0/27 \
#  --services-ipv4-cidr=10.4.0.0/19 --default-max-pods-per-node=110 \
#  --zone=compute-zone

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
