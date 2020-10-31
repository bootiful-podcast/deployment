#!/usr/bin/env bash 
SUFFIX=${GKE_CLUSTER_ENVIRONMENT:-dev}
GKE_CLUSTER_NAME=bootiful-podcast-${SUFFIX}


## deploy the cluster if and only if the cluster doesn't already exist.

function deploy_new_gke_cluster(){

  ## first lets initialize the cluster
  gcloud beta container --project $GKE_PROJECT clusters create "${GKE_CLUSTER_NAME}" \
     --zone "us-central1-c" --no-enable-basic-auth --cluster-version "1.16.13-gke.401" \
     --machine-type "e2-standard-2" --image-type "COS" --disk-type "pd-standard" --disk-size "100" \
     --metadata disable-legacy-endpoints=true --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append","https://www.googleapis.com/auth/ndev.clouddns.readwrite" \
     --num-nodes "5" --enable-stackdriver-kubernetes --enable-ip-alias --network "projects/${GKE_PROJECT}/global/networks/default" \
     --subnetwork "projects/${GKE_PROJECT}/regions/us-central1/subnetworks/default" --default-max-pods-per-node "110" --no-enable-master-authorized-networks \
     --addons HorizontalPodAutoscaling,HttpLoadBalancing --enable-autoupgrade --enable-autorepair --max-surge-upgrade 1 --max-unavailable-upgrade 0


  ./deploy_bp_externaldns.sh

}

gcloud container clusters list | grep $GKE_CLUSTER_NAME ||  deploy_new_gke_cluster