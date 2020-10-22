#!/usr/bin/env bash

APP_NAME=bp-rabbitmq

# kill the existing container
#cid=$( docker ps -a | grep $APP_NAME | cut -f1 -d\ )
#docker rm -f $cid

# https://codeburst.io/get-started-with-rabbitmq-on-docker-4428d7f6e46b
#docker run --rm -it --hostname ${APP_NAME}-leader-node -p 15672:15672 -p 5672:5672 rabbitmq:3.8.9-management

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
