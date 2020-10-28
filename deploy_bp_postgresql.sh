#!/usr/bin/env bash

APP_NAME=bp-postgresql
CONTAINER_NAME=postgres

kubectl apply -f <(echo "
---
apiVersion: v1
kind: Secret
metadata:
  name: ${APP_NAME}-secrets
type: Opaque
stringData:
  POSTGRES_USER: ${BP_POSTGRES_USERNAME:-test}
  POSTGRES_PASSWORD: ${BP_POSTGRES_PASSWORD:-test}
")

kubectl apply -f bp-postgresql.yaml

