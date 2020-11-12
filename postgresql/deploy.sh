#!/usr/bin/env bash

set -e
set -o pipefail

cd ${ROOT_DIR}/postgresql

APP_NAME=postgresql
CONTAINER_NAME=postgres

CONFIG_MAP_NAME=${APP_NAME}-configmap
SECRETS_NAME=${APP_NAME}-secrets

kubectl delete deployment.apps/${APP_NAME} || echo "Could not delete the existing deployment"

kubectl delete service/postgres || echo "Could not delete old service"
kubectl delete deployment.apps/postgresql || echo "Could not delete old deployment "
kubectl delete secrets/${SECRETS_NAME} || echo "Could not delete old ${SECRETS_NAME}."
kubectl delete configmap/${CONFIG_MAP_NAME} || echo "Could not delete old ${CONFIG_MAP_NAME}."

kubectl get configmap/${CONFIG_MAP_NAME} | grep $CONFIG_MAP_NAME || kubectl create configmap $CONFIG_MAP_NAME --from-file $ROOT_DIR/postgresql/bin/
kubectl get configmap/${CONFIG_MAP_NAME} -o yaml

kubectl apply -f <(echo "
---
apiVersion: v1
kind: Secret
metadata:
  name: ${SECRETS_NAME}
type: Opaque
stringData:
  POSTGRES_DB: ${BP_POSTGRES_DB}
  POSTGRES_USER: ${BP_POSTGRES_USERNAME}
  POSTGRES_PASSWORD: ${BP_POSTGRES_PASSWORD}
")

kubectl apply -f postgresql.yaml
