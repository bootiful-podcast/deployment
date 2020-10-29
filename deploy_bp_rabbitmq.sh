#!/usr/bin/env bash

APP_NAME=rabbitmq

for i in deployment service configmap secret ; do
  kubectl delete $i $(kubectl get $i | grep $APP_NAME | cut -f1 -d\ ) || \
      echo "could not find an existing $i to delete for app $APP_NAME"
done



kubectl apply -f <(echo "
---
apiVersion: v1
kind: Secret
metadata:
  name: ${APP_NAME}-secrets
type: Opaque
stringData:
  RABBITMQ_DEFAULT_USER: ${BP_RABBITMQ_MANAGEMENT_USERNAME:-guest}
  RABBITMQ_DEFAULT_PASS: ${BP_RABBITMQ_MANAGEMENT_PASSWORD:-guest}
")


kubectl apply -f bp-rabbitmq.yaml
