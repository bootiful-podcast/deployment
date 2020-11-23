#!/usr/bin/env bash

set -e
set -o pipefail

cd ${ROOT_DIR}/postgresql

APP_NAME=postgresql
CONTAINER_NAME=postgres

CONFIG_MAP_NAME=${APP_NAME}-configmap
SECRETS_NAME=${APP_NAME}-secrets

kubectl delete deployment.apps/${APP_NAME} || echo "Could not delete the existing deployment"

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
kubectl apply -f configmap.yaml
kubectl apply -f postgresql.yaml
