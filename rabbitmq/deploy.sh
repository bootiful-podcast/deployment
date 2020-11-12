#!/usr/bin/env bash
set -e
set -o pipefail

APP_NAME=rabbitmq

kubectl apply  -f <(echo "
---
apiVersion: v1
kind: Secret
metadata:
  name: ${APP_NAME}-secrets
type: Opaque
stringData:
  RABBITMQ_DEFAULT_USER: ${BP_RABBITMQ_MANAGEMENT_USERNAME}
  RABBITMQ_DEFAULT_PASS: ${BP_RABBITMQ_MANAGEMENT_PASSWORD}
")

kubectl apply -f $ROOT_DIR/rabbitmq/rabbitmq.yaml

